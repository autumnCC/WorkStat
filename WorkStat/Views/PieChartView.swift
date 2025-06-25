//
//  PieChartView.swift
//  WorkStat
//
//  圆饼图视图 - 显示待办事项的百分比统计
//

import SwiftUI

// 饼图视图
struct PieChartView: View {
    let data: [ChartDataItem] // 图表数据
    let animationTrigger: Bool // 动画触发器
    
    private let chartSize: CGFloat = 240 // 图表大小（增大以容纳更多文字）
    @State private var animationProgress: Double = 0
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
            // 背景圆圈（剩余部分）
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: chartSize, height: chartSize)
            
            // 饼图扇形
            ForEach(Array(pieSlices.enumerated()), id: \.offset) { index, slice in
                PieSlice(
                    startAngle: slice.startAngle,
                    endAngle: slice.endAngle,
                    color: slice.color
                )
                .frame(width: chartSize, height: chartSize)
                .scaleEffect(animationProgress)
                .animation(
                    .easeInOut(duration: 0.8).delay(Double(index) * 0.1),
                    value: animationProgress
                )
            }
            
            // 扇形标签
            GeometryReader { geometry in
                ForEach(Array(pieSlicesWithLabels.enumerated()), id: \.offset) { index, slice in
                    if slice.percentage >= 3 { // 只显示大于3%的标签（降低阈值）
                        VStack(spacing: 1) {
                            Text(slice.title)
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                            Text("\(String(format: "%.1f", slice.percentage))%")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }

                        .position(calculateLabelPosition(for: slice, in: geometry.size))
                        .opacity(animationProgress)
                        .animation(
                            .easeInOut(duration: 0.8).delay(Double(index) * 0.1 + 0.3),
                            value: animationProgress
                        )
                    }
                }
            }
            .frame(width: chartSize, height: chartSize)
            
            // 中心圆圈（创建环形效果）
            Circle()
                .fill(Color(NSColor.controlBackgroundColor))
                .frame(width: chartSize * 0.6, height: chartSize * 0.6)
            
            // 中心文字
            VStack(spacing: 2) {
                Text("\(String(format: "%.1f", totalUsedPercentage))%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("已使用")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .padding(8)
            .background(
                Circle()
                    .fill(Color.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
            }
            .onAppear {
                animationProgress = 1.0
            }
            .onChange(of: animationTrigger) { _ in
                animationProgress = 0
                withAnimation(.easeInOut(duration: 0.8)) {
                    animationProgress = 1.0
                }
            }
            
            // 简化图例
            if !data.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                    ForEach(data) { item in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(item.color)
                                .frame(width: 8, height: 8)
                            
                            Text(item.title)
                                .font(.caption2)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            
                            Spacer(minLength: 0)
                            
                            Text("\(String(format: "%.1f", item.percentage))%")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.gray.opacity(0.05))
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // 计算总使用百分比
    private var totalUsedPercentage: Double {
        return data.reduce(0) { $0 + $1.percentage }
    }
    
    // 计算饼图扇形数据
    private var pieSlices: [(startAngle: Angle, endAngle: Angle, color: Color)] {
        var slices: [(startAngle: Angle, endAngle: Angle, color: Color)] = []
        var currentAngle: Double = -90 // 从顶部开始
        
        for item in data {
            let sliceAngle = (item.percentage / 100.0) * 360.0
            let startAngle = Angle(degrees: currentAngle)
            let endAngle = Angle(degrees: currentAngle + sliceAngle)
            
            slices.append((
                startAngle: startAngle,
                endAngle: endAngle,
                color: item.color
            ))
            
            currentAngle += sliceAngle
        }
        
        return slices
    }
    
    // 计算带标签位置的扇形数据
    private var pieSlicesWithLabels: [(title: String, percentage: Double, labelPosition: CGPoint)] {
        var slices: [(title: String, percentage: Double, labelPosition: CGPoint)] = []
        var currentAngle: Double = -90 // 从顶部开始
        let labelRadius = chartSize * 0.35 // 标签距离中心的半径
        let centerX = chartSize / 2
        let centerY = chartSize / 2
        
        for item in data {
            let sliceAngle = (item.percentage / 100.0) * 360.0
            let midAngle = currentAngle + sliceAngle / 2 // 扇形中点角度
            
            // 计算标签位置
            let radians = midAngle * .pi / 180
            let labelX = centerX + labelRadius * cos(radians)
            let labelY = centerY + labelRadius * sin(radians)
            
            slices.append((
                title: item.title,
                percentage: item.percentage,
                labelPosition: CGPoint(x: labelX, y: labelY)
            ))
            
            currentAngle += sliceAngle
        }
        
        return slices
    }
    
    // 计算标签在实际几何尺寸中的位置
    private func calculateLabelPosition(for slice: (title: String, percentage: Double, labelPosition: CGPoint), in size: CGSize) -> CGPoint {
        var currentAngle: Double = -90 // 从顶部开始
        
        // 找到当前slice对应的角度
        for item in data {
            let sliceAngle = (item.percentage / 100.0) * 360.0
            
            if item.title == slice.title {
                let midAngle = currentAngle + sliceAngle / 2 // 扇形中点角度
                
                // 使用实际几何尺寸计算标签位置
                let actualRadius = min(size.width, size.height) / 2
                let labelRadius = actualRadius * 0.8 // 标签距离中心的半径（进一步增加距离）
                let centerX = size.width / 2
                let centerY = size.height / 2
                
                let radians = midAngle * .pi / 180
                let labelX = centerX + labelRadius * cos(radians)
                let labelY = centerY + labelRadius * sin(radians)
                
                return CGPoint(x: labelX, y: labelY)
            }
            
            currentAngle += sliceAngle
        }
        
        // 如果没找到，返回原位置
        return slice.labelPosition
    }
}

// 圆饼图扇形
struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
                let radius = min(geometry.size.width, geometry.size.height) / 2
                
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}

// 图例视图
struct ChartLegendView: View {
    let data: [ChartDataItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("图例")
                .font(.headline)
                .foregroundColor(.primary)
            
            ForEach(data) { item in
                HStack(spacing: 8) {
                    // 颜色指示器
                    RoundedRectangle(cornerRadius: 3)
                        .fill(item.color)
                        .frame(width: 12, height: 12)
                    
                    // 标题和百分比
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Text("\(String(format: "%.1f", item.percentage))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
            
            // 剩余百分比
            if totalPercentage < 100 {
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 12, height: 12)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("剩余可用")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("\(String(format: "%.1f", 100 - totalPercentage))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    // 计算总百分比
    private var totalPercentage: Double {
        return data.reduce(0) { $0 + $1.percentage }
    }
}

// 预览
#Preview {
    let sampleData = [
        ChartDataItem(title: "学习SwiftUI", percentage: 30, color: .blue),
        ChartDataItem(title: "完成项目", percentage: 25, color: .green),
        ChartDataItem(title: "代码审查", percentage: 20, color: .orange)
    ]
    
    return HStack(spacing: 32) {
        PieChartView(data: sampleData, animationTrigger: false)
        ChartLegendView(data: sampleData)
    }
    .padding()
}