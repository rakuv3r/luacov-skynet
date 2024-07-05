<div align="center">
    <h1>LuaCov - Skynet</h1>
    <img src="./docs/logo/luacov-skynet.png" width="487"  alt=""/>
    <p align="center">
        Coverage analyzer for Skynet
    </p>
</div>

<br>

## 概述
`LuaCov-Skynet`是针对`Skynet`框架定制的覆盖率检测库。
该项目基于 [LuaCov](https://github.com/lunarmodules/luacov) 的拓展。其中`lcov`的生成格式来源于 [luacov-reporter-lcov](https://github.com/daurnimator/luacov-reporter-lcov)。

由于`LuaCov`本身是线程不安全的，所以每一个`actor`分别输出不同的文件。文件的后缀使用`.actor.{skynet.self()}`来拼接。
生成的原生覆盖率结果转换为`lcov`格式，通过 [lcov](https://man.archlinux.org/man/lcov.1.en) 命令进行合多`actor`的结果。然后通过 [diff-cover](https://github.com/Bachmann1234/diff_cover) 进行增量覆盖率以及页面生成。

## 下载安装
直接将`git`项目`clone`至项目`package.path`任意目录下即可。
为了提高检测文件的效率，相关方法调用的是`src/fileutil.c`生成的`so`库，针对项目的环境进行编译即可。也需要放在项目`package.path`任意目录下。

## 使用说明
### step.1 导入模块
所有需要检测覆盖率的`lua`代码开头增加
```lua
require("luacov.tick")
```

### step.2 生成原始文件
指定生成原始文件的文件标识名。
```lua
-- defaults.lua
report_lock_file = "luacov.report"
```
在项目主目录下`touch`即可。
对应的`reset`执行结果的文件标识名。
```lua
-- defaults.lua
result_report_lock_file = "luacov.report.reset"
```
`touch`后删除即可。

### step.3 转换为 lcov 格式
```shell
luacov -r lcov -s luacov.stats.out.actor.1
```
会自动在当前目录下生成`luacov.report.out.actor.1`的`lcov`格式的文件。

### setp.4 合并多 actor 的 lcov 文件
```shell
lcov -a luacov.stats.out.actor.1 -a luacov.stats.out.actor.2 -o luacov.report.out.lcov
```

创建`report_lock_file`后必须创建`luacov.report.reset`才能重置状态。
由于代码执行都是事件驱动的，所以没办法保证创建`report_lock_file`文件后就一定会有代码逻辑执行了每个`acotr`。为了保证覆盖率`100%`准确，业务方需要配合提供一个基于`skynet`可以调用所有`actor`的方法。

## 拓展
非`skynet`项目可以把`skynet.self()`替换成获取对应的进程`id`等唯一标识即可应用。