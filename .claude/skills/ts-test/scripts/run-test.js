#!/usr/bin/env node
/**
 * TypeScript测试运行脚本
 * 封装pnpm test并自动过滤输出，只显示关键信息
 *
 * 用法:
 *   node run-test.js                      # 运行所有测试
 *   node run-test.js --filter example     # 运行指定模块
 *   node run-test.js --filter example api-error.test.ts  # 指定文件
 *   node run-test.js --filter example -t "ApiError"      # 按名称过滤
 */
const { spawn } = require('child_process')
const readline = require('readline')
const path = require('path')

// ===== 主入口 =====

main()

function main() {
  const projectRoot = path.join(__dirname, '..', '..', '..')
  const pnpmArgs = buildPnpmArgs()

  const state = createState()
  const pnpm = runPnpm(pnpmArgs, projectRoot)

  setupOutputHandlers(pnpm, state)

  pnpm.on('close', code => {
    finalizeState(state)
    printResults(state)
    process.exit(code === 0 ? 0 : 1)
  })
}

// ===== 参数解析 =====

function buildPnpmArgs() {
  const args = process.argv.slice(2)
  let pnpmArgs = ['test']

  const filterIndex = args.indexOf('--filter')
  if (filterIndex !== -1 && args[filterIndex + 1]) {
    pnpmArgs = ['--filter', args[filterIndex + 1], 'test']
    args.splice(filterIndex, 2)
  }

  // 剩余参数传给vitest
  if (args.length > 0) {
    pnpmArgs.push(...args)
  }

  return pnpmArgs
}

// ===== 进程管理 =====

function runPnpm(args, cwd) {
  return spawn('pnpm', args, {
    stdio: ['inherit', 'pipe', 'pipe'],
    cwd,
    shell: true,
  })
}

function setupOutputHandlers(pnpm, state) {
  const rl = readline.createInterface({ input: pnpm.stdout, terminal: false })
  const rlErr = readline.createInterface({
    input: pnpm.stderr,
    terminal: false,
  })

  const handler = line => processLine(line, state)
  rl.on('line', handler)
  rlErr.on('line', handler)
}

// ===== 状态管理 =====

function createState() {
  return {
    currentModule: '',
    passedModules: [],
    failedModules: [],
    inFailedSection: false,
    currentTestError: null,
    testErrors: [],
  }
}

function finalizeState(state) {
  // 保存最后一个错误
  if (state.currentTestError && state.currentTestError.reason) {
    state.testErrors.push(state.currentTestError)
    state.currentTestError = null
  }
}

// ===== 输出解析 =====

const PATTERNS = {
  moduleStart: /^> (\S+)@\S+ test/,
  testSummaryPassed: /Test Files\s+(\d+) passed/,
  testSummaryFailed: /Test Files\s+(\d+) failed/,
  failedTestsHeader: /Failed Tests \d+/,
  failDetail: /FAIL\s+__tests__\/(\S+\.ts)\s*>\s*(.+)$/,
  errorLine: /^(AssertionError|TypeError|ApiError|Error):\s*(.+)$/,
  codeLocation: /❯\s*__tests__\/(\S+\.ts):(\d+)/,
  srcLocation: /❯\s*(\S+\.ts):(\d+)/,
  arrowError: /→\s*(.+)$/,
}

