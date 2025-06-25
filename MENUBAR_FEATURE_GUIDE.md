# WorkStat 菜单栏功能实现指南

## 概述

本文档说明如何为 WorkStat 应用添加菜单栏功能，使应用可以在 macOS 顶部菜单栏中显示紧凑版的待办统计信息。

## 当前状态

✅ **已完成的功能：**
- 饼图显示每个事项的百分比和文字标签
- 饼图按颜色占比显示扇形区域
- 剩余部分显示为灰色
- 动画效果和环形设计
- 主窗口应用正常运行

## 菜单栏功能实现

### 1. 基本实现

在 `WorkStatApp.swift` 中添加 `MenuBarExtra`：

```swift
@main
struct WorkStatApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, minHeight: 600)
                .onAppear {
                    setupDefaultLanguage()
                    setupAppearance()
                    setupWindowProperties()
                }
        }
        .windowResizability(.contentSize)
        
        // 菜单栏模式
        MenuBarExtra("WorkStat", systemImage: "chart.pie.fill") {
            MenuBarContentView()
        }
        .menuBarExtraStyle(.window)
    }
}
```

### 2. 菜单栏内容视图

创建专门的菜单栏内容视图：

```swift
struct MenuBarContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            // 标题
            Text("待办统计")
                .font(.headline)
                .fontWeight(.semibold)
            
            // 紧凑饼图
            if !viewModel.chartData.isEmpty {
                PieChartView(data: viewModel.chartData, animationTrigger: viewModel.animateChart)
                    .frame(width: 150, height: 150)
            } else {
                Text("暂无数据")
                    .foregroundColor(.secondary)
                    .frame(width: 150, height: 150)
            }
            
            // 简化的待办事项列表
            if !viewModel.incompleteTodos.isEmpty {
                VStack(spacing: 6) {
                    ForEach(Array(viewModel.incompleteTodos.prefix(4)), id: \.id) { todo in
                        HStack {
                            Circle()
                                .fill(todo.color)
                                .frame(width: 8, height: 8)
                            
                            Text(todo.title)
                                .font(.caption)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("\(Int(todo.percentage))%")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if viewModel.incompleteTodos.count > 4 {
                        Text("还有 \(viewModel.incompleteTodos.count - 4) 项...")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // 操作按钮
            HStack {
                Button("添加") {
                    viewModel.showingAddSheet = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                
                Spacer()
                
                Button("退出") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.red)
            }
        }
        .padding()
        .frame(width: 280, height: 400)
        .sheet(isPresented: $viewModel.showingAddSheet) {
            TodoFormView(viewModel: viewModel, editingItem: nil)
        }
    }
}
```

### 3. 注意事项

**系统要求：**
- `MenuBarExtra` 需要 macOS 13.0+ 支持
- 当前项目部署目标为 macOS 15.1，完全支持

**数据同步：**
- 菜单栏视图使用独立的 `TodoViewModel` 实例
- 需要考虑主窗口和菜单栏之间的数据同步
- 可以使用 `@AppStorage` 或 Core Data 实现数据持久化和同步

**用户体验：**
- 菜单栏图标显示为饼图符号
- 点击图标显示紧凑版统计信息
- 提供快速添加待办事项的功能
- 包含退出应用的选项

### 4. 可能的问题和解决方案

**编译错误：**
- 确保 `TodoViewModel` 中的属性名称正确（如 `incompleteTodos` vs `todos`）
- 检查 `PieChartView` 的参数要求
- 验证所有引用的视图组件存在

**数据访问：**
- 使用 `@StateObject` 创建独立的 ViewModel 实例
- 确保数据模型支持多实例访问

## 实现建议

1. **分步实现：** 先确保基本功能正常，再逐步添加菜单栏功能
2. **测试优先：** 每次修改后立即编译测试
3. **简化设计：** 菜单栏版本应该是主界面的简化版本
4. **用户选择：** 考虑让用户选择是否启用菜单栏模式

## 当前实现状态

- ✅ 主应用功能完整
- ✅ 饼图标签显示功能
- ⏸️ 菜单栏功能暂时移除（避免编译错误）
- 🔄 可根据需要重新添加菜单栏功能

## 下一步

如需添加菜单栏功能，建议：
1. 确认 `TodoViewModel` 的属性名称
2. 测试 `PieChartView` 的参数要求
3. 逐步添加 `MenuBarExtra` 和相关视图
4. 处理数据同步问题