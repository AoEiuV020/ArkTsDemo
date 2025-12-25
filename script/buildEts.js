#!/usr/bin/env node
/**
 * ETS编译脚本（跨平台）
 * 调用hvigor编译并过滤输出
 */
const { spawn } = require('child_process')
const readline = require('readline')
const path = require('path')
const fs = require('fs')

// 检查DEVECO_HOME环境变量
const DEVECO_HOME = process.env.DEVECO_HOME
if (!DEVECO_HOME) {
  console.error('❌ 未设置DEVECO_HOME环境变量')
  process.exit(1)
}

// 确定node和hvigor路径
const isWindows = process.platform === 'win32'
const nodeExe = isWindows
  ? path.join(DEVECO_HOME, 'tools', 'node', 'node.exe')
  : path.join(DEVECO_HOME, 'tools', 'node', 'node')
const hvigorPath = path.join(
  DEVECO_HOME,
  'tools',
  'hvigor',
  'bin',
  'hvigorw.js',
)
const projectRoot = path.join(__dirname, '..')

// 触发增量编译：写入时间戳文件
const dateFile = path.join(
  projectRoot,
  'entry',
  'src',
  'main',
  'ets',
  'date.ets',
)
const timestamp = new Date().toISOString().replace('T', ' ').substring(0, 19)
fs.writeFileSync(dateFile, `// ${timestamp}\n`)

// 运行hvigor编译
const args = [
  hvigorPath,
  '--mode',
  'module',
  '-p',
  'module=entry@default',
  '-p',
  'product=default',
  '-p',
  'requiredDeviceType=phone',
  'assembleHap',
  '--analyze=normal',
  '--parallel',
  '--incremental',
  '--daemon',
]

const hvigor = spawn(nodeExe, args, {
  stdio: ['inherit', 'pipe', 'pipe'],
  cwd: projectRoot,
})

// 合并stdout和stderr
const rl = readline.createInterface({
  input: hvigor.stdout,
  terminal: false,
})
const rlErr = readline.createInterface({
  input: hvigor.stderr,
  terminal: false,
})

let skipUntilEmpty = false

function processLine(line) {
  // 遇到WARN开始跳过
  if (line.includes('WARN:')) {
    skipUntilEmpty = true
    return
  }

  // 跳过模式下，空行结束跳过
  if (skipUntilEmpty) {
    if (line.trim() === '') {
      skipUntilEmpty = false
    }
    return
  }

  // 过滤掉以 > 开头的行和空行
  if (line.startsWith('>') || line.trim() === '') {
    return
  }

  console.log(line)
}

rl.on('line', processLine)
rlErr.on('line', processLine)

hvigor.on('close', code => {
  if (code === 0) {
    console.log('✅ ETS编译成功')
  } else {
    console.error('❌ ETS编译失败')
    process.exit(1)
  }
})
