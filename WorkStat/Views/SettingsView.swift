//
//  SettingsView.swift
//  WorkStat
//
//  设置页面视图 - 应用设置和信息页面
//

import SwiftUI

// 设置页面视图
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingAbout = false // 显示关于页面
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 页面标题
                    HStack {
                        Text("设置")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // 关闭按钮
                        Button("完成") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // 设置选项
                    VStack(spacing: 16) {
                        // 应用信息部分
                        VStack(spacing: 12) {
                            Text("应用信息")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 8) {
                                SettingsRow(
                                    icon: "info.circle.fill",
                                    title: "关于 WorkStat",
                                    subtitle: "了解更多应用信息"
                                ) {
                                    showingAbout = true
                                }
                                
                                SettingsRow(
                                    icon: "number.circle.fill",
                                    title: "版本",
                                    subtitle: getAppVersion()
                                ) {
                                    // 版本信息，无需操作
                                }
                            }
                        }
                        
                        // 反馈部分
                        VStack(spacing: 12) {
                            Text("反馈与支持")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 8) {
                                SettingsRow(
                                    icon: "envelope.fill",
                                    title: "意见反馈",
                                    subtitle: "告诉我们您的想法"
                                ) {
                                    openFeedback()
                                }
                                
                                SettingsRow(
                                    icon: "star.fill",
                                    title: "给我们评分",
                                    subtitle: "在App Store中评分"
                                ) {
                                    openAppStoreRating()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
    
    // 获取应用版本
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    // 打开反馈
    private func openFeedback() {
        let email = "feedback@workstat.app"
        let subject = "WorkStat 反馈"
        let body = "请在此处输入您的反馈..."
        
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let url = URL(string: "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)") {
            NSWorkspace.shared.open(url)
        }
    }
    
    // 打开App Store评分
    private func openAppStoreRating() {
        // 这里应该是实际的App Store链接
        let appStoreURL = "https://apps.apple.com/app/workstat/id123456789"
        if let url = URL(string: appStoreURL) {
            NSWorkspace.shared.open(url)
        }
    }
}

// 设置行组件
struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // 图标
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.green)
                    .frame(width: 24)
                
                // 文字内容
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 箭头
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isHovered ? Color.gray.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// 关于页面
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // 标题栏
            HStack {
                Text("关于 WorkStat")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("关闭") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            
            ScrollView {
                VStack(spacing: 20) {
                    // 应用图标和名称
                    VStack(spacing: 12) {
                        Image(systemName: "chart.pie.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                        
                        Text("WorkStat")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("待办事项统计")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    
                    // 应用描述
                    VStack(alignment: .leading, spacing: 16) {
                        Text("应用简介")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("WorkStat 是一款简洁优雅的待办事项统计工具，帮助您更好地管理时间和任务。通过直观的圆饼图展示，让您清楚地了解各项任务的时间分配。")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                    
                    // 功能特点
                    VStack(alignment: .leading, spacing: 16) {
                        Text("功能特点")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            FeaturePoint(text: "直观的圆饼图统计展示")
                            FeaturePoint(text: "灵活的百分比权重管理")
                            FeaturePoint(text: "优雅的动画效果")
                            FeaturePoint(text: "简洁的用户界面设计")
                            FeaturePoint(text: "数据本地存储，保护隐私")
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                    
                    // 版权信息
                    VStack(spacing: 8) {
                        Text("© 2025 WorkStat")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("版本 \(getAppVersion())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
    }
    
    // 获取应用版本
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        return version
    }
}

// 功能特点组件
struct FeaturePoint: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.caption)
                .foregroundColor(.green)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

// 预览
#Preview {
    SettingsView()
}