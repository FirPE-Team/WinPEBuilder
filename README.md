# WinPEBuilder

## 简介

WinPEBuilder 是用于构建 WindowsPE 的批处理库，内含常用的宏命令，可快速实现对基础 boot.wim/winre.wim 进行修改。

## WinPE 项目

在 Project 目录中用于存放 WinPE 制作项目脚本，可创建多个目录表示不同的项目。

### 项目流程

1. 提取基础镜像(`boot.wim`/`winre.wim`)
2. 挂载基础镜像
3. 执行 WinPE 项目脚本（`\Project`）
4. 卸载基础镜像
5. 导出镜像及清理临时文件
6. 项目完成

### 注册表挂载路径

- 基础镜像：
  - `SOFTWARE`: `HKLM\Tmp_SOFTWARE`
  - `SYSTEM`: `HKLM\Tmp_SYSTEM`
  - `DEFAULT`: `HKLM\Tmp_DEFAULT`
  - `DRIVERS`: `HKLM\Tmp_DRIVERS`
  - `NTUSER.DAT`: `HKLM\Tmp_NTUSER.DAT`

- 安装镜像：
  - `SOFTWARE`: `HKLM\Src_SOFTWARE`
  - `SYSTEM`: `HKLM\Src_SYSTEM`
  - `DEFAULT`: `HKLM\Src_DEFAULT`
  - `DRIVERS`: `HKLM\Src_DRIVERS`
  - `NTUSER.DAT`: `HKLM\Src_NTUSER.DAT`

### 内置环境变量

WinPEBuilder 中内置了许多环境变量，可直接在脚本中进行使用。

- `%X%`: 基础镜像挂载目录
- `%X_WIN%`: `\Windows`目录
- `%X_SYS%`: `\Windows\System32`目录
- `%X_WOW64%`: `\Windows\SysWOW64`目录
- `%X_Desktop%`: `\Users\Default\Desktop`目录

### 可配置环境变量

以下环境变量可以在运行WinPEBuilder之前设置，以控制构建行为：

- `APP_OPT_MAKE_ISO`: 设置为`1`时，构建完成后自动生成ISO镜像
  ```batch
  set APP_OPT_MAKE_ISO=1
  WinPEBuilder.cmd --source-folder I: --project Windows11PE
  ```

### 脚本执行顺序

1. `Project\项目名称\main.cmd`
2. `Project\项目名称\`下的各个目录中的`main.cmd`
3. `Project\项目名称\`下的各个目录中的`last.cmd`
4. `Project\项目名称\last.cmd`

## Hooks

WinPEBuilder 提供了 Hooks 机制，允许在构建过程的关键节点执行自定义脚本。Hooks 脚本应放置在项目目录的根目录下，与 `main.cmd` 同级。

### 可用的 Hook 点

| 序号 | Hook 名称              | 执行时机         | 用途                       |
| ---- | ---------------------- | ---------------- | -------------------------- |
| 1    | `before-mount.cmd`     | 挂载基础镜像之前 | 准备工作，如提取额外文件   |
| 2    | `after-mount.cmd`      | 挂载基础镜像之后 | 对已挂载的镜像进行初步处理 |
| 3    | `before-mount-reg.cmd` | 挂载注册表之前   | 准备注册表相关操作         |
| 4    | `after-mount-reg.cmd`  | 挂载注册表之后   | 注册表修改和配置           |
| 5    | `before-project.cmd`   | 执行项目脚本之前 | 项目执行前的准备工作       |
| 6    | `after-project.cmd`    | 执行项目脚本之后 | 项目执行后的清理工作       |
| 7    | `before-commit.cmd`    | 提交镜像更改之前 | 最终调整和优化             |
| 8    | `finished.cmd`         | 构建完成后       | 构建完成后的清理和通知     |

### Hook 脚本示例

- /Project/项目名称/before-mount-reg.cmd

  ```batch
  rem 提取原版SOFTWARE注册表
  call AddFiles \Windows\System32\config\SOFTWARE
  ```

- /Project/项目名称/after-mount-reg.cmd

  ```batch
  rem 修改注册表设置
  reg add "HKLM\Tmp_SYSTEM\ControlSet001\Control\ComputerName\ComputerName" /v "ComputerName" /t REG_SZ /d "WinPE" /f
  ```

### 注意事项

- Hook 脚本必须放在项目目录的根目录下
- Hook 脚本名称必须完全匹配，包括扩展名 `.cmd`
- 如果 Hook 脚本不存在，WinPEBuilder 将跳过该 Hook 点继续执行
- Hook 脚本执行失败时会显示警告，但不会中断构建过程

## 宏指令

### AddFiles

从install系统镜像中提取文件到基础镜像中。

#### 基本语法

```batch
call AddFiles [file_list] [label]
```

- `file_list`: 文件列表，可以是单个文件、多个文件（逗号分隔）或通配符
- `label`: 多行模式时的标签（如`:end_files`）

#### 使用模式

**单行模式** - 直接指定文件列表

```batch
call AddFiles \Windows\System32\notepad.exe
call AddFiles \Windows\System32\*.dll
call AddFiles "\Windows\System32\notepad.exe,calc.exe"
```

**多行模式** - 从当前脚本中读取文件列表

```batch
call AddFiles %0 :end_files
goto :end_files

