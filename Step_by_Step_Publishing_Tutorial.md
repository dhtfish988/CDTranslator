# CDTranslator - Step-by-step tutorial

## 📱 Your account information

- **Apple ID**: dhtfish1@gmail.com
- **Already have a developer account**: ✅

---

## 🎯 Steps you can complete today

Since you already have a developer account, you can start listing it directly!

Estimated total time: **2-3 hours**

---

## Step 1: Upload privacy policy (15 minutes)

### Use GitHub Pages (recommended, free)

#### 1.1 Log in to GitHub
```
Visit: https://github.com
If you don’t have an account, register one (free)
```

#### 1.2 Create a new warehouse
```
1. Click on the upper right corner "+" → "New repository"
2. Warehouse name: cd-translator-privacy
3. Select Public（public)
4. Check "Add a README file"
5. click "Create repository"
```

#### 1.3 Upload Privacy Policy
```
1. Click on the warehouse page "Add file" → "Upload files"
2. Drag and drop files: /path/to/CDTranslator/privacy_policy.html
3. click "Commit changes"
```

#### 1.4 Enable GitHub Pages
```
1. Click on the warehouse "Settings"
2. Found in the left menu "Pages"
3. Source Select "main" branch
4. click "Save"
5. Waiting 1-2 minutes, the URL will be displayed
```

#### 1.5 Get Privacy Policy URL
```
URL format: https://your username.github.io/cd-translator-privacy/privacy_policy.html

For example: https://dhtfish1.github.io/cd-translator-privacy/privacy_policy.html

✅ Copy this URL, you will use it later
```

---

## Step 2: Prepare application screenshots (30-60 minutes)

### 2.1 Open the application
```bash
open /Applications/CDTranslator.app
```

### 2.2 Take 5 screenshots

#### Screenshot 1: Main interface - real-time translation
```
Content:
Left input: Hello, welcome to CD Translator
Display on the right: Hello, welcomeCDTranslator

Operation:
1. Adjust window size to fit
2. Enter the above in English
3. Waiting for translation to complete
4. Cmd+Shift+4 → Space → Click window
5. Save screenshot to desktop
```

#### Screenshot 2: Image recognition
```
Content:
Paste a picture with English and display the recognition and translation results

Operation:
1. Find a picture with English (webpage screenshot, menu, etc.)
2. Copy picture
3. In application Cmd+V Paste
4. Waiting for recognition to complete
5. Cmd+Shift+4 → Space → Click on the window to take a screenshot
```

#### Screenshot 3: Language selection
```
Content:
Click to open the language selection menu to display the supported languages

Operation:
1. click"English"or"Chinese"Drop-down menu
2. Display language list
3. Cmd+Shift+4 → Space → Click on the window to take a screenshot
```

#### Screenshot 4: Long text translation
```
Content:
Enter multiple lines of English on the left and display the complete translation on the right

Sample text:
CD Translator is a powerful translation tool.
Features include real-time translation and image recognition.
It supports 13 languages and is completely free.

Operation:
1. Enter the above multi-line text
2. Waiting for translation to complete
3. Cmd+Shift+4 → Space → Click on the window to take a screenshot
```

#### Screenshot 5: Clear and copy functions
```
Content:
Translation results are displayed in the upper right corner."Clear"and"Copy"Button

Operation:
1. Keep translated content available
2. Cmd+Shift+4 → Space → Click on the window to take a screenshot
```

### 2.3 Adjust screenshot size
```bash
# Create screenshot folder
cd ~/Desktop
mkdir AppStoreScreenshots

# Resize all screenshots to 1280x800
cd ~/Desktop/ChatGptTranslation
for i in 1 2 3 4 5; do
    sips -z 800 1280 ~/Desktop/Screenshot*.png --out ~/Desktop/AppStoreScreenshots/screenshot_$i.png
done
```

Or manual adjustment:
```bash
sips -z 800 1280 Original screenshot.png --out ~/Desktop/AppStoreScreenshots/screenshot_1.png
```

**✅ Confirmed that all 5 screenshots are in the ~/Desktop/AppStoreScreenshots/ folder**

