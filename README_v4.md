# ChatGPT Translator v4.0 - Real-time Translation + Image Recognition Version

## 🎉 Installation successful!

Application installed and started: `/Applications/ChatGPTTranslator.app`

## ✨ Brand new features

### 1. Real-time translation ⚡️
- **Type and Translate** - No need to click the translate button
- **Auto Delay** - Stop typing and automatically translate after 0.8 seconds
- **Smooth experience** - real-time translation like NetEase Youdao

### 2. Image recognition 📷
- **OCR text recognition** - using Apple Vision framework
- **High-precision recognition** - supports Chinese, English, Japanese, Korean, etc.
- **Instant Translation** - Automatic translation after recognition

### 3. Multiple input methods 📥
- **Direct input** - enter text in the text box on the left
- **Copy and Paste** - Press `Cmd+V` to paste the image
- **Select File** - Click the "Select Image" button to upload
- **Multi-line support** - supports long text and multi-line text

## 🚀 How to use

### text translation
1. Enter text in the left input box
2. Automatically translate 0.8 seconds after stopping typing
3. Translation results are displayed on the right in real time
4. Click the "Copy" button to copy the results

### Picture Translation

#### Method 1: Paste the picture
1. Copy pictures (screenshots, web pictures, etc.) in other applications
2. Press `Cmd+V` in the left input box to paste
3. Automatically recognize text in pictures
4. Automatically translate recognized text

#### Method 2: Select image file
1. Click the "Select Picture" button on the left
2. Select image files on your computer
3. Automatically recognize and translate

#### Method 3: Paste the screenshot directly
1. Press `Cmd+Shift+4` to take a screenshot
2. Press `Cmd+V` to paste in the application
3. Automatically recognize and translate

## 📱 Interface description

```
┌─────────────────────────────────────────────────────────┐
│ ChatGPT Translator   real-time translation|Image recognition   [English] ⇄ [Chinese]  ⚙️│
├──────────────────────────┬──────────────────────────────┤
│ Enter text or pictures  [Select picture] │ Translation results              [Copy] │
│                          │                              │
│ [input area/Picture preview]       │ [Translation result display area]              │
│                          │                              │
│                          │ 💡 Tips:                     │
│                          │ • Enter text and automatically translate it            │
│                          │ • Copy image and paste(Cmd+V)      │
│                          │ • click"Select picture"Upload          │
└──────────────────────────┴──────────────────────────────┘
```

## 🌐 Supported languages

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

## ⚡️ Features

### real-time translation
- ✅ Translate as you type, no need to click a button
- ✅ Intelligent debounce to avoid frequent requests
- ✅ Supports multi-line long text
- ✅ Update translation results in real time

### Image recognition
- ✅ Use Apple Vision framework, offline recognition
- ✅ Supports text recognition in multiple languages
- ✅ High-precision OCR recognition
- ✅ Automatic translation recognition results

### User experience
- ✅ Native macOS interface
- ✅ Smooth and fast response
- ✅ Copy translation results with one click
- ✅ Support shortcut key operation

### completely free
- ✅ No API Key required
- ✅ No login required
- ✅ Unlimited use
- ✅ Picture recognition completely offline

## 🔧 Technical details

### Translation Services
- **API**: Google Translate Unofficial API
- **Endpoint**: `https://translate.googleapis.com/translate_a/single`
- **Features**: Free, fast, high quality

### Image recognition
- **Framework**: Apple Vision
- **Engine**: VNRecognizeTextRequest
- **Features**: Offline, fast, accurate
- **Support**: Chinese, English, Japanese, Korean and other languages

### real-time translation
- **Anti-Shake Delay**: 0.8 seconds
- **Cancellation mechanism**: Automatically cancel outstanding requests
- **Asynchronous processing**: Does not block the UI

## 📝 Tips for use

### 1. Quick screenshot translation
```
1. Press Cmd+Shift+4 Screenshot
2. Press in the translator Cmd+V
3. Automatically recognize and translate
```

### 2. Web page image translation
```
1. Right click on the web page image
2. Select"Copy image"
3. Press in the translator Cmd+V
```

### 3. Long text translation
```
1. Enter multiple lines of text directly on the left
2. Automatically translate after stopping typing
3. supports line breaks and paragraphs
```

### 4. Quickly switch languages
```
1. Click between languages ⇄ icon
2. Automatically exchange source and target languages
3. If there is a translation result,Will automatically reverse translate
```

## ⚠️ Precautions

### Network requirements
- Text translation requires an internet connection
- Image recognition is completely offline, no network required
- Recommended to use when the network is stable

### Usage restrictions
- Google may be throttling requests that are too frequent
- It is recommended to use it rationally and avoid a large number of translations in a short time.
- No problem for normal use

### Picture request
- Supported formats: PNG, JPEG, TIFF
- It is recommended that the pictures be clear and the text clear
- Text that is too small or blurry may not be recognized accurately

### Privacy and Security
- Text translations are sent to Google servers
- Image recognition is completed locally and does not upload
- App does not store any content
- Does not collect user data

## ❓ Frequently Asked Questions

**Q: Why is it not translated immediately after typing? **
A: In order to avoid frequent requests, a delay of 0.8 seconds is set. It will be automatically translated after you stop typing.

**Q: Is the picture recognition accurate? **
A: Using the Apple Vision framework, the recognition accuracy is very high. It is recommended to use clear pictures.

**Q: Does it support handwritten text? **
A: Supported, but the print recognition effect is the best.

**Q: Can it be used offline? **
A: Image recognition can be done offline, but text translation requires an internet connection.

**Q: Why does translation sometimes fail? **
A: It may be a network problem or a temporary restriction by Google. Just try again later.

**Q: Can I translate multiple pictures at one time? **
A: The current version can only process one picture at a time.

**Q: Will the translation results be saved? **
A: No. The application does not store any translation content to protect privacy.

## 🆚 Compare with other versions

| Features | v1.0 | v2.0 | v3.0 | v4.0 ✨ |
|------|------|------|------|---------|
| Text Translation | ✅ | ✅ | ✅ | ✅ |
| Configuration required | ✅ API Key | ✅ Token | ❌ | ❌ |
| Real-time translation | ❌ | ❌ | ❌ | ✅ |
| Image Recognition | ❌ | ❌ | ❌ | ✅ |
| Copy and paste pictures | ❌ | ❌ | ❌ | ✅ |
| Multi-line support | ✅ | ✅ | ❌ | ✅ |
| Totally Free | ❌ | ❌ | ✅ | ✅ |

## 🎉 Get started

The application has been launched, now you can:

1. **Try text translation**
   - Enter "Hello World"
   - Automatically translated into Chinese

2. **Try image translation**
   - Take a screenshot with text
   - Press Cmd+V to paste
   - Automatically recognize and translate

3. **Try switching language**
   - Click the ⇄ icon in the middle
   - Quickly switch translation direction

## 🔄 Update history

### v4.0 (current version) - 2026-01-16
- ✨ Added real-time translation function
- ✨ Added image recognition function
- ✨ Support copy and paste pictures
- ✨ Support multi-line long text
- 🎨 Optimize user interface
- ⚡️ Improve translation speed

### v3.0
- Use the free translation API
- No configuration required

### v2.0
- Integrate ChatGPT API
- Access Token required

### v1.0
- Basic translation function
- Requires OpenAI API Key

---

**Version**: 4.0 (real-time translation + image recognition version)
**Updated date**: 2026-01-16
**Completely Free | Real-time Translation | Image Recognition**

🚀 Enjoy a new translation experience!
