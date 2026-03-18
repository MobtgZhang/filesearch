import QtQuick 2.15
import QtQuick.Layouts 1.15
import "../theme" 1.0

GridLayout {
    id: treemap
    Layout.fillWidth: true
    Layout.margins: 14
    columns: 2
    rowSpacing: 3
    columnSpacing: 3

    TreeMapCell {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.rowSpan: 1
        label: "📹 Movies"
        size: "22.4 GB"
        gradientColors: ["#1a3a2a", "#0d2018"]
    }
    TreeMapCell {
        Layout.fillWidth: true
        Layout.fillHeight: true
        label: "📚 Documents"
        size: "8.8 GB"
        gradientColors: ["#1a1535", "#100d28"]
    }
    TreeMapCell {
        Layout.fillWidth: true
        Layout.fillHeight: true
        label: "💾 Backups"
        size: "12.5 GB"
        gradientColors: ["#3a1a18", "#280d0b"]
    }
    TreeMapCell {
        Layout.fillWidth: true
        Layout.fillHeight: true
        label: "🖼 Photos"
        size: "4.3 GB"
        gradientColors: ["#3a2e10", "#281f08"]
    }
    TreeMapCell {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 2
        label: "🗂 其他文件"
        size: "2.9 GB"
        gradientColors: ["#1e1e1e", "#141414"]
    }
}
