# CDTranslator user guide

CDTranslator is a macOS window app for text translation and OCR. The current build
requires Apple silicon and macOS 13 or later. See [README.md](README.md) for build
instructions and validation limits.

## Translate text

Enter or paste text into the source field. The app requests a translation after
a short typing delay. Use the Copy button to copy the result.

The main path chooses the direction from the input: mostly Chinese text to
English, Latin-letter text to Simplified Chinese, and other input through language
detection, generally to Chinese. These heuristics can misclassify languages. The
13-item language menus do not currently control this main path; do not rely on
them for arbitrary source/target pairs.

## Translate text in an image

Copy an image to the clipboard, then press Cmd+V in the app. For a macOS screenshot
directly to the clipboard, use Control+Shift+Command+4 and select an area.

Apple Vision recognizes the image on your Mac. The recognized text then goes to
Google for translation. The image itself is not uploaded by this path. Merely
copying an image does not trigger OCR; background clipboard monitoring is not
part of the current build.

## Data and limitations

Text translation requires internet access and sends the input text to Google,
including text recognized from a screenshot. Avoid entering information you do
not want to send to that service. The endpoint is undocumented and may stop working.

The current source has no translation-history feature or app-specific analytics.
That does not guarantee the absence of operating-system caches or provider-side
retention. The current build does not enable App Sandbox. Read the
[privacy policy](https://dhtfish988.github.io/CDTranslator/) for the data flow.

OCR accuracy and translation quality vary. A successful compile is not a recorded
UI or service test; see the README for what has actually been checked.
