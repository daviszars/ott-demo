# OTT Video Streaming Demo

A SwiftUI-based video streaming demo app.


https://github.com/user-attachments/assets/a4342971-7db3-4531-b6f6-b81dccfd4707


## Requirements

- **Xcode**: 15.0 or later
- **iOS**: 15.0 or later
- **Swift**: 5.9 or later

## How to Run

1. Clone the repository
2. Open `ott_demo.xcodeproj` in Xcode
3. Select an iOS Simulator
4. Press `Cmd+R` to build and run
5. Press `Cmd+U` to run all tests


The app will launch with a catalog of video content loaded from the bundled JSON file.

## Architecture

### SwiftUI + MVVM
- **SwiftUI**: Chosen for modern declarative UI, better animation support, and cleaner code compared to UIKit
- **MVVM Pattern**: Clean separation between Views (UI) and ViewModels (business logic), making the code testable and maintainable

## Known Limitations & TODOs

- **Static Catalog**: Videos are loaded from a bundled JSON file only
- **No Offline Catalog Caching**: Catalog isn't persisted between app launches

## Features

- Video catalog browsing with grid/list toggle
- Catalog item search and filtering
- Video playback with native controls
- Swipe-to-dismiss player
- Accessibility support
- Image caching and loading states
- Pull-to-refresh functionality
