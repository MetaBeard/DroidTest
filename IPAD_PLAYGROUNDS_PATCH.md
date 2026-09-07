# DroidKit – iPad Swift Playgrounds compatibility patch

This copy contains a small compatibility fix for newer Swift / Swift Playgrounds versions.

## What changed

`Sources/DroidKit/View/Debug/DroidKitDebugView.swift`

The event handler for AsyncBluetooth used a switch that only covered the event cases available when DroidKit was originally written. Newer AsyncBluetooth versions expose additional events, causing modern Swift to report:

`Switch must be exhaustive`

A `default` case was added to the debug-only event logger. Unknown/new events are ignored. This does not change movement, LED, sound, or connection commands.

## Import name

The module is still imported normally:

```swift
import DroidKit
```

A minimal SwiftUI view is:

```swift
import SwiftUI
import DroidKit

struct ContentView: View {
    var body: some View {
        DroidKitDebugView()
    }
}
```

## iPad note

Swift Playgrounds treats remote Swift Packages as read-only. Put this patched package in a GitHub repository you control, then add that repository URL as the package dependency in your App Playground.

Bluetooth permission is controlled by the host app / Swift Playgrounds environment, not by this library. If a Bluetooth permission or capability error appears after compilation, that is the next issue to address.