\Windows\explorer.exe
\Windows\System32\notepad.exe
:end_files
```

#### 核心功能

**1. 路径前缀 (@指令)**

简化重复路径的书写：

```batch
@\Windows\System32\
notepad.exe
calc.exe
@-
\Windows\SysWOW64\mspaint.exe
```

**2. 版本条件判断 (+ver指令)**

根据Windows版本选择性添加文件：

```batch
+ver >= 17763
\Windows\System32\new_feature.dll

+ver < 17763
\Windows\System32\old_feature.dll

+ver*
\Windows\System32\common.dll
```

支持的版本操作符：

- `>` : 大于
- `<` : 小于
- `>=` : 大于等于
- `<=` : 小于等于
- `==` : 等于
- `+ver*` : 重置版本检查

**3. 自动语言资源处理**

自动添加对应的MUI和MUN文件：

- 添加`.dll` → 自动添加`.dll.mui`
- 添加`.dll` → 自动添加`.dll.mun`（19H1+）

**4. 通配符支持**

```batch
\Windows\System32\*.dll
\Windows\System32\dm*.dll
```

**5. 多文件分隔**

```batch
"\Windows\System32\notepad.exe,calc.exe,mspaint.exe"
```

#### 完整示例

```batch
call AddFiles %0 :end_files
goto :end_files

; 设置路径前缀
@\Windows\System32\
notepad.exe
calc.exe

; 版本条件判断
+ver >= 17763
new_feature.dll

; 重置版本检查
+ver*
common.dll

; 取消前缀
@-
\Windows\SysWOW64\mspaint.exe
:end_files
```

### DelFiles

删除基础镜像中的文件或目录。

#### 基本语法

```batch
call DelFiles [file_list] [label]
```

- `file_list`: 文件列表，可以是单个文件、多个文件（逗号分隔）或通配符
- `label`: 多行模式时的标签（如`:end_files`）

#### 使用模式

**单行模式** - 直接指定文件列表

```batch
call DelFiles \Windows\System32\winpe.jpg
call DelFiles \Windows\System32\*.jpg
call DelFiles "\Windows\System32\winpe.jpg,winre.jpg"
```

**多行模式** - 从当前脚本中读取文件列表

```batch
call DelFiles %0 :end_files
goto :end_files

\Windows\System32\winpe.jpg
\Windows\System32\winre.jpg
:end_files
```

#### 核心功能

**路径前缀 (@指令)**

简化重复路径的书写：

```batch
@\Windows\System32\
winpe.jpg
winre.jpg
@-
\Windows\SysWOW64\test.dll
```

**版本条件判断 (+ver指令)**

根据Windows版本选择性删除文件：

```batch
+ver >= 17763
\Windows\System32\old_feature.dll