---

## Step 3: Log in to App Store Connect (5 minutes)

### 3.1 Visit the website
```
Open the browser and visit: https://appstoreconnect.apple.com/

Log in with your account:
Email: dhtfish1@gmail.com
Password: Aa12345679
```

### 3.2 may require two-factor authentication
```
If prompted for two-factor authentication:
1. Check your iPhone/iPad/Mac
2. Enter the verification code received
3. Select"Trust this browser"
```

---

## Step 4: Create the application (15 minutes)

### 4.1 Create new App
```
1. Click on the upper left corner "My App"
2. Click on blue "+" number
3. Select "New App"
```

### 4.2 Fill in basic information
```
Platform:
  ☑ macOS （Check only macOS）

Name:
  CDTranslator

Main language:
  Simplified Chinese

Bundle ID:
  Click the drop-down box → "Create Bundle ID"

  If there is already com.cd.translator，Direct selection
  If not, fill in:
    - Bundle ID: com.cd.translator
    - Description: CD Translator

SKU:
  cdtranslator001

User access rights:
  Full access (default)
```

### 4.3 Click "Create"
```
Wait a few seconds, the application is created successfully
```

---

## Step 5: Fill in application information (30 minutes)

### 5.1 App Information

#### Category
```
Main categories: Productivity Tools (Productivity)
Secondary category: (optional) Business (Business)
```

#### Content copyright
```
2026 Your Name
```

#### Age Rating
```
click"Editor"
Select all questions"No"
The age rating will be displayed as: 4+
click"Complete"
```

### 5.2 Pricing and Sales Scope

```
1. Click on the left"Pricing and Sales Range"
2. Price: Select"Free"
3. Sales scope: All countries/Region (default)
4. Click on the upper right corner"Storage"
```

### 5.3 App Privacy

```
1. Click on the left"App Privacy"
2. click"Start"

Privacy Policy:
  Paste your GitHub Pages URL
  For example: https://dhtfish1.github.io/cd-translator-privacy/privacy_policy.html

Data collection:
  Question: "Does this app collect user data?"
  Answer: No

click"Storage"
```

---

## Step 6: Prepare version for submission (20 minutes)

### 6.1 Click "1.0 Prepare to Submit" on the left

### 6.2 App Store localization information

#### Screen capture and preview

```
Scroll to "macOS"
Click on the screenshot area

Upload screenshots (in order):
1. Drag in screenshot_1.png (Main interface)
2. Drag in screenshot_2.png (Image recognition)
3. Drag in screenshot_3.png (Language selection)
4. Drag in screenshot_4.png (long text)
5. Drag in screenshot_5.png (Function display)

✅ Make sure the order is correct and you can drag and adjust
```

#### Promotional text (optional)
```
Just leave it blank
```

#### Description
```
Copy and paste the following content:

CDTranslatoris a simple and efficient translation tool, designed for macOS Design.

✨ Core functions

【real-time translation】
• Translate as you type, no need to click a button
• Intelligent debounce, smooth experience
• Supports multi-line long text translation

【Image recognition】
• After taking a screenshot, press Cmd+V Paste directly
• Automatically recognize text in pictures
• Supports multiple languages such as Chinese, English, Japanese and Korean
• use Apple Vision Frame, high accuracy

【Multi-language support】
Support 13 Translation between common languages:
Chinese, English, Japanese, Korean, French, German, Spanish, Italian, Portuguese, Russian, Arabic, Thai, Vietnamese

⚡️ Easy to use

1. text translation
   - Enter text and automatically translate it
   - Stop input 0.8 Display results after seconds
   - Copy translation results with one click

2. Picture Translation
   - Cmd+Shift+4 Screenshot
   - Press in the app Cmd+V Paste
   - Automatically recognize and translate

💝 completely free

• No registration required to log in
• No configuration required API
• No ads, no in-app purchases
• Totally free to use

🔒 Privacy protection

• Image recognition is completely done locally
• Does not store any translation content
• Does not collect user data
• Protect your privacy and security

Applicable scenarios:
• Learn foreign languages and look up words instantly
• Translating documents at work
• Browse foreign language web pages
• Recognize picture text
• Daily translation needs
```

