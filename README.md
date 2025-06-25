# WorkStat - 待办事项统计应用

一款简洁优雅的Mac待办事项统计工具，帮助您更好地管理时间和任务。

## 功能特点

### 🎯 核心功能
- **待办事项管理**: 支持添加、编辑、删除和完成状态切换
- **百分比权重**: 为每个待办事项设置百分比权重，总和不超过100%
- **圆饼图统计**: 直观的圆饼图显示各项任务的时间分配
- **优雅动画**: 流畅的过渡动画效果
- **数据持久化**: 本地存储，数据不丢失

### 🎨 设计特色
- **极简设计**: 符合2025年Mac软件设计趋势
- **绿色主题**: 清新的绿色主色调
- **响应式布局**: 适配不同窗口尺寸
- **系统适配**: 跟随系统外观（浅色/深色模式）

### 🌍 国际化支持
- **多语言**: 支持中文和英文
- **默认中文**: 应用默认显示中文界面
- **App Store**: 支持发布到不同国家的App Store
  - 中文市场: "待办事项统计"
  - 国际市场: "WorkStat"

## 技术架构

### 📁 项目结构
```
WorkStat/
├── Models/
│   └── TodoItem.swift          # 待办事项数据模型
├── ViewModels/
│   └── TodoViewModel.swift     # 业务逻辑管理
├── Views/
│   ├── ContentView.swift       # 主界面
│   ├── PieChartView.swift      # 圆饼图组件
│   ├── TodoFormView.swift      # 添加/编辑表单
│   └── SettingsView.swift      # 设置页面
├── Localization/
│   ├── zh-Hans.lproj/          # 中文本地化
│   └── en.lproj/               # 英文本地化
├── Assets.xcassets/            # 资源文件
├── Info.plist                  # 应用配置
└── WorkStatApp.swift           # 应用入口
```

### 🛠 技术栈
- **框架**: SwiftUI + Combine
- **平台**: macOS 13.0+
- **语言**: Swift 5.9+
- **架构**: MVVM模式
- **数据存储**: UserDefaults + JSON

## 开发指南

### 📋 环境要求
- macOS 13.0 或更高版本
- Xcode 15.0 或更高版本
- Swift 5.9 或更高版本

### 🚀 快速开始

1. **克隆项目**
   ```bash
   git clone [项目地址]
   cd WorkStat
   ```

2. **打开项目**
   ```bash
   open WorkStat.xcodeproj
   ```

3. **运行应用**
   - 选择目标设备: "My Mac"
   - 点击运行按钮或按 `Cmd + R`

### 🔧 开发配置

#### Bundle Identifier 设置
在 Xcode 中设置唯一的 Bundle Identifier:
```
com.yourcompany.workstat
```

#### 签名配置
1. 在 "Signing & Capabilities" 中选择开发团队
2. 确保 "Automatically manage signing" 已启用
3. 选择合适的 Provisioning Profile

## 打包发布

### 📦 本地打包

#### 1. Archive 构建
1. 在 Xcode 中选择 "Product" → "Archive"
2. 等待构建完成
3. 在 Organizer 中查看构建结果

#### 2. 导出应用
1. 选择 "Distribute App"
2. 选择分发方式:
   - **Developer ID**: 用于直接分发
   - **Mac App Store**: 用于App Store提交

### 🏪 App Store 提交

#### 准备工作
1. **Apple Developer 账号**
   - 注册 Apple Developer Program
   - 费用: $99/年

2. **App Store Connect 配置**
   - 创建新应用记录
   - 设置应用信息和元数据

#### 提交步骤

1. **应用信息配置**
   ```
   应用名称: 
   - 中文市场: 待办事项统计
   - 国际市场: WorkStat
   
   类别: 效率工具
   价格: 免费
   ```

2. **版本信息**
   ```
   版本号: 1.0
   新功能描述: 首次发布
   关键词: 待办事项,统计,效率,时间管理
   ```

3. **应用截图**
   - 准备不同尺寸的应用截图
   - 建议尺寸: 1280x800, 1440x900, 2560x1600
   - 展示主要功能界面

4. **应用描述**
   ```
   中文描述:
   WorkStat 是一款简洁优雅的待办事项统计工具。通过直观的圆饼图，
   帮助您清楚了解各项任务的时间分配，提高工作效率。
   
   英文描述:
   WorkStat is a clean and elegant todo statistics tool. 
   With intuitive pie charts, it helps you understand 
   task time allocation and improve productivity.
   ```

5. **提交审核**
   - 上传构建版本
   - 填写审核信息
   - 提交等待审核

#### 审核注意事项

1. **隐私政策**
   - 如果收集用户数据，需要提供隐私政策
   - 本应用仅本地存储，无需隐私政策

2. **应用内购买**
   - 当前版本为免费应用
   - 如需添加付费功能，需配置应用内购买

3. **审核指南遵循**
   - 确保应用功能完整
   - 界面美观，用户体验良好
   - 无崩溃和严重bug

### 🔄 版本更新

#### 更新流程
1. 修改代码并测试
2. 更新版本号 (CFBundleShortVersionString)
3. 更新构建号 (CFBundleVersion)
4. 重新打包和提交

#### 版本号规则
```
主版本.次版本.修订版本
例如: 1.0.0 → 1.0.1 → 1.1.0 → 2.0.0
```

## 测试指南

### 🧪 功能测试

#### 基础功能
- [ ] 添加待办事项
- [ ] 编辑待办事项
- [ ] 删除待办事项
- [ ] 切换完成状态
- [ ] 百分比验证（不超过100%）

#### 界面测试
- [ ] 圆饼图显示正确
- [ ] 动画效果流畅
- [ ] 响应式布局
- [ ] 深色/浅色模式适配

#### 数据测试
- [ ] 数据持久化
- [ ] 应用重启后数据保持
- [ ] 边界情况处理

### 🌐 本地化测试

#### 语言切换
1. 系统偏好设置 → 语言与地区
2. 添加/切换语言
3. 重启应用验证

#### 文本检查
- [ ] 所有文本正确本地化
- [ ] 无硬编码文本
- [ ] 文本长度适配

## 常见问题

### ❓ 开发问题

**Q: 编译错误 "Cannot find type 'TodoItem'"**
A: 确保所有文件都已添加到项目中，检查 Target Membership

**Q: 本地化不生效**
A: 检查 Info.plist 中的本地化配置，确保 .strings 文件格式正确

**Q: 圆饼图不显示**
A: 检查数据是否为空，确保百分比大于0

### 🔧 打包问题

**Q: 签名失败**
A: 检查开发者证书和 Provisioning Profile 是否有效

**Q: Archive 失败**
A: 清理项目 (Product → Clean Build Folder) 后重试

**Q: App Store 审核被拒**
A: 查看审核反馈，根据指导修改后重新提交

## 贡献指南

### 📝 代码规范
- 使用 Swift 官方代码风格
- 每行代码添加中文注释
- 遵循 MVVM 架构模式
- 使用有意义的变量和函数名

### 🐛 Bug 报告
请包含以下信息:
- macOS 版本
- 应用版本
- 重现步骤
- 预期行为
- 实际行为
- 截图（如适用）

### 💡 功能建议
欢迎提出新功能建议，请描述:
- 功能用途
- 使用场景
- 实现思路

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 联系方式

- **开发者**: Austin CN
- **邮箱**: feedback@workstat.app
- **GitHub**: [项目地址]

---

**感谢使用 WorkStat！如果这个项目对您有帮助，请给我们一个 ⭐️**