#!/usr/bin/env node
/**
 * TypeScript编译模块
 * 运行pnpm build并过滤输出（参考script/build.js）
 */
const { spawn } = require('child_process')
const readline = require('readline')
const path = require('path')

const projectRoot = path.join(__dirname, '..', '..', '..', '..')

/**
 * 去除 ANSI 颜色代码
 */
function stripAnsi(str) {
  return str.replace(/\x1B\[[0-9;]*m/g, '')
}

/**
 * 判断行是否应该跳过（参考原script/build.js）
 */
function shouldSkipLine(line) {
  const cleanLine = line.trim()
  if (cleanLine === '') return true
  if (line.startsWith('>')) return true
  if (line.match(/^\s*>/)) return true
  if (line.startsWith('npm error')) return true
  if (line.startsWith('npm WARN')) return true
  if (line.includes('ELIFECYCLE')) return true
  if (line.includes('pm run')) return true
  return false
}

/**
 * 运行TS编译
 * @returns {Promise<number>} 退出码
 */
function runTsBuild() {
  return new Promise(resolve => {
    console.log('🔨 开始TS编译...')

    const proc = spawn('pnpm', ['build'], {
      stdio: ['inherit', 'pipe', 'pipe'],
      cwd: projectRoot,
      shell: true,
    })

    const outputLines = []

    function processLine(rawLine) {
      const cleanLine = stripAnsi(rawLine)
      outputLines.push(cleanLine)
    }

    const rl = readline.createInterface({ input: proc.stdout, terminal: false })
    const rlErr = readline.createInterface({
      input: proc.stderr,
      terminal: false,
    })

    rl.on('line', processLine)
    rlErr.on('line', processLine)

    proc.on('close', code => {
      if (code === 0) {
        console.log('✅ TS编译成功')
      } else {
        console.error('❌ TS编译失败')
        // 过滤并输出错误信息
        for (const line of outputLines) {
          if (!shouldSkipLine(line)) {
            console.log(line)
          }
        }
      }
      resolve(code)
    })
  })
}

// 如果直接运行此脚本
if (require.main === module) {
  runTsBuild().then(code => process.exit(code))
}

module.exports = { runTsBuild }
