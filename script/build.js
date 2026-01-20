#!/usr/bin/env node
/**
 * TS编译脚本（跨平台）
 * 调用pnpm build，从任意目录都可运行
 */
const { spawn } = require('child_process')
const readline = require('readline')
const path = require('path')

// 定位项目根目录（脚本所在目录的上级目录）
const projectRoot = path.join(__dirname, '..')

// 去除 ANSI 颜色代码
function stripAnsi(str) {
  return str.replace(/\x1B\[[0-9;]*m/g, '')
}

// 运行pnpm build
const build = spawn('pnpm', ['build'], {
  stdio: ['pipe', 'pipe', 'pipe'],
  cwd: projectRoot,
  shell: true,
})

let outputLines = []

// 合并stdout和stderr
const rl = readline.createInterface({
  input: build.stdout,
  terminal: false,
})
const rlErr = readline.createInterface({
  input: build.stderr,
  terminal: false,
})

function processLine(line) {
  const cleanLine = stripAnsi(line)
  
  // 存储所有输出
  outputLines.push(cleanLine)
}

rl.on('line', processLine)
rlErr.on('line', processLine)

build.on('close', code => {
  if (code === 0) {
    console.log('✅ TS编译成功')
  } else {
    console.error('❌ TS编译失败')
    // 过滤掉空行、>开头的非报错部分、npm错误输出、生命周期错误
    for (const line of outputLines) {
      const cleanLine = line.trim()
      if (cleanLine === '' || line.startsWith('>') || line.match(/^\s*>/) || line.startsWith('npm error') || line.startsWith('npm WARN') || line.includes('ELIFECYCLE') || line.includes('pm run')) {
        continue
      }
      console.log(line)
    }
    process.exit(1)
  }
})
