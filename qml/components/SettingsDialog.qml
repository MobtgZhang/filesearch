import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

Popup {
    id: settingsPopup
    width: Math.min(640, parent ? parent.width - 80 : 640)
    height: Math.min(720, parent ? parent.height - 80 : 720)
    modal: true
    focus: true
    anchors.centerIn: parent
    padding: 0
    closePolicy: Popup.CloseOnEscape

    property int currentTab: 0
    readonly property var tabs: ["系统设置", "Agent 设置"]

    background: Rectangle {
        color: Theme.surface
        border.color: Theme.border
        border.width: 1
        radius: 12
    }

    contentItem: ColumnLayout {
        spacing: 0

        // 标题栏
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 52
            color: Theme.panel
            radius: 12

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Text {
                    font.pixelSize: 17
                    font.weight: Font.Medium
                    font.family: Theme.fontDisplay
                    color: Theme.bright
                    text: "设置"
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 32
                    height: 32
                    radius: 8
                    color: closeBtn.containsMouse ? Theme.highlight : "transparent"

                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: 18
                        font.weight: Font.Light
                        color: Theme.muted
                        text: "×"
                    }

                    MouseArea {
                        id: closeBtn
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: settingsPopup.close()
                    }
                }
            }
        }

        // Tab 行
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            color: Theme.panel

            Row {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: 4

                Repeater {
                    model: settingsPopup.tabs
                    delegate: Rectangle {
                        width: tabLabel.implicitWidth + 24
                        height: 44
                        color: "transparent"

                        Text {
                            id: tabLabel
                            anchors.centerIn: parent
                            text: modelData
                            color: index === settingsPopup.currentTab ? Theme.text : Theme.muted
                            font.pixelSize: 13
                            font.weight: index === settingsPopup.currentTab ? Font.Medium : Font.Normal
                            font.family: Theme.fontDisplay
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 2
                            color: index === settingsPopup.currentTab ? Theme.settingsAccent : "transparent"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: settingsPopup.currentTab = index
                        }
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: Theme.border
            }
        }

        // 可滚动设置内容
        Flickable {
            id: contentFlick
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: width
            contentHeight: contentCol.implicitHeight + 40
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            ColumnLayout {
                id: contentCol
                width: contentFlick.width - 40
                x: 20
                y: 20
                spacing: 18

                // ── Tab 0: 系统设置 ───────────────────────────────────────────────
                ColumnLayout {
                    id: systemCol
                    Layout.fillWidth: true
                    spacing: 18
                    visible: settingsPopup.currentTab === 0

                        SectionBox {
                            label: "语言"
                            hint: "选择界面显示语言"
                            ComboBox {
                                id: langCombo
                                Layout.fillWidth: true
                                Layout.preferredHeight: 36
                                model: ["zh", "en"]
                                currentIndex: model.indexOf(appSettings ? appSettings.language : "zh")
                                onActivated: if (appSettings) appSettings.language = model[currentIndex]
                                contentItem: Text {
                                    leftPadding: 12
                                    text: langCombo.displayText
                                    color: Theme.text
                                    font.pixelSize: 13
                                    font.family: Theme.fontDisplay
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                }
                                background: Rectangle {
                                    radius: 6
                                    color: Theme.input
                                    border.color: Theme.border
                                }
                                popup.background: Rectangle {
                                    color: Theme.popupBg
                                    radius: 6
                                    border.color: Theme.border
                                }
                                delegate: ItemDelegate {
                                    width: langCombo.popup ? langCombo.popup.width - 8 : 172
                                    hoverEnabled: true
                                    contentItem: Text {
                                        text: modelData
                                        color: Theme.text
                                        font.pixelSize: 13
                                        font.family: Theme.fontDisplay
                                        elide: Text.ElideRight
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    background: Rectangle {
                                        color: (parent.highlighted || parent.hovered) ? Theme.highlight : "transparent"
                                        radius: 4
                                    }
                                }
                            }
                        }

                        SectionBox {
                            label: "主题"
                            hint: "深色或浅色界面"
                            Row {
                                spacing: 16
                                RadioButton {
                                    id: themeDark
                                    text: "深色"
                                    checked: appSettings && appSettings.themeMode !== "light"
                                    onCheckedChanged: if (checked && appSettings) appSettings.themeMode = "dark"
                                    contentItem: Text {
                                        text: themeDark.text
                                        color: Theme.text
                                        font.pixelSize: 13
                                        font.family: Theme.fontDisplay
                                        leftPadding: themeDark.indicator.width + themeDark.spacing
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    indicator: Rectangle {
                                        implicitWidth: 18
                                        implicitHeight: 18
                                        radius: 9
                                        border.color: themeDark.checked ? Theme.settingsAccent : Theme.border
                                        border.width: 2
                                        color: themeDark.checked ? Theme.settingsAccent : "transparent"
                                        Rectangle {
                                            width: 8
                                            height: 8
                                            radius: 4
                                            anchors.centerIn: parent
                                            color: themeDark.checked ? "white" : "transparent"
                                        }
                                    }
                                }
                                RadioButton {
                                    id: themeLight
                                    text: "浅色"
                                    checked: appSettings && appSettings.themeMode === "light"
                                    onCheckedChanged: if (checked && appSettings) appSettings.themeMode = "light"
                                    contentItem: Text {
                                        text: themeLight.text
                                        color: Theme.text
                                        font.pixelSize: 13
                                        font.family: Theme.fontDisplay
                                        leftPadding: themeLight.indicator.width + themeLight.spacing
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    indicator: Rectangle {
                                        implicitWidth: 18
                                        implicitHeight: 18
                                        radius: 9
                                        border.color: themeLight.checked ? Theme.settingsAccent : Theme.border
                                        border.width: 2
                                        color: themeLight.checked ? Theme.settingsAccent : "transparent"
                                        Rectangle {
                                            width: 8
                                            height: 8
                                            radius: 4
                                            anchors.centerIn: parent
                                            color: themeLight.checked ? "white" : "transparent"
                                        }
                                    }
                                }
                            }
                        }

                        SectionBox {
                            label: "缓存目录"
                            hint: "历史记录与会话配置存储位置"
                            FieldInput {
                                id: cacheDirField
                                Layout.fillWidth: true
                                text: appSettings ? appSettings.cacheDir : ""
                                placeholderText: "~/.cache/FileSearch/"
                                onEditingFinished: if (appSettings) appSettings.cacheDir = text
                            }
                        }
                }

                // ── Tab 1: Agent 设置 ───────────────────────────────────────────────
                ColumnLayout {
                    id: agentCol
                    Layout.fillWidth: true
                    spacing: 18
                    visible: settingsPopup.currentTab === 1

                        SectionBox {
                            label: "API 地址"
                            hint: "OpenAI 兼容 API 端点"
                            FieldInput {
                                id: apiUrlField
                                Layout.fillWidth: true
                                text: appSettings ? appSettings.apiBaseUrl : ""
                                placeholderText: "https://api.openai.com/v1"
                                onEditingFinished: if (appSettings) appSettings.apiBaseUrl = text
                            }
                        }

                        SectionBox {
                            label: "API 模型"
                            hint: "选择对话使用的模型"
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 8
                                ComboBox {
                                    id: modelCombo
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 36
                                    model: appSettings ? appSettings.apiModelList : []
                                    currentIndex: model.indexOf(appSettings ? appSettings.apiModel : "")
                                    onActivated: if (appSettings) appSettings.apiModel = model[currentIndex]
                                    contentItem: Text {
                                        leftPadding: 12
                                        text: modelCombo.displayText
                                        color: Theme.text
                                        font.pixelSize: 13
                                        font.family: Theme.fontDisplay
                                        verticalAlignment: Text.AlignVCenter
                                        elide: Text.ElideRight
                                    }
                                    background: Rectangle {
                                        radius: 6
                                        color: Theme.input
                                        border.color: Theme.border
                                    }
                                    popup.background: Rectangle {
                                        color: Theme.popupBg
                                        radius: 6
                                        border.color: Theme.border
                                    }
                                    delegate: ItemDelegate {
                                        width: modelCombo.popup ? modelCombo.popup.width - 8 : 212
                                        hoverEnabled: true
                                        contentItem: Text {
                                            text: modelData
                                            color: Theme.text
                                            font.pixelSize: 13
                                            font.family: Theme.fontDisplay
                                            elide: Text.ElideRight
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        background: Rectangle {
                                            color: (parent.highlighted || parent.hovered) ? Theme.highlight : "transparent"
                                            radius: 4
                                        }
                                    }
                                }
                                Button {
                                    Layout.alignment: Qt.AlignLeft
                                    text: "刷新模型列表"
                                    height: 30
                                    contentItem: Text {
                                        text: parent.text
                                        color: Theme.muted
                                        font.pixelSize: 12
                                        font.family: Theme.fontDisplay
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    background: Rectangle {
                                        radius: 6
                                        color: Theme.input
                                        border.color: Theme.border
                                    }
                                    onClicked: if (appSettings) appSettings.refreshApiModelList()
                                }
                            }
                        }

                        SliderSection {
                            label: "温度"
                            hint: "控制回复随机性，越高越随机 (0-1)"
                            value: appSettings ? appSettings.modelTemperature : 0.7
                            from: 0
                            to: 1
                            stepSize: 0.05
                            scrollView: contentFlick
                            onMoved: (value) => { if (appSettings) appSettings.modelTemperature = value }
                        }

                        SliderSection {
                            label: "Top-K"
                            hint: "采样时考虑的 token 数量"
                            value: appSettings ? appSettings.topK : 40
                            from: 1
                            to: 100
                            stepSize: 1
                            isInt: true
                            scrollView: contentFlick
                            onMoved: (value) => { if (appSettings) appSettings.topK = Math.round(value) }
                        }

                        SliderSection {
                            label: "Top-P"
                            hint: "核采样概率阈值"
                            value: appSettings ? appSettings.topP : 0.9
                            from: 0
                            to: 1
                            stepSize: 0.01
                            scrollView: contentFlick
                            onMoved: (value) => { if (appSettings) appSettings.topP = value }
                        }

                        SliderSection {
                            label: "max_tokens"
                            hint: "单次回复最大 token 数"
                            value: appSettings ? appSettings.maxTokens : 4096
                            from: 64
                            to: 128000
                            stepSize: 256
                            isInt: true
                            scrollView: contentFlick
                            onMoved: (value) => { if (appSettings) appSettings.maxTokens = Math.round(value) }
                        }

                        SectionBox {
                            label: "系统提示词"
                            hint: "定义 AI 的角色与行为"
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 100
                                color: Theme.input
                                radius: 6
                                border.color: Theme.border

                                ScrollView {
                                    id: systemPromptScroll
                                    anchors.fill: parent
                                    anchors.margins: 4
                                    contentWidth: availableWidth
                                    ScrollBar.vertical.policy: ScrollBar.AsNeeded

                                    TextArea {
                                        id: systemPromptArea
                                        width: systemPromptScroll.width - 8
                                        text: appSettings ? appSettings.systemPrompt : ""
                                        onTextChanged: if (appSettings && activeFocus) appSettings.systemPrompt = text
                                        color: Theme.text
                                        font.pixelSize: 13
                                        font.family: Theme.fontDisplay
                                        wrapMode: TextArea.Wrap
                                        background: null
                                        selectByMouse: true
                                    }
                                }
                            }
                        }

                        SectionBox {
                            label: "搜索引擎"
                            hint: "联网搜索使用的引擎"
                            ComboBox {
                                id: searchEngineCombo
                                Layout.fillWidth: true
                                Layout.preferredHeight: 36
                                model: ["bing", "baidu", "duckduckgo"]
                                currentIndex: model.indexOf(appSettings ? appSettings.webSearchEngine : "bing")
                                onActivated: if (appSettings) appSettings.webSearchEngine = model[currentIndex]
                                contentItem: Text {
                                    leftPadding: 12
                                    text: searchEngineCombo.displayText
                                    color: Theme.text
                                    font.pixelSize: 13
                                    font.family: Theme.fontDisplay
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                }
                                background: Rectangle {
                                    radius: 6
                                    color: Theme.input
                                    border.color: Theme.border
                                }
                                popup.background: Rectangle {
                                    color: Theme.popupBg
                                    radius: 6
                                    border.color: Theme.border
                                }
                                delegate: ItemDelegate {
                                    width: searchEngineCombo.popup ? searchEngineCombo.popup.width - 8 : 172
                                    hoverEnabled: true
                                    contentItem: Text {
                                        text: modelData
                                        color: Theme.text
                                        font.pixelSize: 13
                                        font.family: Theme.fontDisplay
                                        elide: Text.ElideRight
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    background: Rectangle {
                                        color: (parent.highlighted || parent.hovered) ? Theme.highlight : "transparent"
                                        radius: 4
                                    }
                                }
                            }
                        }

                        SectionBox {
                            label: "代理"
                            hint: "自动代理使用系统设置，手动代理需输入地址"
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 12

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 16

                                    Text {
                                        text: "自动代理"
                                        color: Theme.text
                                        font.pixelSize: 13
                                        font.family: Theme.fontDisplay
                                    }

                                    Rectangle {
                                        id: proxyModeSwitch
                                        width: 44
                                        height: 24
                                        radius: 12
                                        color: proxyModeIsManual ? Theme.settingsAccent : Theme.border
                                        property bool proxyModeIsManual: appSettings && appSettings.proxyMode === "manual"

                                        Rectangle {
                                            id: proxyModeKnob
                                            width: 20
                                            height: 20
                                            radius: 10
                                            anchors.verticalCenter: parent.verticalCenter
                                            x: proxyModeSwitch.proxyModeIsManual ? parent.width - width - 2 : 2
                                            color: "white"
                                            border.color: Theme.border

                                            Behavior on x { NumberAnimation { duration: 150 } }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (appSettings) {
                                                    appSettings.proxyMode = appSettings.proxyMode === "manual" ? "auto" : "manual"
                                                }
                                            }
                                        }
                                    }

                                    Text {
                                        text: "手动代理"
                                        color: Theme.text
                                        font.pixelSize: 13
                                        font.family: Theme.fontDisplay
                                    }
                                }

                                Text {
                                    visible: appSettings && appSettings.proxyMode === "auto"
                                    text: "使用系统代理"
                                    color: Theme.muted
                                    font.pixelSize: 11
                                    font.family: Theme.fontDisplay
                                }

                                FieldInput {
                                    id: proxyField
                                    Layout.fillWidth: true
                                    visible: appSettings && appSettings.proxyMode === "manual"
                                    text: appSettings ? appSettings.proxyUrl : ""
                                    placeholderText: "http://127.0.0.1:7890 或 127.0.0.1:7890"
                                    onEditingFinished: if (appSettings) appSettings.proxyUrl = text
                                }
                            }
                        }
                }

                Item { height: 20 }
            }
        }

        // 底部栏
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            color: Theme.panel

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.border
            }

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 20
                spacing: 10

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 11
                    color: Theme.muted
                    text: "设置将自动保存"
                }

                Button {
                    text: "关闭"
                    height: 34
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 13
                        font.family: Theme.fontDisplay
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        radius: 6
                        color: Theme.settingsAccent
                    }
                    onClicked: settingsPopup.close()
                }
            }
        }
    }

    // ── 组件定义 ────────────────────────────────────────────────────────────────
    component SectionBox: ColumnLayout {
        property string label: ""
        property string hint: ""
        Layout.fillWidth: true
        spacing: 6
        Text {
            text: parent.label
            color: Theme.text
            font.pixelSize: 13
            font.weight: Font.Medium
            font.family: Theme.fontDisplay
        }
        Text {
            text: parent.hint
            color: Theme.muted
            font.pixelSize: 11
            font.family: Theme.fontDisplay
            visible: parent.hint !== ""
            wrapMode: Text.WordWrap
        }
    }

    component FieldInput: TextField {
        Layout.fillWidth: true
        Layout.preferredHeight: 36
        color: Theme.text
        font.pixelSize: 13
        font.family: Theme.fontDisplay
        placeholderTextColor: Theme.muted
        selectByMouse: true
        leftPadding: 12
        background: Rectangle {
            radius: 6
            color: Theme.input
            border.color: Theme.border
        }
    }

    component SliderSection: ColumnLayout {
        property string label: ""
        property string hint: ""
        property real value: 0
        property real from: 0
        property real to: 1
        property real stepSize: 0.01
        property bool isInt: false
        property Item scrollView: null
        signal moved(real value)

        property real displayValue: value

        Layout.fillWidth: true
        spacing: 4

        onValueChanged: {
            if (!sliderControl.pressed && !valueEdit.activeFocus) {
                sliderControl.value = value
                displayValue = value
                valueEdit.text = formatVal(value)
            }
        }

        function formatVal(v) { return isInt ? Math.round(v).toString() : v.toFixed(2) }
        function clampVal(v) { return Math.max(from, Math.min(to, v)) }

        Component.onCompleted: {
            sliderControl.value = value
            displayValue = value
            valueEdit.text = formatVal(value)
        }

        Text {
            text: parent.label
            color: Theme.text
            font.pixelSize: 13
            font.weight: Font.Medium
            font.family: Theme.fontDisplay
        }
        Text {
            text: parent.hint
            color: Theme.muted
            font.pixelSize: 11
            font.family: Theme.fontDisplay
            visible: parent.hint !== ""
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Slider {
                id: sliderControl
                Layout.fillWidth: true
                Layout.minimumHeight: 28
                from: parent.parent.from
                to: parent.parent.to
                stepSize: parent.parent.stepSize
                value: 0

                onPressedChanged: {
                    if (pressed) sliderControl.forceActiveFocus()
                    if (scrollView && scrollView.contentItem) {
                        scrollView.contentItem.interactive = !pressed
                    } else if (scrollView) {
                        scrollView.interactive = !pressed
                    }
                }
                onMoved: {
                    parent.parent.displayValue = value
                    parent.parent.moved(value)
                    valueEdit.text = parent.parent.formatVal(value)
                }
                onValueChanged: {
                    if (pressed) {
                        parent.parent.displayValue = value
                        parent.parent.moved(value)
                        valueEdit.text = parent.parent.formatVal(value)
                    }
                }

                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 4
                    x: sliderControl.leftPadding + (sliderControl.availableWidth - width) / 2
                    y: sliderControl.topPadding + (sliderControl.availableHeight - height) / 2
                    width: sliderControl.availableWidth - sliderControl.leftPadding - sliderControl.rightPadding
                    height: 4
                    radius: 2
                    color: Theme.border
                    Rectangle {
                        width: sliderControl.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color: Theme.settingsAccent
                    }
                }
                handle: Rectangle {
                    x: sliderControl.leftPadding + sliderControl.visualPosition * (sliderControl.availableWidth - width)
                    y: sliderControl.topPadding + (sliderControl.availableHeight - height) / 2
                    implicitWidth: 16
                    implicitHeight: 16
                    width: 16
                    height: 16
                    radius: 8
                    color: sliderControl.pressed ? Qt.darker(Theme.settingsAccent, 1.1) : Theme.settingsAccent
                    border.color: Theme.border
                }
            }
            TextField {
                id: valueEdit
                Layout.preferredWidth: 72
                Layout.alignment: Qt.AlignVCenter
                horizontalAlignment: TextInput.AlignRight
                color: Theme.text
                font.pixelSize: 13
                font.family: Theme.fontDisplay
                selectByMouse: true
                leftPadding: 8
                rightPadding: 8
                background: Rectangle {
                    radius: 6
                    color: Theme.input
                    border.color: Theme.border
                }

                onEditingFinished: {
                    var ss = parent.parent
                    var v = parseFloat(text)
                    if (!isNaN(v)) {
                        if (ss.isInt) v = Math.round(v)
                        v = ss.clampVal(v)
                        ss.displayValue = v
                        ss.moved(v)
                        sliderControl.value = v
                        text = ss.formatVal(v)
                    } else {
                        text = ss.formatVal(ss.displayValue)
                    }
                }
                onTextChanged: {
                    if (!activeFocus) return
                    var v = parseFloat(text)
                    if (!isNaN(v)) parent.parent.displayValue = parent.parent.clampVal(v)
                }
            }
        }
    }

    onOpened: {
        settingsPopup.forceActiveFocus()
        if (appSettings) {
            cacheDirField.text = appSettings.cacheDir
            apiUrlField.text = appSettings.apiBaseUrl
            modelCombo.model = appSettings.apiModelList
            modelCombo.currentIndex = modelCombo.model.indexOf(appSettings.apiModel)
            systemPromptArea.text = appSettings.systemPrompt
            searchEngineCombo.currentIndex = searchEngineCombo.model.indexOf(appSettings.webSearchEngine)
            proxyField.text = appSettings.proxyUrl
        }
    }
}
