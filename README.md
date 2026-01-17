# ChatGPT 翻译器 macOS 应用

一个使用 OpenAI API 的 macOS 原生翻译应用，提供简洁优雅的翻译界面。

## 功能特点

- ✨ 简洁现代的用户界面
- 🌍 支持 13 种常用语言互译
- 🔄 快速语言切换
- 📋 一键复制翻译结果
- ⚡️ 基于 OpenAI GPT-3.5 Turbo 的高质量翻译
- 💾 自动保存 API Key 配置

## 支持的语言

- 中文（简体）
- 英语
- 日语
- 韩语
- 法语
- 德语
- 西班牙语
- 意大利语
- 葡萄牙语
- 俄语
- 阿拉伯语
- 泰语
- 越南语

## 使用方法

### 1. 获取 OpenAI API Key

访问 [OpenAI Platform](https://platform.openai.com/) 注册账号并获取 API Key。

### 2. 打开项目

使用 Xcode 打开 `ChatGPTTranslator/ChatGPTTranslator.xcodeproj` 文件。

### 3. 构建运行

在 Xcode 中选择目标设备为 "My Mac"，然后点击运行按钮（⌘R）。

### 4. 配置 API Key

首次运行时，点击右上角的齿轮图标，输入你的 OpenAI API Key。

### 5. 开始翻译

1. 选择源语言和目标语言
2. 在左侧输入框输入要翻译的文本
3. 点击"翻译"按钮
4. 翻译结果将显示在右侧
5. 点击"复制"按钮可复制翻译结果

## 系统要求

- macOS 13.0 或更高版本
- Xcode 14.0 或更高版本（用于构建）

## 项目结构

```
ChatGPTTranslator/
├── ChatGPTTranslator/
│   ├── ChatGPTTranslatorApp.swift    # 应用入口
│   ├── ContentView.swift              # 主界面
│   ├── Models/
│   │   ├── TranslationService.swift  # 翻译服务（API 调用）
│   │   └── Language.swift             # 语言模型
│   ├── Assets.xcassets/               # 资源文件
│   ├── Info.plist                     # 应用配置
│   └── ChatGPTTranslator.entitlements # 权限配置
└── ChatGPTTranslator.xcodeproj        # Xcode 项目文件
```

## 主要功能说明

### TranslationService

处理与 OpenAI API 的通信，负责：
- 发送翻译请求
- 处理 API 响应
- 错误处理和状态管理

### ContentView

主界面包含：
- 双栏翻译界面（源文本 | 翻译结果）
- 语言选择下拉菜单
- 翻译按钮和操作按钮
- 状态栏显示错误或进度信息

### SettingsView

配置界面，用于设置和保存 OpenAI API Key。

## 注意事项

- 使用 OpenAI API 需要付费，请注意控制使用量
- API Key 存储在本地 UserDefaults 中，请妥善保管
- 需要网络连接才能使用翻译功能
- 翻译质量取决于 OpenAI 的 GPT-3.5 模型

## 开发计划

- [ ] 添加翻译历史记录
- [ ] 支持多个翻译引擎切换
- [ ] 添加快捷键支持
- [ ] 支持批量翻译
- [ ] 添加语音朗读功能
- [ ] 支持拖拽文件翻译

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！
