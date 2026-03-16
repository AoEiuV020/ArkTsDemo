#!/usr/bin/env node
/**
 * ETS编译模块
 * 调用script/buildEts.js并过滤输出
 */
const { spawn } = require('child_process')
const readline = require('readline')
const path = require('path')

const projectRoot = path.join(__dirname, '..', '..', '..', '..')
const buildEtsScript = path.join(projectRoot, 'script', 'buildEts.js')

// ANSI 颜色代码：红色=31/91, 黄色=33/93
const RED_CODES = ['\x1B[31m', '\x1B[91m']
const YELLOW_CODES = ['\x1B[33m', '\x1B[93m']

// 检测行的颜色级别
function getLineLevel(line) {
  if (RED_CODES.some(c => line.includes(c))) return 'error'
  if (YELLOW_CODES.some(c => line.includes(c))) return 'warn'
  return 'info'
}

// 去除 ANSI 颜色代码
function stripAnsi(str) {
  return str.replace(/\x1B\[[0-9;]*m/g, '')
}

// 追踪当前块的级别（用于处理无颜色的续行）
let currentBlockLevel = 'info'

function processLine(line) {
  const cleanLine = stripAnsi(line)
  let level = getLineLevel(line)

  // 过滤空行，但重置块级别
  if (cleanLine.trim() === '') {
    currentBlockLevel = 'info'
    return null
  }

  // 有颜色的行更新块级别
  if (level !== 'info') {
    currentBlockLevel = level
  } else {
    // 无颜色行继承当前块级别
    level = currentBlockLevel
  }

  // 过滤尖括号开头行
  if (cleanLine.startsWith('>')) {
    return null
  }

  // 过滤 * Try: 行
  if (cleanLine.includes('* Try:') || cleanLine.includes('Try:')) {
    return null
  }

  // 过滤 COMPILE RESULT 行
  if (cleanLine.includes('COMPILE RESULT:')) {
    return null
  }

  // 过滤错误/警告序号开头行（如 1 ERROR: 或 2 WARN:）
  if (/^\d+ (ERROR|WARN)/.test(cleanLine.trim())) {
    return null
  }

  // Error Message 行作为错误级别显示
  if (cleanLine.startsWith('Error Message:')) {
    return cleanLine
  }

  // 过滤签名配置提示
  if (cleanLine.includes('signingConfigs')) {
    return null
  }

  // 过滤堆栈跟踪信息
  if (cleanLine.trim().startsWith('at ')) {
    return null
  }

  // 过滤异常类名行
  if (/^[A-Za-z]+Error:/.test(cleanLine.trim())) {
    return null
  }

  // 只显示错误级别
  if (level !== 'error') {
    return null
  }

  return cleanLine
}

/**
 * 运行ETS编译
 * @returns {Promise<number>} 退出码
 */
function runEtsBuild() {
  return new Promise(resolve => {
    console.log('🔨 开始ETS编译...')

    const proc = spawn('node', [buildEtsScript], {
      stdio: ['inherit', 'pipe', 'pipe'],
      cwd: projectRoot,
    })

    const rl = readline.createInterface({ input: proc.stdout, terminal: false })
    const rlErr = readline.createInterface({
      input: proc.stderr,
      terminal: false,
    })

    function handleLine(rawLine) {
      const result = processLine(rawLine)
      if (result !== null) {
        console.log(result)
      }
    }

    rl.on('line', handleLine)
    rlErr.on('line', handleLine)

    proc.on('close', code => {
      if (code === 0) {
        console.log('✅ ETS编译成功')
      } else {
        console.error('❌ ETS编译失败')
      }
      resolve(code)
    })
  })
}

// 如果直接运行此脚本
if (require.main === module) {
  runEtsBuild().then(code => process.exit(code))
}

module.exports = { runEtsBuild }
