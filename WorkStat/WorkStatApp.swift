//
//  WorkStatApp.swift
//  WorkStat
//
//  应用程序入口 - 待办事项统计应用
//

import SwiftUI

@main
struct WorkStatApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, minHeight: 600)
                .onAppear {
                    // 延后初始化逻辑到视图生命周期
                    setupDefaultLanguage()
                    setupAppearance()
                    setupWindowProperties()
                }
        }
        .windowResizability(.contentSize)
    }
    
    // 设置默认语言
    private func setupDefaultLanguage() {
        let preferredLanguages = Locale.preferredLanguages
        guard let firstLanguage = preferredLanguages.first else { return }
        UserDefaults.standard.set([firstLanguage], forKey: "AppleLanguages")
    }
    
    // 设置应用外观
    private func setupAppearance() {
        // 使用可选绑定安全访问
        if let aquaAppearance = NSAppearance(named: .aqua) {
            NSApp.appearance = aquaAppearance
        }
    }
    
    // 设置窗口属性
    private func setupWindowProperties() {
        // 使用可选绑定安全访问窗口
        guard let window = NSApplication.shared.windows.first else { return }
        window.setContentSize(NSSize(width: 800, height: 600))
        window.minSize = NSSize(width: 600, height: 400)
        window.center()
    }
   }