+ver < 17763
\Windows\System32\new_feature.dll

+ver*
\Windows\System32\common.dll
```

支持的版本操作符：

- `>` : 大于
- `<` : 小于
- `>=` : 大于等于
- `<=` : 小于等于
- `==` : 等于
- `+ver*` : 重置版本检查

**自动语言资源删除**

删除文件时自动删除对应的MUI和MUN文件：

- 删除`.dll` → 自动删除`.dll.mui`
- 删除`.dll` → 自动删除`.dll.mun`（19H1+）

**通配符支持**

```batch
\Windows\System32\*.jpg
\Windows\System32\winpe*.jpg
```

**多文件分隔**

```batch
"\Windows\System32\winpe.jpg,winre.jpg,background.jpg"
```

**目录删除**

删除目录及其所有内容：

```batch
\Windows\System32\test_folder
```

#### 完整示例

```batch
call DelFiles %0 :end_files
goto :end_files

; 设置路径前缀
@\Windows\System32\
winpe.jpg
winre.jpg

; 版本条件判断
+ver >= 17763
old_feature.dll

; 重置版本检查
+ver*
test.dll

; 取消前缀
@-
\Windows\SysWOW64\test2.dll
:end_files
```

### KeepFiles

白名单删除文件，删除指定目录中除了白名单文件之外的所有文件。

#### 基本语法

```batch
call KeepFiles [pattern] [file_list] [label]
```

- `pattern`: 文件匹配模式（支持通配符）
- `file_list`: 要保留的文件列表，可以是单个文件、多个文件（逗号分隔）或标签
- `label`: 多行模式时的标签（如`:[keep_files]`）

#### 使用模式

**单行模式** - 直接指定文件列表

```batch
call KeepFiles \Windows\zh-cn\* "notepad.exe.mui,regedit.exe.mui"
call KeepFiles \Windows\System32\dm*.dll "dm1.dll,dm2.dll"
```

**多行模式** - 从当前脚本中读取文件列表

```batch
call KeepFiles \Windows\System32\*.exe %0 :end_files
goto :end_files

notepad.exe
calc.exe
cmd.exe
:end_files
```

#### 核心功能

**1. 路径前缀 (@指令)**

简化重复路径的书写：

```batch
call KeepFiles \Windows\System32\* %0 :end_files
goto :end_files

; 设置路径前缀
@\Windows\System32\
notepad.exe
calc.exe

; 取消前缀
@-
\Windows\SysWOW64\test.exe
:end_files
```

**2. 版本条件判断 (+ver指令)**

根据Windows版本选择性保留文件：

```batch
call KeepFiles \Windows\System32\* %0 :end_files
goto :end_files

+ver >= 17763
new_feature.dll

+ver < 17763
old_feature.dll

+ver*
common.dll
:end_files
```

支持的版本操作符：

- `>` : 大于
- `<` : 小于
- `>=` : 大于等于
- `<=` : 小于等于
- `==` : 等于
- `+ver*` : 重置版本检查

**3. 通配符支持**

```batch
call KeepFiles \Windows\zh-cn\* "notepad.exe.mui,regedit.exe.mui"
call KeepFiles \Windows\System32\dm*.dll "dm1.dll,dm2.dll"
```

**4. 多文件分隔**

```batch
call KeepFiles \Windows\System32\* "notepad.exe,calc.exe,cmd.exe"
```

**5. 注释支持**

使用分号开头表示注释：

```batch
call KeepFiles \Windows\System32\* %0 :end_files
goto :end_files

; 这是注释
notepad.exe
; 这是另一个注释
calc.exe
:end_files
```

#### 完整示例

```batch
call KeepFiles \Windows\System32\* %0 :end_files
goto :end_files

; 设置路径前缀
@\Windows\System32\
notepad.exe
calc.exe

; 版本条件判断
+ver >= 17763
new_feature.dll

; 重置版本检查
+ver*
common.dll