#### Keywords
```
Translation,Image recognition,OCR,real-time translation,Multilingual,Free Translation,text recognition,Screenshot translation,Language,Efficiency
```

#### Technical support website
```
Fill in your email or GitHub:
https://github.com/dhtfish1/cd-translator
or
mailto:dhtfish1@gmail.com
```

#### Marketing URL (optional)
```
Leave blank
```

### 6.3 General Information

#### build version
```
Leave it blank for now (it will be uploaded in the seventh step)
```

#### Version
```
1.0（Already filled in, no modification required)
```

#### Copyright
```
© 2026 dhtfish1
```

#### Apple ID
```
Automatically fill in, no need to modify
```

---

## Step 7: Use Xcode to upload the application (30-60 minutes)

### 7.1 Open the terminal and create a formal Xcode project

```bash
cd ~/Desktop/ChatGptTranslation
mkdir -p CDTranslator.xcodeproj
```

Since applications compiled from the command line cannot be uploaded directly, we need to create a simple method:

### 7.2 Create upload script

```bash
cat > ~/Desktop/ChatGptTranslation/upload_guide.sh << 'EOF'
#!/bin/bash

echo "================================================"
echo "CDTranslator - App Store Upload Guide"
echo "================================================"
echo ""
echo "Since the application is compiled through the command line, we need to upload it using the following steps:"
echo ""
echo "Method 1: Use Application Loader (recommended)"
echo "-----------------------------------------------"
echo "1. Open Finder"
echo "2. Go to /Applications/Xcode.app/Contents/Applications/"
echo "3. Double-click to open 'Application Loader.app'"
echo "4. Log in with account: dhtfish1@gmail.com"
echo "5. Click ' to deliver your App'"
echo "6. Select the application package: /path/to/CDTranslator/build/CDTranslator.app"
echo "7. Click ' next ' and upload"
echo ""
echo "Method 2: Use Transporter (included with macOS)"
echo "-----------------------------------------------"
echo "1. Open the 'Transporter' application"
echo "   (Search for Transporter in Launchpad)"
echo "2. Login account: dhtfish1@gmail.com"
echo "3. Click '+' number to add application"
echo "4. Select: /path/to/CDTranslator/build/CDTranslator.app"
echo "5. Click ' to deliver '"
echo ""
echo "⚠️ IMPORTANT NOTE:"
echo "-----------------------------------------------"
echo "If the upload fails, the application requires correct code signing"
echo "In this case, we need:"
echo "1. Create a certificate on the Apple Developer website"
echo "2. Use the codesign command to sign the application"
echo "3. Upload again"
echo ""
echo "If you encounter any problems, please tell me and I will help you solve them!"
echo "================================================"
EOF

chmod +x ~/Desktop/ChatGptTranslation/upload_guide.sh
~/Desktop/ChatGptTranslation/upload_guide.sh
```

### 7.3 Try to use Transporter to upload

```
1. Open Spotlight (Cmd+Space)
2. Search "Transporter"
3. Open Transporter Application
4. Log in with your account: dhtfish1@gmail.com
5. click "+" Add
6. Select: /path/to/CDTranslator/build/CDTranslator.app
7. click "Delivery"
```

**If prompted for signature issues**, continue to the next step

### 7.4 signed application (if required)

```bash
# List available signing identities first
security find-identity -v -p codesigning

# Sign with your developer identity
codesign --deep --force --verify --verbose --sign "Apple Development: dhtfish1@gmail.com" \
/path/to/CDTranslator/build/CDTranslator.app

# Verify signature
codesign --verify --deep --strict --verbose=2 \
/path/to/CDTranslator/build/CDTranslator.app
```

---

## Step 8: Submit for review (10 minutes)

### 8.1 waiting for build to appear

```
1. Return App Store Connect
2. Refresh the page
3. Waiting for the build to appear (10-30minutes)
4. will appear in"build version"Seen everywhere "1.0"
```