function stripAnsi(str) {
  return str.replace(/\x1B\[[0-9;]*m/g, '')
}

function processLine(rawLine, state) {
  const line = stripAnsi(rawLine).trim()

  if (line === '') {
    handleEmptyLine(state)
    return
  }

  if (tryParseModuleStart(line, state)) return
  if (tryParseTestSummary(line, state)) return
  if (tryParseFailedSection(line, state)) return
  if (state.inFailedSection) {
    parseFailedSectionLine(line, state)
  }
}

function handleEmptyLine(state) {
  if (state.currentTestError && state.currentTestError.reason) {
    state.testErrors.push(state.currentTestError)
    state.currentTestError = null
  }
}

function tryParseModuleStart(line, state) {
  const match = line.match(PATTERNS.moduleStart)
  if (match) {
    state.currentModule = match[1]
    state.inFailedSection = false
    return true
  }
  return false
}

function tryParseTestSummary(line, state) {
  // 成功汇总
  if (PATTERNS.testSummaryPassed.test(line) && !line.includes('failed')) {
    if (state.currentModule) {
      state.passedModules.push(state.currentModule)
    }
    state.inFailedSection = false
    return true
  }

  // 失败汇总
  const failedMatch = line.match(PATTERNS.testSummaryFailed)
  if (failedMatch) {
    state.failedModules.push({
      name: state.currentModule,
      failed: parseInt(failedMatch[1]),
    })
    state.inFailedSection = false
    return true
  }

  return false
}

function tryParseFailedSection(line, state) {
  if (PATTERNS.failedTestsHeader.test(line)) {
    state.inFailedSection = true
    return true
  }
  return false
}

function parseFailedSectionLine(line, state) {
  // 失败测试详情开头
  const failMatch = line.match(PATTERNS.failDetail)
  if (failMatch) {
    saveCurrentError(state)
    state.currentTestError = {
      file: failMatch[1],
      name: failMatch[2].trim(),
      reason: '',
      location: '',
      stack: [],
    }
    return
  }

  if (!state.currentTestError) return

  // 错误信息
  const errorMatch = line.match(PATTERNS.errorLine)
  if (errorMatch) {
    state.currentTestError.reason = errorMatch[2].substring(0, 100)
    return
  }

  // 箭头错误
  const arrowMatch = line.match(PATTERNS.arrowError)
  if (arrowMatch && !state.currentTestError.reason) {
    state.currentTestError.reason = arrowMatch[1].substring(0, 100)
    return
  }

  // 代码位置
  const locMatch = line.match(PATTERNS.codeLocation)
  if (locMatch) {
    state.currentTestError.location = `${locMatch[1]}#L${locMatch[2]}`
    return
  }

  // 源码堆栈
  const srcMatch = line.match(PATTERNS.srcLocation)
  if (srcMatch && line.includes('src/')) {
    state.currentTestError.stack.push(`${srcMatch[1]}#L${srcMatch[2]}`)
  }
}

function saveCurrentError(state) {
  if (state.currentTestError && state.currentTestError.reason) {
    state.testErrors.push(state.currentTestError)
  }
}

// ===== 结果输出 =====

function printResults(state) {
  console.log('\n=== 测试结果汇总 ===\n')

  printPassedModules(state)
  printFailedModules(state)
  printTestErrors(state)
  printFinalStatus(state)
}

function printPassedModules(state) {
  if (state.passedModules.length > 0) {
    console.log(`✅ 成功: ${state.passedModules.join(', ')}`)
  }
}

function printFailedModules(state) {
  if (state.failedModules.length > 0) {
    console.log(`\n❌ 失败模块:`)
    state.failedModules.forEach(m => {
      console.log(`   ${m.name}: ${m.failed} failed`)
    })
  }
}

function printTestErrors(state) {
  if (state.testErrors.length > 0) {
    console.log('\n=== 失败测试详情 ===')
    state.testErrors.forEach(err => {
      console.log(`\n❌ ${err.file}: ${err.name}`)
      if (err.reason) console.log(`   原因: ${err.reason}`)
      if (err.location) console.log(`   位置: ${err.location}`)
      if (err.stack.length > 0) {
        err.stack.forEach(s => console.log(`   堆栈: ${s}`))
      }
    })
  }
}

function printFinalStatus(state) {
  if (state.failedModules.length === 0) {
    console.log('\n✅ 所有测试通过!')
  } else {
    console.log('\n❌ 存在测试失败')
  }
}
