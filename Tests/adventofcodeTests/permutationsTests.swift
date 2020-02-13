
import XCTest
@testable import adventofcodeLibrary

final class permutationsTests: XCTestCase {

    typealias TestCase = (
        testName:String,
        length: Int,
        output: [[Int]]
    )

    func RunTests(_ tests : [TestCase]) {
        for (testName, length, expectedOutput) in tests {
            print("-----")
            let output = Permutations().OfLength(length)
            XCTAssertEqual(
                output,
                expectedOutput,
                "Failed for testcase '\(testName)'")
        }
    }

    func testOfLength() throws {
        RunTests([
            ("Length 1",
             length: 1,
             output: [
                [0],
            ]),
            ("Length 2",
             length: 2,
             output: [
                [0, 1],
                [1, 0],
            ]),
            ("Length 3",
             length: 3,
             output: [
                [0, 1, 2],
                [0, 2, 1],
                [1, 0, 2],
                [1, 2, 0],
                [2, 0, 1],
                [2, 1, 0],
            ]),
        ])
    }

    func testOf() throws {
        let expected = [
            [1, 3, 6], [1, 6, 3],
            [3, 1, 6], [3, 6, 1],
            [6, 1, 3], [6, 3, 1],
        ]
        let actual = Permutations().Of([1, 3, 6])

        XCTAssertEqual(expected, actual)
    }

    static var allTests = [
        ("testOfLength", testOfLength),
        ("testOf", testOf),
    ]
}

