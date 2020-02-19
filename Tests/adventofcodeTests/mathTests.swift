
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

        XCTAssertEqual(angle.dx, 2)
        XCTAssertEqual(angle.dy, 3)
        XCTAssertEqual(angle, Angle(2,3))
    }

    func testAngleBetweenPoints() throws {
        let testcases = ([
            (Point(0, 0),
             Point(1, 1),
             // One to the right (dx = 1),
             // One down (dy = -1)
             Angle(1, -1)),
            (Point(1, 1),
             Point(0, 0),
             // One to the left (dx = -1)
             // One up (dy = 1)
             Angle(-1, 1)),
            (Point(1, 1),
             Point(3, -4),
             Angle(2, 5)),
        ])

        for (left, right, expectedAngle) in testcases {
            let actual = Angle.Between(left, right)
            XCTAssertEqual(actual, expectedAngle, "Error for angle between \(left) and \(right)")
        }
    }

    func testAngleToDegrees() throws {
        let testcases = ([
            // 0 - 90
            (Angle(0, 1),    0),
            (Angle(13, 20),  33),
            (Angle(1, 1),    45),
            (Angle(45, 20),  66),
            (Angle(1, 0),    90),

            // 90 - 180
            (Angle(20, -13), 90 + 33),
            (Angle(1, -1),   90 + 45),
            (Angle(20, -45), 90 + 66),
            (Angle(0, -1),   180),

            // 180 - 270
            (Angle(-13, -20), 180 + 33),
            (Angle(-1, -1),   180 + 45),
            (Angle(-45, -20), 180 + 66),
            (Angle(-1, 0),    270),

            // 270 - 360
            (Angle(-20, 13), 270 + 33),
            (Angle(-1, 1),   270 + 45),
            (Angle(-20, 45), 270 + 66),
            (Angle(-0, 1),   0),
        ])

        for (angle, expected) in testcases {
            XCTAssertEqual(Int(angle.ToDegrees()), expected, "failure for angle \(angle)")
        }
    }

    static var allTests = [
        ("testGreatestCommonDenominator", testGreatestCommonDenominator),
        ("testAngleIsNormalized", testAngleIsNormalized),
        ("testAngleBetweenPoints", testAngleBetweenPoints),
        ("testAngleToDegrees", testAngleToDegrees),
    ]
}
