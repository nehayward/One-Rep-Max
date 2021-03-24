import XCTest
@testable import OneRepMaxCore

final class OneRepMaxCoreTests: XCTestCase {
   
    func testOneRepMax() {
        let oneRepMax = MathManager.shared.oneRepMax(weight: Measurement<UnitMass>(value: 100, unit: .pounds), repetitions: 10)
        let expected = Measurement<UnitMass>(value: 133.3, unit: .pounds)
        
        XCTAssertEqual(oneRepMax.value, expected.value, accuracy: 0.1, "\(#function) failed, expected: \(expected.value), got: \(oneRepMax)")
    }

    static var allTests = [
        ("testOneRepMax", testOneRepMax),
    ]
}
