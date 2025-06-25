//
//  TodoItem.swift
//  WorkStat
//
//  待办事项数据模型
//

import SwiftUI
import Foundation

// 待办事项数据模型
struct TodoItem: Identifiable, Codable {
    let id = UUID() // 唯一标识符
    var title: String // 标题
    var percentage: Double // 百分比权重
    var isCompleted: Bool = false // 是否完成
    var color: Color // 颜色
    
    // 编码键
    private enum CodingKeys: String, CodingKey {
        case title, percentage, isCompleted, colorData
    }
    
    // 初始化方法
    init(title: String, percentage: Double, color: Color = .blue) {
        self.title = title
        self.percentage = percentage
        self.color = color
    }
    
    // 自定义编码
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(percentage, forKey: .percentage)
        try container.encode(isCompleted, forKey: .isCompleted)
        
        // 将颜色转换为可编码的数据
        let colorData = ColorData(color: color)
        try container.encode(colorData, forKey: .colorData)
    }
    
    // 自定义解码
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        percentage = try container.decode(Double.self, forKey: .percentage)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        
        // 从数据恢复颜色
        let colorData = try container.decode(ColorData.self, forKey: .colorData)
        color = colorData.color
    }
    
    // 预定义颜色数组
    static let availableColors: [Color] = [
        .blue, .green, .orange, .red, .purple,
        .pink, .yellow, .cyan, .mint, .indigo
    ]
    
    // 获取下一个可用颜色
    static func nextAvailableColor(usedColors: [Color]) -> Color {
        for color in availableColors {
            if !usedColors.contains(color) {
                return color
            }
        }
        return availableColors.randomElement() ?? .blue
    }
}

// 颜色数据结构，用于编码和解码
struct ColorData: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    init(color: Color) {
        // 将SwiftUI Color转换为RGBA值
        let uiColor = NSColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        // 安全地获取颜色组件 - 处理动态颜色和颜色空间转换
        var convertedColor: NSColor
        
        // 检查是否为动态颜色或需要颜色空间转换
        if let srgbColor = uiColor.usingColorSpace(.sRGB) {
            convertedColor = srgbColor
        } else {
            // 如果无法转换到sRGB，尝试其他颜色空间
            convertedColor = uiColor.usingColorSpace(.deviceRGB) ?? uiColor
        }
        
        // 尝试获取RGBA组件
        convertedColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        // 检查值是否有效
        if r.isNaN || g.isNaN || b.isNaN || a.isNaN {
            // 如果颜色组件无效，使用默认蓝色
            self.red = 0.0
            self.green = 0.5
            self.blue = 1.0
            self.alpha = 1.0
        } else {
            self.red = Double(r)
            self.green = Double(g)
            self.blue = Double(b)
            self.alpha = Double(a)
        }
    }
    
    var color: Color {
        return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}