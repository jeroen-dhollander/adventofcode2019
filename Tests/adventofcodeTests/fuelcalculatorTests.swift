import XCTest
@testable import adventofcodeLibrary

final class fuelcalculatorTests: XCTestCase {
    var calculator : FuelCalculator!

    override func setUp() {
        super.setUp()
        calculator = FuelCalculator()
    }

    func testCalculate() throws {
        let testCases : [(mass:Int, fuel:Int)] = [
            (mass:4, fuel:0),
            (mass:9, fuel:1),
            (mass:12, fuel:2),
            (mass:14, fuel:2),
            (mass:33, fuel:10),
            (mass:1969, fuel:966),
        ]

        for (mass, expectedFuel) in testCases {
            XCTAssertEqual(
                calculator.calculate(mass),
                expectedFuel,
                "Failed for mass \(mass)")
        }
    }

    func testCalculateCombined() throws {
        let masses = [ 12, 14, 1969]
        let expectedFuel = 970

        XCTAssertEqual(
            calculator.calculateCombined(masses),
            expectedFuel)
    }

    static var allTests = [
        ("testCalculate", testCalculate),
        ("testCalculateCombined", testCalculateCombined),
    ]
}
