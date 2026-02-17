#!/usr/bin/env node
/**
 * 编译检查脚本
 * 支持mode参数: ts, ets, all(默认)
 *
 * 用法:
 *   node build.js [mode]
 *   node build.js ts    # 仅TS编译
 *   node build.js ets   # 仅ETS编译
 *   node build.js all   # 全部编译(默认)
 */
const { runTsBuild } = require('./build-ts')
const { runEtsBuild } = require('./build-ets')

const mode = process.argv[2] || 'all'

async function main() {
  let exitCode = 0

  if (mode === 'all' || mode === 'ts') {
    const tsResult = await runTsBuild()
    if (tsResult !== 0) exitCode = tsResult
  }

  if (mode === 'all' || mode === 'ets') {
    const etsResult = await runEtsBuild()
    if (etsResult !== 0) exitCode = etsResult
  }

  process.exit(exitCode)
}

main()
