/**
 * 导出携带submodule的源码包
 * 使用 git-archive-all 打包，输出到 ln/output 目录
 *
 * 参数（均可选）：
 *   --project <path>  项目路径（默认当前git仓库根目录）
 *   --output <path>   输出目录（默认 ln/output）
 *   --format <type>   导出格式 zip/tar.gz（默认 zip）
 */
const { execSync } = require('child_process')
const path = require('path')
const fs = require('fs')

function parseArgs() {
  const args = process.argv.slice(2)
  const result = { project: undefined, output: undefined, format: 'zip' }
  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--project' && args[i + 1]) {
      result.project = args[++i]
    } else if (args[i] === '--output' && args[i + 1]) {
      result.output = args[++i]
    } else if (args[i] === '--format' && args[i + 1]) {
      result.format = args[++i]
    }
  }
  return result
}

const args = parseArgs()

// 获取项目根目录
const projectRoot = args.project
  ? path.resolve(args.project)
  : execSync('git rev-parse --show-toplevel', { encoding: 'utf-8' }).trim()
const projectName = path.basename(projectRoot)

// 输出目录
const outputDir = args.output
  ? path.resolve(args.output)
  : path.join(projectRoot, 'ln', 'output')
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true })
}

// 获取commit短hash
const commitHash = execSync('git rev-parse --short HEAD', {
  cwd: projectRoot,
  encoding: 'utf-8',
}).trim()

// 获取日期 YYYYMMDD
const now = new Date()
const datetime =
  now.getFullYear().toString() +
  (now.getMonth() + 1).toString().padStart(2, '0') +
  now.getDate().toString().padStart(2, '0')

// 构建输出文件路径
const format = args.format
const fileName = `${projectName}_${commitHash}_${datetime}.${format}`
const outputFile = path.join(outputDir, fileName)

console.log(`项目: ${projectName}`)
console.log(`Commit: ${commitHash}`)
console.log(`格式: ${format}`)
console.log(`输出: ${outputFile}`)

// 执行 git-archive-all
try {
  execSync(`git-archive-all --prefix "" "${outputFile}"`, {
    cwd: projectRoot,
    stdio: 'inherit',
  })

  const stats = fs.statSync(outputFile)
  const sizeMB = (stats.size / (1024 * 1024)).toFixed(2)
  console.log(`✅ 导出成功: ${fileName} (${sizeMB} MB)`)
} catch (error) {
  console.error('❌ 导出失败:', error.message)
  process.exit(1)
}
