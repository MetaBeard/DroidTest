//
//  DroidWheel.swift
//
//  Patched for the littleBits Droid Inventor Kit / w32 ControlHub.
//  The original package used linear 0...255 motor values. The Droid uses
//  calibrated values captured from the original control protocol instead.
//

import Foundation

// MARK: - Wheel Type
public enum DroidWheel: UInt8 {
    case turn = 1
    case move = 2

    // Real neutral values used by the littleBits Droid control hub.
    static let moveStopValue: UInt8 = 0x89
    static let turnCenterValue: UInt8 = 0x96
}

// MARK: - Action Protocol
protocol DroidWheelAction {
    var value: UInt8 { get }
}

// MARK: - Movement Action Type
public enum DroidWheelMovementAction: DroidWheelAction {
    case go(speed: Double)
    case back(speed: Double)
    case end

    // Captured drive values from full-forward -> neutral -> full-reverse.
    // Index 31 is the Droid's real neutral/stop position (0x89).
    private static let calibratedDriveValues: [UInt8] = [
        0xFF, 0xFA, 0xF6, 0xF2, 0xED, 0xEA, 0xE6, 0xE3,
        0xDF, 0xDA, 0xD6, 0xD2, 0xCE, 0xCA, 0xC5, 0xC2,
        0xBE, 0xBA, 0xB6, 0xB2, 0xAB, 0xAA, 0xA6, 0xA2,
        0xA1, 0x9E, 0x99, 0x96, 0x92, 0x8D, 0x8A, 0x89,
        0x7D, 0x79, 0x76, 0x72, 0x6E, 0x6D, 0x68, 0x63,
        0x61, 0x5C, 0x59, 0x55, 0x50, 0x4B, 0x49, 0x45,
        0x41, 0x3B, 0x39, 0x33, 0x30, 0x2B, 0x29, 0x21,
        0x20, 0x1B, 0x18, 0x14, 0x0F, 0x0C, 0x07
    ]

    private static let neutralIndex = 31

    public var value: UInt8 {
        switch self {
        case .go(let speed):
            let s = Self.clamp(speed)
            guard s > 0 else { return DroidWheel.moveStopValue }
            let steps = Self.neutralIndex
            let offset = Int(round(s * Double(steps)))
            let index = max(0, Self.neutralIndex - offset)
            return Self.calibratedDriveValues[index]

        case .back(let speed):
            let s = Self.clamp(speed)
            guard s > 0 else { return DroidWheel.moveStopValue }
            let maxReverseIndex = Self.calibratedDriveValues.count - 1
            let steps = maxReverseIndex - Self.neutralIndex
            let offset = Int(round(s * Double(steps)))
            let index = min(maxReverseIndex, Self.neutralIndex + offset)
            return Self.calibratedDriveValues[index]

        case .end:
            return DroidWheel.moveStopValue
        }
    }

    private static func clamp(_ value: Double) -> Double {
        min(max(value, 0), 1)
    }
}

// MARK: - Turn Action Type
public enum DroidWheelTurnAction: DroidWheelAction {
    case turn(degree: Double)
    case end

    // Captured steering values from full-left -> center -> full-right.
    // The original protocol's straight-ahead value is 0x96.
    private static let calibratedTurnValues: [UInt8] = [
        0xFC, 0xEA, 0xE4, 0xDF, 0xD9, 0xD1, 0xCC, 0xC6,
        0xC0, 0xB9, 0xB4, 0xAE, 0xA7, 0xA2, 0x9C, 0x96,
        0x90, 0x8A, 0x84, 0x7E, 0x78, 0x72, 0x6C, 0x66,
        0x60, 0x5A, 0x54, 0x4F, 0x49, 0x42, 0x3C, 0x35,
        0x00
    ]

    private static let centerIndex = 15

    public var value: UInt8 {
        switch self {
        case .turn(let degree):
            let d = min(max(degree, 0), 180)

            // Preserve DroidKit's public convention:
            // 0° = right, 90° = straight, 180° = left.
            let index: Int
            if d <= 90 {
                let rightIndex = Self.calibratedTurnValues.count - 1
                let fraction = d / 90.0
                index = Int(round(Double(rightIndex) + fraction * Double(Self.centerIndex - rightIndex)))
            } else {
                let fraction = (d - 90.0) / 90.0
                index = Int(round(Double(Self.centerIndex) * (1.0 - fraction)))
            }
            return Self.calibratedTurnValues[min(max(index, 0), Self.calibratedTurnValues.count - 1)]

        case .end:
            return DroidWheel.turnCenterValue
        }
    }
}
