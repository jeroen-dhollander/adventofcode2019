
import XCTest
@testable import adventofcodeLibrary

final class mathTests: XCTestCase {

    func testGreatestCommonDenominator() throws {
        let testcases = [
            (3, 3, 3),
            (6, 3, 3),
            (3, 6, 3),
            (3, 2, 1),
            (2, 3, 1),
            (123123*5, 123123*7, 123123),
            (0, 0, 1),
        ]

        for (left, right, expected) in testcases {
            let actual = GreatestCommonDenominator(left, right)
            XCTAssertEqual(expected, actual, "Error for GCD(\(left), \(right))")
        }
    }

    func testAngleIsNormalized() throws {
        let angle = Angle(10, 15)

        XCTAssertEqual(angle.numerator, 2)
        XCTAssertEqual(angle.denominator, 3)
        XCTAssertEqual(angle, Angle(2,3))
    }

    func testAngleBetweenPoints() throws {
        let testcases = ([
            (Point(0, 0),
             Point(1, 1),
             Angle(1, 1)),
            (Point(1, 1),
             Point(0, 0),
             Angle(-1, -1)),
            (Point(1, 1),
             Point(3, -4),
             Angle(2, -5)),
        ])

        for (left, right, expectedAngle) in testcases {
            let actual = Angle.Between(left, right)
            XCTAssertEqual(actual, expectedAngle, "Error for angle between \(left) and \(right)")
        }
    }

    static var allTests = [
        ("testGreatestCommonDenominator", testGreatestCommonDenominator),
        ("testAngleIsNormalized", testAngleIsNormalized),
        ("testAngleBetweenPoints", testAngleBetweenPoints),
    ]
}