### 8.2 Select build version

```
in "1.0 ready for submission" page
Found "build version"
click "+" number
Select 1.0 Build
click "Complete"
```

### 8.3 Fill in the review information

#### App review information

```
Contact information:
  Name: Your Name
  Phone: +86 138xxxxxxxx
  Email: dhtfish1@gmail.com

Remarks:
Application instructions:

1. CDTranslatoris a free translation tool, use Google Translate API Provides translation services.

2. Use of image recognition function Apple Vision Framework, completely completed locally, no images will be uploaded.

3. The application is completely free, no ads, no in-app purchases, no registration required.

4. Test instructions:
   - Open application
   - Enter any English on the left and the Chinese translation will automatically be displayed on the right
   - After taking a screenshot, press Cmd+V，The application will recognize the text in the picture and translate it

If you have any questions, please contact: dhtfish1@gmail.com
```

#### Content copyright

```
Check: "This App makes unintentional or unauthorized use of third-party content"
```

#### Advertising Identifier

```
Question: this App Whether to use the advertising identifier(IDFA)?
Answer: No
```

### 8.4 Submit for review

```
1. Check that all information is completed
2. Click on the upper right corner "Add for review"
3. Click after confirmation "Submit for review"
4. The status changes to "Waiting for review"
```

✅ **Done! Waiting for Apple review (2-5 days)**

---

## 📧 Notification of review results

### Approved ✅
```
You will receive an email:
Theme: Your app is now available on the App Store

Then:
1. The application is automatically put on the shelves
2. Available in Mac App Store Searched "CDTranslator"
3. Share with friends!
```

### Review rejected ❌
```
You will receive an email explaining the reason

Common causes:
1. Privacy policy cannot be accessed - Check GitHub Pages URL
2. App crashes - needs repair Bug
3. Inaccurate description - Modify description

Solution:
1. Check the reasons for rejection
2. Fix the problem
3. Resubmit
```

---

## ⚠️Possible problems

### Problem 1: Unable to upload application
**Cause**: The application was not signed correctly
**Solution**:
```bash
# Create signature application script
cat > ~/Desktop/ChatGptTranslation/sign_app.sh << 'EOF'
#!/bin/bash
# First install the developer certificate in Keychain Access
# Then run this script to sign the application

codesign --deep --force --verify --verbose \
--sign "3rd Party Mac Developer Application: Your Name (TEAM_ID)" \
--entitlements ChatGPTTranslator/ChatGPTTranslator/ChatGPTTranslator.entitlements \
/path/to/CDTranslator/build/CDTranslator.app
EOF

chmod +x ~/Desktop/ChatGptTranslation/sign_app.sh
```

### Problem 2: The build version never appears
**Reason**: Upload failed or is being processed
**Solution**:
- Wait 30-60 minutes
- Check your mailbox for error notifications
- Reupload

### Question 3: The privacy policy URL cannot be accessed
**Cause**: GitHub Pages is not enabled or the URL is wrong
**Solution**:
- Confirm that GitHub Pages is enabled
- Test whether the URL can be opened
- Update URL in App Store Connect

---

## 📞Need help?

If you encounter problems at any step:

1. **Screenshot problem location**
2. **Tell me the specific error message**
3. **I will help you solve it**

I have explained the frequently asked questions in the document. If you follow the steps, you will basically have no problems!

---

## ✅ Quick Checklist

Final confirmation before submission:

- [ ] Privacy policy has been uploaded to GitHub Pages
- [ ] 5 screenshots are ready
- [ ] App Store Connect Login
- [ ] Application information has been filled in completely
- [ ] Application description pasted
- [ ] Keywords have been filled in
- [ ] Privacy Policy URL Filled
- [ ] Screenshots have been uploaded in order
- [ ] Review instructions have been filled in
- [ ] App uploaded to App Store Connect
- [ ] Build version selected
- [ ] Clicked to submit for review

---

**Are you ready? Let’s start putting it on the shelves! ** 🚀

**Estimated completion time: this afternoon! **

**I wish you a successful review! ** 🎉
