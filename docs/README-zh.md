<div align="center">
    <h1>LuaCov-Skynet</h1>
    <img src="logo/luacov-skynet.png" width="487" alt=""/>
    <p>Skynet 代码覆盖率工具</p>
    
    [English](../README.md)
</div>

## 什么是 LuaCov-Skynet

这是基于 [LuaCov](https://github.com/lunarmodules/luacov) 改进的版本，专门用于 Skynet 框架。

原版 LuaCov 在 Skynet 的多 actor 环境中会出现数据冲突问题。这个版本通过为每个 actor 生成独立文件来解决这个问题。

## 如何使用

### 1. 下载和编译

```bash
git clone https://github.com/rakuv3r/luacov-skynet.git
cd luacov-skynet
gcc -shared -fPIC -o src/fileutil.so src/fileutil.c
```

### 2. 在代码中添加

```lua
require("luacov.tick")
```

### 3. 运行程序

```bash
# 启动覆盖率收集
touch luacov.report

# 运行你的 skynet 程序
./your_program

# 生成报告
luacov -r lcov -s luacov.stats.out.actor.1

# 如果有多个 actor，合并结果
lcov -a luacov.stats.out.actor.1 -a luacov.stats.out.actor.2 -o coverage.lcov
```

## 主要改动

- 每个 actor 生成独立的 `.actor.{id}` 文件，避免数据冲突
- 通过文件创建/删除来控制覆盖率收集
- 使用 C 扩展模块提高文件检测性能
- 支持 LCOV 格式输出

## 配置文件

在项目根目录创建 `.luacov` 文件：

```lua
return {
  statsfile = "luacov.stats.out",
  reportfile = "luacov.report.out",
  include = {"^src/"},
  exclude = {"test/"}
}
```

## 控制方式

| 操作 | 方法 |
|------|------|
| 开始收集 | `touch luacov.report` |
| 重置数据 | `touch luacov.reset` |
| 停止收集 | 删除 `luacov.doing` 文件 |

## 常见问题

**编译 fileutil.so 失败**
- 确保系统有 gcc 编译器
- 检查是否有写权限

**没有生成覆盖率数据**
- 确认已创建 `luacov.doing` 文件
- 检查是否正确调用了 `require("luacov.tick")`

**多个 actor 数据异常**
- 检查是否生成了多个 `.actor.{id}` 文件
- 使用 `lcov` 命令正确合并文件

## 技术细节

程序运行时会：
1. 在全局变量中存储覆盖率数据
2. 启动 1 秒间隔的定时器检查控制文件
3. 根据文件存在状态决定保存或重置数据
4. 每个 actor 写入独立的统计文件

文件监控间隔为 1 秒，建议控制文件的操作间隔 2 秒以上。

## 许可证

[MIT License](../LICENSE)