# NexFile — AI 文件管理器 Makefile
# 用法: make compile 编译 | make run 运行

# 配置
BUILD_DIR   := build
EXECUTABLE  := $(BUILD_DIR)/FileSearch
QT_PATH     := /home/mobtgzhang/Qt/6.10.2/gcc_64
CMAKE_PREFIX := -DCMAKE_PREFIX_PATH=$(QT_PATH)

# 默认目标
.PHONY: all
all: compile

# 编译
.PHONY: compile
compile:
	@mkdir -p $(BUILD_DIR)
	@cd $(BUILD_DIR) && cmake $(CMAKE_PREFIX) .. && make
	@echo "编译完成: $(EXECUTABLE)"

# 运行（需先编译，从项目根目录运行以加载 qml/）
.PHONY: run
run: compile
	@./$(EXECUTABLE)

# 清理构建产物
.PHONY: clean
clean:
	@rm -rf $(BUILD_DIR)
	@echo "已清理 $(BUILD_DIR)"

# 重新编译（clean + compile）
.PHONY: rebuild
rebuild: clean compile

# 仅运行（不重新编译，若未编译则先编译）
.PHONY: run-only
run-only:
	@if [ ! -f $(EXECUTABLE) ]; then $(MAKE) compile; fi
	@./$(EXECUTABLE)

# 帮助
.PHONY: help
help:
	@echo "NexFile Makefile 用法:"
	@echo "  make compile  - 编译项目"
	@echo "  make run      - 编译并运行"
	@echo "  make run-only - 仅运行（不重新编译）"
	@echo "  make clean    - 清理构建目录"
	@echo "  make rebuild  - 清理后重新编译"
	@echo "  make help     - 显示此帮助"
