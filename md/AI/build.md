
1. 你看看把build.sh参考buildEts.js改出一个build.js然后运行，

1. 调整.github/instructions/build.instructions.md使用新脚本， 而且不需要cd了，

1. 调整.github/instructions/feedback.instructions.md 改成ask_user

1. 随便改点错误代码测试一下script/build.js

1. 不是说了不需要cd，你看.github/instructions/build.instructions.md要强调一下，

1. .github/instructions/build.instructions.md:7你这怎么还有cd，我说了运行编译不需要额外的cd，文档这样写， 你也得这样做， 
同时脚本要支持任意目录运行，

1. 你干嘛非要运行cd？

1. 我让你在文档里明确，不需要cd，

1. 然后运行测试编译脚本啊，这还要我说？

1. test代码压根不会被编译， 你怎么测的编译脚本？

1. 别想那么多了， 找个index改改看， 还是没报错就先把过滤去掉测试，

1. 还要检查过滤有没有达到script\build.sh的效果，
