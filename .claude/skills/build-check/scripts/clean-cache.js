/**
 * 清理 ETS 编译缓存
 * 用法: node clean-cache.js [module-name]
 *
 * 示例:
 *   node clean-cache.js           # 清理所有模块缓存
 *   node clean-cache.js im_ui_chat # 清理指定模块缓存
 */

const fs = require('fs')
const path = require('path')

const projectRoot = path.resolve(__dirname, '../../../..')

// 需要清理的目录列表
const CACHE_DIRS = ['.hvigor', 'build', '.preview']

function removeDir(dirPath) {
  if (fs.existsSync(dirPath)) {
    fs.rmSync(dirPath, { recursive: true, force: true })
    console.log(`删除: ${path.relative(projectRoot, dirPath)}`)
    return true
  }
  return false
}

function cleanModuleCache(modulePath) {
  let cleaned = 0
  for (const cacheDir of CACHE_DIRS) {
    const cachePath = path.join(modulePath, cacheDir)
    if (removeDir(cachePath)) {
      cleaned++
    }
  }
  return cleaned
}

function getAllModules() {
  const modules = []

  // oh_packages 目录
  const ohPackagesDir = path.join(projectRoot, 'oh_packages')
  if (fs.existsSync(ohPackagesDir)) {
    const dirs = fs.readdirSync(ohPackagesDir, { withFileTypes: true })
    for (const dir of dirs) {
      if (dir.isDirectory() && !dir.name.startsWith('.')) {
        modules.push({
          name: dir.name,
          path: path.join(ohPackagesDir, dir.name),
        })
      }
    }
  }

  // entry 目录
  const entryDir = path.join(projectRoot, 'entry')
  if (fs.existsSync(entryDir)) {
    modules.push({
      name: 'entry',
      path: entryDir,
    })
  }

  return modules
}

function main() {
  const moduleName = process.argv[2]

  console.log('清理 ETS 编译缓存...\n')

  let totalCleaned = 0

  if (moduleName) {
    // 清理指定模块
    const modules = getAllModules()
    const targetModule = modules.find(m => m.name === moduleName)

    if (!targetModule) {
      console.error(`错误: 找不到模块 "${moduleName}"`)
      console.log('可用模块:', modules.map(m => m.name).join(', '))
      process.exit(1)
    }

    console.log(`清理模块: ${moduleName}`)
    totalCleaned = cleanModuleCache(targetModule.path)
  } else {
    // 清理所有模块
    const modules = getAllModules()

    // 先清理项目根目录的 .hvigor
    const rootHvigor = path.join(projectRoot, '.hvigor')
    if (removeDir(rootHvigor)) {
      totalCleaned++
    }

    // 清理所有模块
    for (const mod of modules) {
      const cleaned = cleanModuleCache(mod.path)
      totalCleaned += cleaned
    }
  }

  if (totalCleaned > 0) {
    console.log(`\n✅ 清理完成，共删除 ${totalCleaned} 个目录`)
  } else {
    console.log('\n无需清理，缓存目录不存在')
  }
}

main()
