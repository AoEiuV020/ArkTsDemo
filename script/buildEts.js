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
  : path.join(DEVECO_HOME, 'tools', 'node', 'bin', 'node')
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

// 日志级别：error=只显示错误, warn=显示警告和错误, all=显示全部
const logLevel = process.argv[2] || 'error'

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

// 根据日志级别判断是否应该显示
function shouldShow(level) {
  if (logLevel === 'all') return true
  if (logLevel === 'warn') return level === 'error' || level === 'warn'
  return level === 'error'
}

// 追踪当前块的级别（用于处理无颜色的续行）
let currentBlockLevel = 'info'

function processLine(line) {
  const cleanLine = stripAnsi(line)
  let level = getLineLevel(line)

  // 过滤空行，但重置块级别
  if (cleanLine.trim() === '') {
    currentBlockLevel = 'info'
    return
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
    return
  }

  // 过滤 * Try: 行
  if (cleanLine.includes('* Try:') || cleanLine.includes('Try:')) {
    return
  }

  // 过滤 COMPILE RESULT 行
  if (cleanLine.includes('COMPILE RESULT:')) {
    return
  }

  // 过滤错误/警告序号开头行（如 1 ERROR: 或 2 WARN:）
  if (/^\d+ (ERROR|WARN)/.test(cleanLine.trim())) {
    return
  }

  // Error Message 行作为错误级别显示
  if (cleanLine.startsWith('Error Message:')) {
    if (shouldShow('error')) {
      console.log(cleanLine)
    }
    return
  }

  // 过滤签名配置提示
  if (cleanLine.includes('signingConfigs')) {
    return
  }

  // 根据颜色级别过滤
  if (!shouldShow(level)) {
    return
  }

  console.log(cleanLine)
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
