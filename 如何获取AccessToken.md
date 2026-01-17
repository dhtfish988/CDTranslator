# 如何获取 ChatGPT Access Token

## 方法一: 通过浏览器 Cookies (推荐)

### 步骤:

1. **打开 ChatGPT 网站**
   - 在浏览器中访问 https://chatgpt.com
   - 确保你已经登录

2. **打开开发者工具**
   - Chrome/Edge: 按 `F12` 或 `Cmd+Option+I` (Mac) 或 `Ctrl+Shift+I` (Windows)
   - Safari: 按 `Cmd+Option+I` (需要先在设置中启用开发者菜单)

3. **找到 Cookies**
   - 点击 `Application` (应用) 标签
   - 左侧展开 `Cookies`
   - 点击 `https://chatgpt.com`

4. **复制 Session Token**
   - 在右侧的 Cookie 列表中找到名为 `__Secure-next-auth.session-token` 的项
   - 复制它的 `Value` (值)

5. **粘贴到应用中**
   - 打开 ChatGPT 翻译器应用
   - 点击右上角的齿轮图标 ⚙️
   - 将复制的值粘贴到 "ChatGPT Access Token" 输入框
   - 点击关闭

## 方法二: 通过 Network 请求

### 步骤:

1. **打开开发者工具的 Network 标签**
   - 访问 https://chatgpt.com
   - 打开开发者工具 (F12)
   - 切换到 `Network` (网络) 标签

2. **进行任意操作**
   - 在 ChatGPT 中发送一条消息
   - 在 Network 标签中找到一个 `conversation` 或 `backend-api` 开头的请求

3. **查看请求头**
   - 点击该请求
   - 查看 `Headers` (请求头)
   - 找到 `Authorization` 字段
   - 复制 `Bearer` 后面的 token

4. **粘贴到应用中**
   - 打开 ChatGPT 翻译器应用
   - 点击右上角的齿轮图标 ⚙️
   - 将复制的 token 粘贴到输入框

## 重要提示

⚠️ **安全警告:**
- Access Token 是你账号的凭证,相当于密码
- 不要将 token 分享给任何人
- 不要在公共场合或截图中泄露
- Token 通常会在一段时间后过期,需要重新获取

⚠️ **使用限制:**
- ChatGPT 有使用频率限制
- 过于频繁的请求可能导致账号被限制
- 建议合理使用翻译功能

## 常见问题

**Q: Token 在哪里存储?**
A: Token 存储在你的 Mac 本地 UserDefaults 中,不会上传到任何服务器。

**Q: Token 多久过期?**
A: ChatGPT 的 session token 通常在几天到几周后过期,具体时间由 OpenAI 控制。

**Q: 提示认证失败怎么办?**
A: 重新获取一个新的 Access Token 并更新到应用中。

**Q: 可以使用免费账号吗?**
A: 可以,只要你能登录 ChatGPT 网站,就可以获取 token。

## 技术细节

本应用使用的 API 端点:
- `https://chatgpt.com/backend-api/conversation`

请求格式:
```
POST /backend-api/conversation
Authorization: Bearer <your-token>
Content-Type: application/json
```

这是 ChatGPT 网站使用的相同 API,因此翻译质量和网页版完全一致。
