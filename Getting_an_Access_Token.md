# How to get ChatGPT Access Token

## Method 1: Through browser Cookies (recommended)

### Steps:

1. **Open ChatGPT website**
   - Visit https://chatgpt.com in your browser
   - Make sure you are logged in

2. **Open developer tools**
   - Chrome/Edge: Press `F12` or `Cmd+Option+I` (Mac) or `Ctrl+Shift+I` (Windows)
   - Safari: Press `Cmd+Option+I` (need to enable the developer menu in settings first)

3. **Cookies found**
   - Click on the `Application` (Application) tab
   - Expand left `Cookies`
   - Click `https://chatgpt.com`

4. **Copy Session Token**
   - Find the item named `__Secure-next-auth.session-token` in the cookie list on the right
   - copy its `Value` (value)

5. **Paste into application**
   - Open the ChatGPT translator application
   - Click the gear icon in the upper right corner ⚙️
   - Paste the copied value into the "ChatGPT Access Token" input box
   - Click to close

## Method 2: Request through Network

### Steps:

1. **Open the Network tab of the developer tools**
   - Visit https://chatgpt.com
   - Open developer tools (F12)
   - Switch to `Network` (network) tab

2. **Perform any operation**
   - Send a message in ChatGPT
   - Find a request starting with `conversation` or `backend-api` in the Network tag

3. **View request header**
   - Click the request
   - View `Headers` (request header)
   - Found `Authorization` field
   - Copy the token behind `Bearer`

4. **Paste into application**
   - Open the ChatGPT translator application
   - Click the gear icon in the upper right corner ⚙️
   - Paste the copied token into the input box

## IMPORTANT NOTICE

⚠️ **SAFETY WARNING:**
- Access Token is the certificate of your account, equivalent to the password
- Do not share the token with anyone
- Don’t reveal it in public or in screenshots
- Token usually expires after a period of time and needs to be obtained again

⚠️ **Usage restrictions:**
- ChatGPT has usage frequency restrictions
- Too frequent requests may cause the account to be restricted.
- It is recommended to use the translation function appropriately

## FAQ

**Q: Where is Token stored?**
A: Token is stored in the local UserDefaults of your Mac and will not be uploaded to any server.

**Q: How long does it take for the Token to expire?**
A: ChatGPT's session token usually expires after a few days to a few weeks, and the specific time is controlled by OpenAI.

**Q: What should I do if it prompts authentication failure?**
A: Re-obtain a new Access Token and update it to the application.

**Q: Can I use a free account?**
A: Yes, as long as you can log in to the ChatGPT website, you can get the token.

## Technical details

API endpoint used by this application:
- `https://chatgpt.com/backend-api/conversation`

Request format:
```
POST /backend-api/conversation
Authorization: Bearer <your-token>
Content-Type: application/json
```

This is the same API used by the ChatGPT website, so the translation quality is exactly the same as the web version.
