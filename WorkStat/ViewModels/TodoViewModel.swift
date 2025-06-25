//
//  TodoViewModel.swift
//  WorkStat
//
//  待办事项视图模型 - 管理待办事项的数据和业务逻辑
//

import SwiftUI
import Foundation

// 图表数据项
struct ChartDataItem: Identifiable {
    let id = UUID()
    let title: String
    let percentage: Double
    let color: Color
}

// 待办事项视图模型
class TodoViewModel: ObservableObject {
    @Published var todoItems: [TodoItem] = [] // 待办事项列表
    @Published var showingAddSheet = false // 是否显示添加表单
    @Published var showingEditSheet = false // 是否显示编辑表单
    @Published var editingItem: TodoItem? = nil // 正在编辑的项目
    @Published var animateChart = false // 图表动画触发器
    
    private let userDefaults = UserDefaults.standard
    private let todosKey = "SavedTodos" // 存储键
    
    init() {
        loadTodos() // 加载保存的待办事项
    }
    
    // MARK: - 数据操作
    
    // 添加待办事项
    func addTodo(title: String, percentage: Double) {
        let usedColors = todoItems.map { $0.color }
        let newColor = TodoItem.nextAvailableColor(usedColors: usedColors)
        
        let newTodo = TodoItem(
            title: title,
            percentage: percentage,
            color: newColor
        )
        
        todoItems.append(newTodo)
        saveTodos()
        triggerChartAnimation()
    }
    
    // 更新待办事项
    func updateTodo(_ item: TodoItem, title: String, percentage: Double) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems[index].title = title
            todoItems[index].percentage = percentage
            saveTodos()
            triggerChartAnimation()
        }
    }
    
    // 删除待办事项
    func deleteTodo(_ item: TodoItem) {
        todoItems.removeAll { $0.id == item.id }
        saveTodos()
        triggerChartAnimation()
    }
    
    // 切换完成状态
    func toggleCompletion(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems[index].isCompleted.toggle()
            saveTodos()
            triggerChartAnimation()
        }
    }
    
    // 开始编辑
    func startEditing(_ item: TodoItem) {
        editingItem = item
        showingEditSheet = true
    }
    
    // MARK: - 数据计算
    
    // 未完成的待办事项
    var incompleteTodos: [TodoItem] {
        return todoItems.filter { !$0.isCompleted }
    }
    
    // 已使用的百分比总和
    var usedPercentage: Double {
        return incompleteTodos.reduce(0) { $0 + $1.percentage }
    }
    
    // 剩余可用百分比
    var remainingPercentage: Double {
        return max(0, 100 - usedPercentage)
    }
    
    // 验证百分比是否有效
    func isValidPercentage(_ percentage: Double, excluding item: TodoItem? = nil) -> Bool {
        let currentUsed = incompleteTodos
            .filter { $0.id != item?.id }
            .reduce(0) { $0 + $1.percentage }
        return currentUsed + percentage <= 100
    }
    
    // 图表数据
    var chartData: [ChartDataItem] {
        let incompleteItems = incompleteTodos
        guard !incompleteItems.isEmpty else { return [] }
        
        return incompleteItems.map { item in
            ChartDataItem(
                title: item.title,
                percentage: item.percentage,
                color: item.color
            )
        }
    }
    
    // MARK: - 数据持久化
    
    // 保存待办事项到UserDefaults
    private func saveTodos() {
        do {
            let data = try JSONEncoder().encode(todoItems)
            userDefaults.set(data, forKey: todosKey)
        } catch {
            print("保存待办事项失败: \(error)")
        }
    }
    
    // 从UserDefaults加载待办事项
    private func loadTodos() {
        guard let data = userDefaults.data(forKey: todosKey) else {
            // 如果没有保存的数据，创建示例数据
            createSampleData()
            return
        }
        
        do {
            todoItems = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            print("加载待办事项失败: \(error)")
            createSampleData()
        }
    }
    
    // 创建示例数据
    private func createSampleData() {
        todoItems = [
            TodoItem(title: "学习SwiftUI", percentage: 30, color: .blue),
            TodoItem(title: "完成项目文档", percentage: 25, color: .green),
            TodoItem(title: "代码审查", percentage: 20, color: .orange)
        ]
        saveTodos()
    }
    
    // 触发图表动画
    private func triggerChartAnimation() {
        withAnimation(.easeInOut(duration: 0.8)) {
            animateChart.toggle()
        }
    }
}