; 取消前缀
@-
\Windows\SysWOW64\test.exe
:end_files
```

#### 使用场景

KeepFiles宏适用于以下场景：

1. **语言文件清理** - 只保留需要的语言资源文件
2. **驱动文件精简** - 只保留特定硬件的驱动文件
3. **系统文件优化** - 删除不需要的系统组件
4. **自定义PE** - 根据需求定制PE环境

### RegCopy

复制源镜像的注册表项至基础镜像 HKLM\Src_XXX => HKLM\Tmp_XXX

```batch
call RegCopy HKLM\System\ControlSet001\Services\NlaSvc
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners *_microsoft.vc90.crt_*
```

### RegCopyEx

扩展复制源镜像的注册表项至基础镜像 HKLM\Src_XXX => HKLM\Tmp_XXX

```batch
call RegCopyEx Services NlaSvc
call RegCopyEx Services WPDBusEnum,WpdUpFltr,WudfPf,WUDFRd
call RegCopyEx Classes .msi
call RegCopyEx Classes Msi.Package,Msi.Path
```

### ACLRegKey

设置注册表键的访问控制列表（ACL），用于修改注册表权限。

```batch
call ACLRegKey "RegKey" [user] [owner]
```

- `RegKey`: 注册表键路径（不含HKLM前缀）
- `user`: 授予权限的用户，默认为Administrators
- `owner`: 设置所有者，默认为Administrators
- 使用`-`表示不设置该参数

```batch
call ACLRegKey "Tmp_SYSTEM\ControlSet001\Services\FDResPub" S-1-1-0 -
call ACLRegKey "Tmp_SOFTWARE\Microsoft\Windows NT\CurrentVersion"
```

### RegEx

条件执行注册表操作，根据注册表键或值的存在情况决定是否执行。

```batch
call RegEx HAS_KEY reg_command reg_key [reg_params]
call RegEx NO_KEY reg_command reg_key [reg_params]
call RegEx NO_VAL reg_command reg_key /v value_name [reg_params]
```

- `HAS_KEY`: 当注册表键存在时执行
- `NO_KEY`: 当注册表键不存在时执行
- `NO_VAL`: 当注册表值不存在时执行

```batch
call RegEx HAS_KEY delete "HKLM\Tmp_Software\Microsoft\Windows Search\VolumeInfoCache" /f
call RegEx NO_VAL add %DeviceIdsKey%\{4d36e968-e325-11ce-bfc1-08002be10318} /v displayoverride.inf /t REG_NONE
```

### AddDrivers

复制源镜像中的驱动文件及驱动相关注册表至基础镜像

```batch
call AddDrivers wceisvista.inf
call AddDrivers "netrndis.inf,rndiscmp.inf"
```

### X2X

将当前目录中的`特定目录`内的所有文件复制到基础镜像中的指定位置，以下为特定目录所对应的路径。

- `X`: `\`
- `X_WIN`: `\Windows\`
- `X_SYS`: `\Windows\System32`
- `X_PF`: `\Program Files`
- `X_PF(x86)`: `\Program Files(x86)`
- `X_Desktop`: `\Users\Default\Desktop`

```
X2X
├── 当前目录
│   ├── X: \
│   ├── X_WIN: \Windows\
│   ├── X_SYS: \Windows\System32
│   ├── X_PF: \Program Files
│   ├── X_PF(x86): \Program Files(x86)
│   └── X_Desktop: \Users\Default\Desktop
└─────────────────────────────────────────
```

```batch
call X2X
```

### V2X

版本化文件管理工具，支持根据架构自动选择文件，并提供文件操作功能。

```batch
call V2X [name] [-extract|-copy|-xcopy|version] ...
```

- `name`: 可选，指定子目录名称
- `-extract`: 提取文件到目标目录
- `-copy`: 复制文件
- `-xcopy`: 递归复制目录
- 自动根据架构选择文件（`%_Vx8664%`变量）

```batch
call V2X SogouWB
call V2X Notepad
call V2X 7-Zip -Extract "7z*-%_Vx8664%.exe" "%X_PF%\7-Zip\"
```

### Extract2X

将压缩文件解压指定目录。支持以下变量路径：

- `X`: `\`
- `X_WIN`: `\Windows\`
- `X_SYS`: `\Windows\System32`
- `X_PF`: `\Program Files`
- `X_PF(x86)`: `\Program Files(x86)`
- `X_Desktop`: `\Users\Default\Desktop`

```batch
call Extract2X Tools.7z %X%
call Extract2X StartAllback.7z %X_PF%
```

### AddEnv

增加指定路径至环境变量

```batch
call AddEnv "X:\Program Files\7-Zip"
```

### TextReplace

在文本文件中进行简单的字符串替换（不支持正则表达式）。

```batch
call TextReplace "file.txt" "old_string" "new_string"
```

- `file.txt`: 要修改的文件路径
- `old_string`: 要查找的字符串
- `new_string`: 替换后的字符串

```batch
call TextReplace "%X%\config.ini" "old_value" "new_value"
call TextReplace "%X_WIN%\system.ini" "path=C:\\" "path=X:\\"
```

### 常用脚本

- 执行当前目录下的全部脚本（除自身）

  ```batch

  for %%i in ("%~dp0\*.cmd") do (
    if /i "%%~xi"==".cmd" (
      if /i not "%%~nxi"=="%~nx0" call "%%i"
    )
  )
  ```

- 执行三级目录中的全部脚本

  ```batch
  for /d %%i in ("%~dp0\*") do (
    if exist "%%i\main.cmd" (
      echo [执行] 子模块:%%~nxi
      pushd "%%i"
      call "%%i\main.cmd"
      popd
    )
  )
  ```

## 命令行参数

WinPEBuilder 支持命令行参数进行自动化构建，也可以直接运行进入交互式模式。

### 基本语法

```batch
WinPEBuilder.cmd [-h|--help] [<Options>...]
```

### 参数说明

| 参数                            | 说明                               | 示例                                                        |
| ------------------------------- | ---------------------------------- | ----------------------------------------------------------- |
| `-h, --help`                    | 显示帮助信息                       | `WinPEBuilder.cmd -h`                                       |
| `--source-folder FOLDER\|DRIVE` | 指定源镜像所在的文件夹或驱动器盘符 | `--source-folder I:` 或 `--source-folder D:\WinISO\sources` |
| `--source-wim SOURCE_WIM_FILE`  | 指定源WIM文件的完整路径            | `--source-wim "D:\win10v1903\sources\install.wim"`          |
| `--source-index INDEX`          | 指定源镜像的索引号（默认为1）      | `--source-index 4`                                          |
| `--base-wim BASE_WIM_FILE`      | 指定基础WIM文件的完整路径（可选）  | `--base-wim "D:\BOOTPE\boot.wim"`                           |
| `--base-index INDEX`            | 指定基础镜像的索引号（默认为1）    | `--base-index 2`                                            |
| `--project PROJECT`             | 指定项目名称（必需）               | `--project Windows11PE`                                     |
| `--make-iso`                    | 构建完成后自动生成ISO镜像          | `--make-iso` 或 `set APP_OPT_MAKE_ISO=1`                    |

### 使用示例

- 基本构建

  ```batch
  WinPEBuilder.cmd --source-folder I: --project Windows11PE
  ```

- 指定源镜像索引

  ```batch
  WinPEBuilder.cmd --source-folder I: --source-index 1 --project Windows11PE
  ```

- 指定完整的WIM文件路径

```batch
WinPEBuilder.cmd --source-wim "D:\win10v1903\sources\install.wim" --source-index 4 --project Windows10PE
```

- 指定自定义基础镜像并生成ISO

  ```batch
  WinPEBuilder.cmd --source-folder H: --source-index 1 --base-wim "D:\BOOTPE\boot.wim" --project CustomPE --make-iso
  ```

- 使用目录路径（非虚拟光驱）

  ```batch
  WinPEBuilder.cmd --source-folder "D:\WindowsISO\sources" --project Windows11PE
  ```

## 许可证

BSD License
