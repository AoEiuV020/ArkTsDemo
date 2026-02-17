#!/usr/bin/env node
/**
 * App打包脚本（跨平台）
 * 调用hvigor打包release版本app
 */
const { spawn } = require('child_process')
const path = require('path')
const fs = require('fs')

// 检查DEVECO_SDK_HOME环境变量
const DEVECO_SDK_HOME = process.env.DEVECO_SDK_HOME
if (!DEVECO_SDK_HOME) {
  console.error('❌ 未设置DEVECO_SDK_HOME环境变量')
  process.exit(1)
}

// 确定node和hvigor路径
const isWindows = process.platform === 'win32'
const nodeExe = isWindows
  ? path.join(DEVECO_SDK_HOME, 'tools', 'node', 'node.exe')
  : path.join(DEVECO_SDK_HOME, 'tools', 'node', 'bin', 'node')
const hvigorPath = path.join(
  DEVECO_SDK_HOME,
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

// 运行hvigor打包
const args = [
  hvigorPath,
  '--mode',
  'project',
  '-p',
  'product=default',
  '-p',
  'buildMode=release',
  'assembleApp',
  '--analyze=normal',
  '--parallel',
  '--incremental',
  '--daemon',
]

const hvigor = spawn(nodeExe, args, {
  stdio: 'inherit',
  cwd: projectRoot,
})

hvigor.on('close', code => {
  process.exit(code)
})
