//
//  TodoFormView.swift
//  WorkStat
//
//  待办事项表单视图 - 用于添加和编辑待办事项
//

import SwiftUI

// 待办事项表单视图
struct TodoFormView: View {
    @ObservedObject var viewModel: TodoViewModel
    @Environment(\.dismiss) private var dismiss
    
    let editingItem: TodoItem? // 正在编辑的项目（nil表示新增）
    
    @State private var title: String = "" // 标题
    @State private var percentage: String = "" // 百分比字符串
    @State private var showingAlert = false // 显示警告
    @State private var alertMessage = "" // 警告消息
    
    // 是否为编辑模式
    private var isEditing: Bool {
        editingItem != nil
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // 表单标题
            Text(isEditing ? "编辑待办事项" : "添加待办事项")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.top)
            
            // 表单内容
            VStack(spacing: 20) {
                // 标题输入
                VStack(alignment: .leading, spacing: 8) {
                    Text("待办事项标题")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("请输入标题", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                }
                
                // 百分比输入
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("百分比权重")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("剩余可用: \(String(format: "%.1f", availablePercentage))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        TextField("输入百分比", text: $percentage)
                            .textFieldStyle(.roundedBorder)
                            .font(.body)
                        
                        Text("%")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // 百分比提示
                    Text("提示：所有待办事项的百分比总和不能超过100%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
            
            Spacer()
            
            // 按钮区域
            HStack(spacing: 16) {
                // 取消按钮
                Button("取消") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                // 保存按钮
                Button(isEditing ? "保存" : "添加") {
                    saveTodo()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!isFormValid)
            }
            .padding(.bottom)
        }
        .padding()
        .onAppear {
            setupInitialValues()
        }
        .alert("错误", isPresented: $showingAlert) {
            Button("确定") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // 计算可用百分比
    private var availablePercentage: Double {
        if isEditing {
            return viewModel.remainingPercentage + (editingItem?.percentage ?? 0)
        } else {
            return viewModel.remainingPercentage
        }
    }
    
    // 验证表单是否有效
    private var isFormValid: Bool {
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !percentage.isEmpty &&
               (Double(percentage) ?? 0) > 0
    }
    
    // 设置初始值
    private func setupInitialValues() {
        if let item = editingItem {
            title = item.title
            percentage = String(format: "%.1f", item.percentage)
        }
    }
    
    // 保存待办事项
    private func saveTodo() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            showAlert(message: "请输入标题")
            return
        }
        
        guard let percentageValue = Double(percentage), percentageValue > 0 else {
            showAlert(message: "请输入有效的百分比")
            return
        }
        
        // 验证百分比是否超限
        if !viewModel.isValidPercentage(percentageValue, excluding: editingItem) {
            showAlert(message: "百分比总和不能超过100%")
            return
        }
        
        // 保存或更新
        if let item = editingItem {
            viewModel.updateTodo(item, title: trimmedTitle, percentage: percentageValue)
        } else {
            viewModel.addTodo(title: trimmedTitle, percentage: percentageValue)
        }
        
        dismiss()
    }
    
    // 显示警告
    private func showAlert(message: String) {
        alertMessage = message
        showingAlert = true
    }
}

// 预览
#Preview {
    TodoFormView(viewModel: TodoViewModel(), editingItem: nil)
}