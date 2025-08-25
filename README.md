<div align="center">
    <h1>LuaCov-Skynet</h1>
    <img src="./docs/logo/luacov-skynet.png" width="487" alt=""/>
    <p>Code coverage tool for Skynet framework</p>
</div>

[中文](docs/README-zh.md)

## What is LuaCov-Skynet

LuaCov-Skynet is a modified version of [LuaCov](https://github.com/lunarmodules/luacov) designed specifically for the Skynet framework.

The original LuaCov has data conflicts in Skynet's multi-actor environment. This version solves the problem by creating separate files for each actor.

## How to Use

### 1. Download and Compile

```bash
git clone https://github.com/rakuv3r/luacov-skynet.git
cd luacov-skynet
gcc -shared -fPIC -o src/fileutil.so src/fileutil.c
```

### 2. Add to Your Code

```lua
require("luacov.tick")
```

### 3. Run Your Program

```bash
# Start coverage collection
touch luacov.report

# Run your skynet program
./your_program

# Generate report
luacov -r lcov -s luacov.stats.out.actor.1

# For multiple actors, merge results
lcov -a luacov.stats.out.actor.1 -a luacov.stats.out.actor.2 -o coverage.lcov
```

## Key Features

- Each actor creates separate `.actor.{id}` files to avoid data conflicts
- Control coverage collection through file creation/deletion
- Use C extension module for better file detection performance
- Support LCOV format output

## Configuration

Create `.luacov` file in project root:

```lua
return {
  statsfile = "luacov.stats.out",
  reportfile = "luacov.report.out",
  include = {"^src/"},
  exclude = {"test/"}
}
```

## Control Commands

| Action | Method |
|--------|--------|
| Start collection | `touch luacov.report` |
| Reset data | `touch luacov.reset` |
| Stop collection | Remove `luacov.doing` file |

## Common Issues

**Failed to compile fileutil.so**
- Make sure gcc compiler is installed
- Check write permissions

**No coverage data generated**
- Confirm `luacov.doing` file exists
- Check if `require("luacov.tick")` is called correctly

**Multiple actor data problems**
- Check if multiple `.actor.{id}` files are generated
- Use `lcov` command to merge files correctly

## How It Works

When the program runs:
1. Store coverage data in global variables
2. Start a 1-second timer to check control files
3. Save or reset data based on file existence
4. Each actor writes to separate stats files

File monitoring interval is 1 second. We recommend at least 2 seconds between control file operations.

## License

[MIT License](LICENSE)