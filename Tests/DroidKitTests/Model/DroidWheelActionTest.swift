import Foundation
import XCTest
@testable import DroidKit

final class DroidWheelActionTest: XCTestCase {
    func testMovementActionValue() {
        XCTAssertEqual(DroidWheelMovementAction.go(speed: -1).value, 0x89)
        XCTAssertEqual(DroidWheelMovementAction.go(speed: 0).value, 0x89)
        XCTAssertEqual(DroidWheelMovementAction.go(speed: 1).value, 0xFF)
        XCTAssertEqual(DroidWheelMovementAction.back(speed: 0).value, 0x89)
        XCTAssertEqual(DroidWheelMovementAction.back(speed: 1).value, 0x07)
        XCTAssertEqual(DroidWheelMovementAction.end.value, 0x89)
    }

    func testTurnActionValue() {
        XCTAssertEqual(DroidWheelTurnAction.turn(degree: 0).value, 0x00)
        XCTAssertEqual(DroidWheelTurnAction.turn(degree: 90).value, 0x96)
        XCTAssertEqual(DroidWheelTurnAction.turn(degree: 180).value, 0xFC)
        XCTAssertEqual(DroidWheelTurnAction.end.value, 0x96)
    }
}
