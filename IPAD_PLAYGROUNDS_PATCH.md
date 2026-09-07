# DroidKit iPad / modern Swift patch v2

This fork contains two compatibility fixes for the littleBits Droid Inventor Kit:

1. Adds a fallback case to the debug view's Bluetooth event switch for newer AsyncBluetooth/Swift versions.
2. Replaces the original linear motor/steering calculations with the calibrated w32 ControlHub values captured from the original Droid protocol.

Key neutral values:
- Drive stop: `0x89`
- Steering center: `0x96`

The public API remains unchanged (`go(at:)`, `back(at:)`, `stop()`, `turn(by:)`, `endTurn()`).
