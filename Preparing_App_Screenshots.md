# App Screenshot Preparation Guide

## 📸 Screenshot request

### App Store Requirements
- **Size**: 1280 x 800 pixels
- **Format**: PNG or JPEG
- **Quantity**: minimum 1, maximum 10
- **Quality**: HD, no watermark

### It is recommended to prepare 5 screenshots

## 🎯 Screenshot content suggestions

### Screenshot 1: Main interface - real-time translation
**Display content**:
- Enter English text on the left
- Chinese translation results are displayed on the right
- Clear display of two-column layout

**Text content suggestions**:
```
input: Hello, this is CD Translator. It provides real-time translation and image recognition.

Translation: Hello, this isCDTranslator。It provides real-time translation and picture recognition functions.
```

**Key points of screenshots**:
- Demonstrates real-time translation capabilities
- Simple and beautiful interface
- Functions are clear at a glance

---

### Screenshot 2: Image recognition function
**Display content**:
- A picture containing English text is displayed on the left
- The recognized text is displayed below
- Translation results are displayed on the right

**Suggested picture content**:
Find a picture with clear English text, for example:
- Menu
- Signage
- Books page

**Key points of screenshots**:
- Demonstrate image recognition capabilities
- Shows the accuracy of recognition
- Highlight one-click translation

---

### Screenshot 3: Multi-language support
**Display content**:
- Click to open the language selection menu
- Show list of all supported languages
- Demonstrates language switching function

**Key points of screenshots**:
- Display language selection interface
- Outstanding support for 13 languages
- Convenience of display switching

---

### Screenshot 4: Long text translation
**Display content**:
- Enter multiple paragraphs of English text on the left
- Full Chinese translation displayed on the right
- Demonstrate scrolling function

**Text content suggestions**:
```
CD Translator is a powerful and free translation tool for macOS.

Features:
- Real-time translation
- Image text recognition
- Support for 13 languages
- Completely free
- Privacy protected

How to use:
1. Enter text for instant translation
2. Press Cmd+V to paste images
3. Automatic recognition and translation
```

**Key points of screenshots**:
- Demonstrates multi-line text support
- Show translation completeness
- Highlight the smooth experience

---

### Screenshot 5: Feature display
**Display content**:
It can be any of the following scenarios:
- Translation result copy function
- Clear content function
- Quick language switching (⇄ button)
- Complete workflow

**Key points of screenshots**:
- Demonstrate convenient functions
- Highlight user experience
- Show design details

---

## 📝 Screenshot steps

### Method 1: Manual screenshot

1. **Open application**
   ```bash
   open /Applications/CDTranslator.app
   ```

2. **Resize window**
   - Ensure the window is clear and beautiful
   - Not too big or too small

3. **Preparation content**
   - Enter suggested text
   - Waiting for translation to complete

4. **Screenshot**
   - Press `Cmd+Shift+4`
   - Spacebar switches to window mode
   - Click on the application window

5. **Resize**
   ```bash
   sips -z 800 1280 screenshot.png --out app_screenshot_1.png
   ```

### Method 2: Batch processing using script

After creating screenshots of 5 different scenes, use the following script to process them uniformly:

```bash
#!/bin/bash

# Create screenshot directory
mkdir -p app_store_screenshots

# Resize all screenshots to standard size
for i in {1..5}; do
    if [ -f "raw_screenshot_$i.png" ]; then
        sips -z 800 1280 "raw_screenshot_$i.png" \
            --out "app_store_screenshots/screenshot_$i.png"
        echo "✅ Screenshot $i processing completed"
    fi
done

echo "All screenshots are ready!"
echo "Location: app_store_screenshots/"
```

---

## 🎨 Screenshot beautification suggestions

### 1. Use real content
- Don't use Lorem Ipsum
- Use meaningful translated content
- Show actual usage scenarios

### 2. Maintain consistency
- Use the same window size for all screenshots
- Unified interface theme
- Consistent presentation style

### 3. Highlight the key points
- Use arrows or highlight (optional)
- Short text description (optional)
- Showcase key features

### 4. Pay attention to details
- Make sure there are no typos
- Translation results are accurate
- Clean and beautiful interface

---

## ✅ Checklist

Check after screenshot preparation is completed:

- [ ] 5 screenshots in total
- [ ] Each size is 1280 x 800
- [ ] format is PNG
- [ ] Reasonable file size (< 5MB/photo)
- [ ] Content is clear and readable
- [ ] All core features demonstrated
- [ ] No sensitive information
- [ ] No third-party branding
- [ ] Meets Apple review standards

---

## 📤 Upload screenshot

1. Log in to App Store Connect
2. Enter the application page
3. Click "1.0 ready for submission"
4. Scroll to "App Preview and Screenshot"
5. Drag and drop to upload 5 screenshots
6. Arrange in order
7. Save

---

## 💡 Professional advice

### DO ✅
- Demonstrate real functionality
- Use high-quality screenshots
- Highlight core features
- Keep the interface tidy

### DON'T ❌
- Don’t use fake content
- Don’t add too much text
- Don’t use blurry screenshots
- Do not include other App interfaces

---

## 🎬 Optional: Preview video

If you want to make a preview video (optional):

**Requirements**:
- Duration: 15-30 seconds
- Format: MP4 or MOV
- Resolution: 1920x1080 or higher

**Content suggestions**:
1. Open application (2 seconds)
2. Enter text and automatically translate (5 seconds)
3. Paste image recognition translation (5 seconds)
4. Switch language translation (3 seconds)
5. Show final result (2 seconds)

---

**After you have prepared the screenshot, you can upload it to App Store Connect! ** 🚀
