## SoundClassify

SoundClassify is a simple iOS app that performs **real‑time on‑device sound classification** using Apple’s `SoundAnalysis` framework.  
It listens from the microphone, classifies incoming audio, and shows a list of detected sounds with their confidence scores.

### Features

- **Live sound detection**: Uses `AVAudioEngine` + `SNAudioStreamAnalyzer` to classify audio in real time.
- **Start / Stop control**: Single button to start or stop detection from the home screen.
- **Permission handling**: Requests microphone access and shows a dedicated **No Permission** view when access is denied.
- **History list**: Displays a scrollable list of classified sounds (identifier + confidence).
- **Settings screen**: Links for terms of service and privacy policy.

### Requirements

- **Xcode**: 16 (or newer should also work)
- **Platform**: iOS 17+ (adjust as needed in the Xcode project settings)
- **Language**: Swift, SwiftUI

### Getting Started

1. **Clone the repository**

   ```bash
   git clone git@github.com:blackknight101/SoundClassify.git
   cd SoundClassify
   ```

2. **Open in Xcode**

   - Open `SoundClassify.xcodeproj` in Xcode.

3. **Select the scheme & device**

   - Choose the `SoundClassify` app scheme.
   - Select an iOS device or simulator (physical device recommended for real microphone input).

4. **Build & Run**

   - Press **Cmd + R** to build and run the app.
   - On first launch, approve the **Microphone** permission prompt.

### How It Works

- The app entry point is `SoundClassifyApp` (`SnoreDetectApp.swift`), which launches a tab bar with the `HomeView`.
- `HomeViewModel`:
  - Manages the main **state machine**: `.none`, `.ready`, `.noPermission`, `.error(String)`, `.detecting`.
  - Requests microphone permission using `AVAudioSession.recordPermission`.
  - Starts / stops a background `Task` that drives audio analysis through `AudioAnalyzer`.
- `AudioAnalyzer` (in `AudioAnalysis.swift`):
  - Wraps `AVAudioEngine` and `SNAudioStreamAnalyzer`.
  - Creates an `AsyncStream<AudioAnalysisEvent>` so the view model can asynchronously consume classification events.
  - Uses `SNClassifySoundRequest(classifierIdentifier: .version1)` and only emits events above a configurable `minConfidence` (default: `0.6`).
- `SoundClassify` model:
  - Simple value type representing a single classification result: `id`, `name` (identifier), and `confidence`.
- `HomeView`:
  - Shows one of several UI states (loading, list, empty, no permission, error).
  - Renders detected sounds using `SoundClassifyView`.
  - Provides a bottom **Start / Stop** button when the analyzer is ready or currently detecting.

### Project Structure

- `App/`
  - `SnoreDetectApp.swift` – App entry point (`SoundClassifyApp`), sets up the root `TabbarView`.
- `Features/`
  - `Home/`
    - `HomeView.swift` – Main screen with detection controls and list.
    - `HomeViewModel.swift` – Business logic, permission handling, and connection to `AudioAnalyzer`.
    - `Views/`
      - `EmptyStateView.swift` – UI when no sounds have been detected yet.
      - `NoPermissionView.swift` – UI when microphone access is denied.
      - `SoundClassifyView.swift` – Row view showing a single sound classification.
  - `Setting/`
    - `SettingsView.swift` – Static settings screen with Terms / Policy links.
  - `Tabbar/`
    - `TabbarView.swift` – Tab bar container for `HomeView` and `SettingsView`.
- `Models/`
  - `SoundClassify.swift` – Data model for a classification item.
- `Services/`
  - `AudioAnalysis.swift` – `AudioAnalyzer` implementation using `AVAudioEngine` and `SoundAnalysis`.
- `Extensions/`
  - `CGFloat+Ext.swift` – Layout spacing helpers (e.g. `.space8`, `.space12`).
- `Modifiers/`
  - `ViewApply.swift` – Shared view modifiers / styling helpers.
- `Resources/`
  - `AppIcons.xcassets` – App icon set.
  - `Assets.xcassets`, `Colors.xcassets` – Color and asset catalog (e.g. `backgroundPrimay`, `textPrimary`).

### Usage

1. Launch the app on a device (recommended) or simulator.
2. Grant microphone access when prompted.
3. On the **Home** tab:
   - Tap **Start** to begin detecting sounds.
   - Classified sounds will appear in a list, newest at the top, with a confidence score.
   - Tap **Stop** to stop detection.
4. On the **Settings** tab:
   - Open **Terms** or **Policy** links in Safari.

### Privacy & Permissions

- The app uses the **microphone** solely for **on‑device sound classification**.
- No audio is uploaded or stored remotely by default; it is processed in real time via `SoundAnalysis` and discarded.
- Make sure your own Terms / Privacy Policy URLs in `SettingsView` are updated before shipping to users.

### Customization Ideas

- Adjust `minConfidence` in `AudioAnalyzer` to tune sensitivity.
- Filter or group specific sound classes (e.g., snoring, speech, environment).
- Persist detection history locally (e.g., with Core Data or SwiftData).
- Add charts or visualizations for confidence over time.

### License
MIT.


