# ChatGPT Translator - Quick Start Guide

## ✅ App installed

Application location: `/Applications/ChatGPTTranslator.app`

## 🚀 Quick setup (3 steps)

### Step 1: Get Access Token

1. Open the browser to visit https://chatgpt.com and log in
2. Press `F12` or `Cmd+Option+I` to open the developer tools
3. Click on the `Application` (Application) tab
4. Expand left `Cookies` -> `https://chatgpt.com`
5. Found `__Secure-next-auth.session-token`
6. copy its `Value` (value)

### Step 2: Configure the application

1. Open ChatGPT translator
2. Click the gear icon in the upper right corner ⚙️
3. Paste the token you just copied
4. Click to close

### Step 3: Start Translation

1. Select source and target languages
2. Enter the text to be translated
3. Click the "Translate" button
4. View translation results and copy

## 📱 Features

- ✨ Use ChatGPT official translation interface
- 🌍 Supports translation between 13 languages
- 🔄 Quick language switching
- 📋 Copy translation results with one click
- 💾 Automatically save token configuration
- 🎨 Native macOS interface

## 📝 Precautions

### Token related
- Token is equivalent to your account password, please do not disclose it
- Token will expire after a period of time and needs to be obtained again
- Both free and paid accounts can be used

### Usage restrictions
- ChatGPT has frequency restrictions, please use it rationally
- Too frequent requests may result in temporary throttling
- It is recommended to segment longer texts when translating them.

## 🔧 Technical information

### API endpoint
```
POST https://chatgpt.com/backend-api/conversation
```

### Supported languages
- Chinese (Simplified)
- English
- Japanese
- Korean
- French
- German
- Spanish
- Italian
- Portuguese
- Russian
- Arabic
- Thai
- Vietnamese

## ❓ Frequently Asked Questions

**Q: Prompt "Please set up ChatGPT Access Token first"**
A: Follow steps 1 and 2 to obtain and configure token

**Q: Prompt "Authentication failed"**
A: Token may have expired, get a new one

**Q: The translation result is empty**
A: Check the network connection, or try again later

**Q: Can it be used offline?**
A: No, you need to connect to the ChatGPT server

## 📚 More help

Detailed Token acquisition tutorial: `Getting_an_Access_Token.md`

## 🎉 Enjoy translation!

Now you can use the powerful translation capabilities of ChatGPT!

---

**Version**: 2.0
**Updated date**: 2026-01-16
