import * as fs from 'fs';
import * as path from 'path';

// 从命令行参数获取文件名，默认为 'user'
const fileName = process.argv[2] || 'user';
const generatedDir = path.join(process.cwd(), 'src', 'generated');
const jsPath = path.join(generatedDir, `${fileName}.js`);
const dtsPath = path.join(generatedDir, `${fileName}.d.ts`);

function fixJs() {
    if (!fs.existsSync(jsPath)) {
        console.log(`文件不存在: ${jsPath}`);
        return;
    }

    let content = fs.readFileSync(jsPath, 'utf8');
    
    // 替换第二行的 import 语句
    content = content.replace(
        'import * as $protobuf from "protobufjs/minimal";',
        `import * as $protobuf from "@ohos/protobufjs";
import Long from 'long';
$protobuf.util.Long=Long
$protobuf.configure()`
    );
    
    fs.writeFileSync(jsPath, content);
    console.log(`已修改: ${jsPath}`);
}

function fixDts() {
    if (!fs.existsSync(dtsPath)) {
        console.log(`文件不存在: ${dtsPath}`);
        return;
    }

    let content = fs.readFileSync(dtsPath, 'utf8');
    
    // 替换第一行的 import 语句
    content = content.replace(
        'import * as $protobuf from "protobufjs";',
        'import * as $protobuf from "@ohos/protobufjs";'
    );
    
    fs.writeFileSync(dtsPath, content);
    console.log(`已修改: ${dtsPath}`);
}

function main() {
    console.log(`开始修复生成的文件: ${fileName}...`);
    fixJs();
    fixDts();
    console.log('修复完成!');
}

main();
