# CDTranslator - Complete Guide to App Store Listing

## 📋 Table of Contents

1. [1. Preparation](#1-preparation)
2. [2. Developer account](#2-developer-account)
3. [3. Application information preparation](#3-application-information-preparation)
4. [4. Technical preparation](#4-technical-preparation)
5. [5. Submit for review](#5-submit-for-review)
6. [6. Review precautions](#6-review-precautions)

---

## 1. Preparation

### Required Materials List

- [ ] Apple Developer Account ($99/year)
- [ ] Application Icon (Completed ✅)
- [ ] Application screenshots (5 photos)
- [ ] Application description copy
- [ ] Privacy Policy Page
- [ ] Support web page/email
- [ ] Xcode project configuration
- [ ] Code Signing Certificate

---

## 2. Developer account

### Register Apple Developer

1. **Visit**: https://developer.apple.com/programs/
2. **Fee**: $99/year
3. **Type**: Select personal or company account
4. **Time**: It takes 1-2 days to pass the review

### Registration steps

```
1. use Apple ID Login
2. Select account type (personal/company)
3. Fill in developer information
4. Agree to the agreement
5. Pay annual fee $99
6. Waiting for approval
```

---

## 3. Application information preparation

### 3.1 Application Description

#### Application name
```
CDTranslator
```

#### Subtitle (within 30 characters)
```
real-time translation·Image recognition
```

#### Application description (within 4000 characters)

```
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

🎨 Beautifully designed

• native macOS Interface
• Simple and modern design
• Smooth animation effect
• Compliant Apple Design specifications

Applicable scenarios:
• Learn foreign languages and look up words instantly
• Translating documents at work
• Browse foreign language web pages
• Recognize picture text
• Daily translation needs
```

#### Keywords (within 100 characters)
```
Translation,Image recognition,OCR,real-time translation,Multilingual,Free Translation,text recognition,Screenshot translation
```

#### Promotional text (within 170 characters)
```
Brand new CDTranslator！real-time translation+Image recognition, completely free, no configuration required. After screenshot Cmd+V Paste recognition translation directly, support13language.
```

### 3.2 Application Category

- **Main Category**: Productivity Tools (Productivity)
- **Category**: Business (Business)

### 3.3 age rating

- **Age**: 4+ (all ages)
- **Content**: No inappropriate content

### 3.4 Copyright information

```
© 2026 Your Name. All rights reserved.
```

---

## 4. Technical preparation

### 4.1 Create App ID

On the Apple Developer website:

1. Enter Certificates, Identifiers & Profiles
2. Click Identifiers → App IDs
3. Create a new App ID:
   - Name: `CD Translator`
   - Bundle ID: `com.cd.translator`
   - Capabilities:
     - App Sandbox ✅
     - Network Client ✅

### 4.2 Create privacy policy

The privacy policy must be hosted on a publicly accessible URL.

**File**: `privacy_policy.html` (created below)

### 4.3 Prepare application screenshots

**Requirements**:
- Dimensions: 1280 x 800 pixels (macOS)
- Quantity: at least 1, at most 10
- Format: PNG or JPEG
- Content: Show the main functions of the application

**Suggested screenshots**:
1. Main interface - display real-time translation
2. Image recognition - show the function of pasting images
3. Multi-language - display language switching
4. Translation results - display translation results
5. Featured Functions - Showcase Core Highlights

### 4.4 Prepare to preview video (optional)

- Duration: 15-30 seconds
- Format: MP4 or MOV
- Content: Show application usage process

---

## 5. Submit for review

### 5.1 App Store Connect Configuration

1. **Login**: https://appstoreconnect.apple.com/
2. **Create new App**:
   - Click "My App" → "+" → "New App"
   - Platform: macOS
   - Name: CDTranslator
   - Language: Simplified Chinese
   - Bundle ID: com.cd.translator
   - SKU: cdtranslator001

3. **Fill in application information**:
   - Application description (see above)
   - Keywords (see above)
   - Support URL: your website or GitHub
   - Privacy Policy URL: Your privacy policy URL

4. **Upload screenshot**:
   - Drag in the 5 prepared screenshots

5. **Pricing and Sales Scope**:
   - Price: Free
   - Sales Scope: All Countries/Regions

### 5.2 Upload using Xcode

1. **Open project**
   ```bash
   open /path/to/CDTranslator/CDTranslator.xcodeproj
   ```

2. **Configuration Signature**
   - Product → Scheme → Edit Scheme
   - Select Release configuration
   - Signing & Capabilities
   - Choose your development team

3. **Archiving Application**
   - Product → Archive
   - Waiting for archiving to complete

4. **Upload to App Store**
   - Window → Organizer
   - Select the archive just now
   - Click "Distribute App"
   - Select "App Store Connect"
   - Select "Upload"
   - Waiting for upload to complete

### 5.3 Submit for review

1. In App Store Connect
2. Select build version
3. Fill in "What's new in this version"
4. Click "Submit for review"

---

## 6. Review precautions

### 6.1 Common reasons for rejection and solutions

#### ❌ Reason for rejection 1: Lack of privacy policy
**Solution**:
- Add privacy policy URL in App Store Connect
- Make sure the URL is accessible

#### ❌ Reason for rejection 2: Incomplete functions
**Solution**:
- Make sure all functions are working properly
- Provide test account (if needed)

#### ❌ Reason for rejection 3: Metadata issues
**Solution**:
- Ensure that screenshots truly reflect application functionality
- Accurate description, no exaggeration

#### ❌Reason for rejection 4: Use of third-party API
**Solution**:
- Indicate use of Google Translate API in review instructions
- Emphasis on user privacy protection

### 6.2 Review description text

Fill in the "Audit Instructions":

```
Application instructions:

1. CDTranslatoris a free translation tool, use Google Translate API Provides translation services.

2. Use of image recognition function Apple Vision Framework, completely completed locally, no images will be uploaded.

3. Translated text will be sent to Google The server does the translation, but the app itself doesn't store any user data.

4. The application is completely free, no ads, no in-app purchases, no registration required.

5. Test instructions:
   - Open application
   - Enter any English on the left and the Chinese translation will automatically be displayed on the right
   - After taking a screenshot, press Cmd+V，The application will recognize the text in the picture and translate it

If you have any questions, please contact:your.email@example.com
```

### 6.3 review time

- **Initial Review**: Usually takes 2-5 working days
- **Update Review**: Usually takes 1-3 working days
- **Expedited review**: You can apply for expedited review (sufficient reasons are required)

---

## 7. Post-release maintenance

### 7.1 version update

When updates are needed:
1. Modify code
2. Update version number
3. Re-archive and upload
4. Fill in "What's new in this version"
5. Submit for review

### 7.2 User feedback

- Respond to user comments promptly
- Collect user feedback to improve the application
- Regularly releases updated versions

---

## 8. Quick Checklist

Check before putting on shelves:

- [ ] Developer account has been activated
- [ ] App ID has been created
- [ ] Privacy policy has been uploaded
- [ ] Support webpage is ready
- [ ] Application screenshots are prepared (5 pictures)
- [ ] Application description has been written
- [ ] Keywords have been optimized
- [ ] Pricing Set (Free)
- [ ] Code signing configured
- [ ] Application archived
- [ ] The build version has been uploaded
- [ ] Review instructions have been filled in
- [ ] Final check is correct

---

## 9. Related links

- Apple Developer: https://developer.apple.com/
- App Store Connect: https://appstoreconnect.apple.com/
- Review Guide: https://developer.apple.com/app-store/review/guidelines/
- Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/

---

## 10. Frequently Asked Questions

**Q: How long does the review take? **
A: Usually 2-5 working days, may be faster or slower.

**Q: What should I do if I am rejected? **
A: Check the reason for rejection, modify it and resubmit. You can also appeal.

**Q: Can the price be modified? **
A: It can be modified at any time. If you change it from free to paid, you need to create a new version.

**Q: Do I need to provide a privacy policy? **
A: Yes, a publicly accessible privacy policy URL must be provided.

**Q: Can the application name be modified? **
A: Yes, but each modification needs to be reviewed again.

---

## 📞Need help?

If you encounter problems during the listing process:

1. Check out Apple’s official documentation
2. Ask a question in the Apple Developer Forum
3. Contact Apple Developer Support

---

**Wish you a smooth launch! 🎉**
