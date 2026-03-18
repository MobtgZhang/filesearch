cmake_minimum_required(VERSION 3.16)
project(FileSearch LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)

# Qt 安装目录
set(CMAKE_PREFIX_PATH "/home/mobtgzhang/Qt/6.10.2/gcc_64" CACHE PATH "Qt installation path")

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Quick
    QuickControls2
    Qml
    WebEngineQuick
    QuickDialogs2
)

# 源文件
set(SOURCES
    src/main.cpp
    src/AppSettings.cpp
    src/engine/SearchEngine.cpp
    src/engine/IndexEngine.cpp
    src/engine/ScanEngine.cpp
    src/model/FileItemModel.cpp
    src/agent/AIBridge.cpp
    src/agent/ToolExecutor.cpp
    src/agent/ContextBuilder.cpp
    src/service/FileOperationService.cpp
)

add_executable(FileSearch ${SOURCES}
    src/AppSettings.h
    src/model/FileItemModel.h
    src/model/UnifiedFileRecord.h
    src/engine/SearchEngine.h
    src/engine/IndexEngine.h
    src/engine/ScanEngine.h
    src/agent/AIBridge.h
    src/agent/ToolExecutor.h
    src/agent/ContextBuilder.h
    src/service/FileOperationService.h
)

target_include_directories(FileSearch PRIVATE
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/src/engine
    ${CMAKE_SOURCE_DIR}/src/model
    ${CMAKE_SOURCE_DIR}/src/agent
    ${CMAKE_SOURCE_DIR}/src/service
)

target_link_libraries(FileSearch PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Qml
    Qt6::WebEngineQuick
    Qt6::QuickDialogs2
)
