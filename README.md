# NexFile — AI 文件管理器

类似 Everything + FileLight 的文件管理器，具备 AI Agent 文件管理搜索能力。基于 Qt Quick 构建。

## 项目结构

```
FileSearch/
├── src/
│   ├── main.cpp
│   ├── AppSettings.h/cpp          # 应用设置（主题等）
│   ├── agent/                     # AI Agent
│   │   ├── AIBridge
│   │   ├── ToolExecutor
│   │   ├── ContextBuilder
│   │   └── tools/                 # Agent 原子操作工具
│   │       ├── IAgentTool         # 工具基类接口
│   │       ├── SearchFilesTool    # 搜索文件
│   │       ├── DeleteFilesTool    # 删除文件
│   │       └── MoveFilesTool     # 移动文件
│   ├── engine/                    # 搜索引擎
│   │   ├── SearchEngine
│   │   ├── IndexEngine
│   │   └── ScanEngine
│   ├── model/                     # 数据模型
│   │   ├── FileItemModel
│   │   └── UnifiedFileRecord
│   └── service/                   # 文件操作服务
│       └── FileOperationService
├── qml/
│   ├── main.qml              # 主窗口
│   ├── ai-chat/
│   │   └── index.html        # AI 聊天面板 Web UI（由 WebEngineView 加载）
│   ├── theme/
│   │   ├── Theme.qml          # 主题色彩/字体
│   │   └── qmldir
│   └── components/
│       ├── TitleBar.qml       # 标题栏
│       ├── SearchBar.qml     # 搜索栏 + 筛选
│       ├── Sidebar.qml        # 左侧导航
│       ├── VizPanel.qml       # 磁盘可视化（环形图+树图）
│       ├── FileListPanel.qml  # 文件列表
│       ├── AIChatPanel.qml    # AI 对话面板
│       ├── ActionBar.qml      # 选中操作条
│       ├── StatusBar.qml      # 状态栏
│       └── ...
├── refs/
│   ├── framework.md          # 架构设计
│   └── ai-file-manager-ui.html # UI 参考
└── CMakeLists.txt
```

## 构建与运行

### 使用 Makefile（推荐）

```bash
make compile   # 编译
make run      # 编译并运行
make run-only # 仅运行（不重新编译）
make clean    # 清理
make rebuild  # 重新编译
make help     # 查看帮助
```

### 使用 CMake

```bash
mkdir build && cd build
cmake -DCMAKE_PREFIX_PATH=/home/mobtgzhang/Qt/6.10.2/gcc_64 ..
make
./FileSearch
```

**注意**：需从项目根目录运行，以便找到 `qml/` 目录。

## 界面说明

- **标题栏**：NexFile 品牌、索引状态、AI 就绪标识
- **搜索栏**：类 Everything 的即时搜索、筛选标签、AI 助手入口
- **左侧导航**：搜索、磁盘可视化、重复文件、清理建议、收藏、历史、设置
- **可视化面板**：环形图 + 树图展示磁盘占用，支持切换视图
- **文件列表**：名称/路径/类型/大小/日期，支持多选与批量操作
- **AI 面板**：自然语言指令、Function Calling 工具执行状态、对话历史
- **状态栏**：索引数量、搜索耗时、磁盘使用、监听状态

## 后续开发（参考 framework.md）

1. **Phase 1**：文件索引、基础搜索、磁盘扫描、搜索↔图表联动
2. **Phase 2**：AI 接入、自然语言搜索、Function Calling
3. **Phase 3**：语义搜索、重复检测、跨设备索引

## 依赖

- Qt 6.x（Core, Gui, Quick, QuickControls2, Qml, **WebEngineQuick**）
- Qt 安装路径：`/home/mobtgzhang/Qt/6.10.2/gcc_64`（可在 CMakeLists.txt 中修改 CMAKE_PREFIX_PATH）
- 右侧 AI 聊天面板使用 Qt WebEngine 渲染 `qml/ai-chat/index.html`，聊天 UI 由 Web 技术实现

## 主题

- **Dark 模式**：深色背景，参考 ai-file-manager-ui.html
- **Light 模式**：浅色背景
- 在左侧导航栏点击 ⚙ 设置，可切换主题
