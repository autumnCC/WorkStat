//
//  ContentView.swift
//  WorkStat
//
//  主界面 - 待办事项统计应用的主要界面
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部标题栏
            HStack {
                Text("待办事项统计")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // 设置按钮
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                .buttonStyle(.plain)
            }
            .padding()
            
            Divider()
            
            // 主要内容区域
            ScrollView {
                VStack(spacing: 24) {
                    // 统计区域（包含简化图表）
                    VStack(spacing: 16) {
                        Text("统计")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        if !viewModel.chartData.isEmpty {
                            PieChartView(
                                data: viewModel.chartData,
                                animationTrigger: viewModel.animateChart
                            )
                        } else {
                            Text("暂无数据")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(40)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.gray.opacity(0.1))
                                )
                        }
                    }
                    
                    // 待办事项区域
                    VStack(spacing: 16) {
                        HStack {
                            Text("待办事项")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            // 添加按钮
                            Button(action: {
                                viewModel.showingAddSheet = true
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus")
                                        .font(.caption)
                                    Text("添加待办事项")
                                        .font(.caption)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.green)
                                )
                                .foregroundColor(.white)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        // 待办事项列表
                        if viewModel.todoItems.isEmpty {
                            Text("暂无待办事项")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(40)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.1))
                                )
                        } else {
                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.todoItems) { item in
                                    TodoItemRow(item: item, viewModel: viewModel)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.1))
                            )
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
        }
        .sheet(isPresented: $viewModel.showingAddSheet) {
            TodoFormView(viewModel: viewModel, editingItem: nil)
        }
        .sheet(isPresented: $viewModel.showingEditSheet) {
            TodoFormView(viewModel: viewModel, editingItem: viewModel.editingItem)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

// 待办事项行组件
struct TodoItemRow: View {
    let item: TodoItem
    @ObservedObject var viewModel: TodoViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // 完成状态按钮
            Button(action: {
                viewModel.toggleCompletion(item)
            }) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(item.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            // 颜色指示器
            RoundedRectangle(cornerRadius: 3)
                .fill(item.color)
                .frame(width: 6, height: 24)
            
            // 待办事项内容
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(item.isCompleted ? .secondary : .primary)
                    .strikethrough(item.isCompleted)
                
                HStack {
                    Text("\(String(format: "%.1f", item.percentage))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if item.isCompleted {
                        Text("已完成")
                            .font(.caption)
                            .foregroundColor(.green)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.green.opacity(0.1))
                            )
                    }
                }
            }
            
            Spacer()
            
            // 操作按钮
            HStack(spacing: 8) {
                // 编辑按钮
                Button(action: {
                    viewModel.editingItem = item
                    viewModel.showingEditSheet = true
                }) {
                    Image(systemName: "pencil")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
                
                // 删除按钮
                Button(action: {
                    viewModel.deleteTodo(item)
                }) {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
        )
    }
}

#Preview {
    ContentView()
}
