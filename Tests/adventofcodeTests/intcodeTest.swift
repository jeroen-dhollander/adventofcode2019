
import XCTest
@testable import adventofcodeLibrary

final class intcodeTests: XCTestCase {
    var computer : IntCode!

    override func setUp() {
        super.setUp()
        computer = IntCode()
    }

    func testCompute() throws {
        let testCases : [(testName:String, input:[Int], output:[Int]?)] = [
            ("99 means stop", 
                input: [99],
                output:[99]),
            ("Ignore values after 99", 
                input: [99, 666],
                output:[99, 666]),
            ("Returns nil on invalid opcode", 
                input: [3],
                output:nil),
            ("1 means addition", 
                input: [1, 5, 6, 7, 99, 11, 22, 0],
                output:[1, 5, 6, 7, 99, 11, 22, 33]),
            ("2 means multiplication", 
                input: [2, 5, 6, 7, 99, 10, 20, 0],
                output:[2, 5, 6, 7, 99, 10, 20, 200]),
            ("error if not enough arguments for addition", 
                input: [1, 11, 22],
                output:nil),
            ("error if invalid destination for addition", 
                input: [1, 0, 0, 1000],
                output:nil),
            ("error if invalid value1 for addition", 
                input: [1, 1000, 0, 0],
                output:nil),
            ("error if invalid value2 for addition", 
                input: [1, 0, 1000, 0],
                output:nil),
            ("error if not enough arguments for multiplication", 
                input: [2, 11, 22],
                output:nil),
            ("error if invalid destination for multiplication", 
                input: [2, 0, 0, 1000],
                output:nil),
            ("error if invalid value1 for multiplication", 
                input: [2, 1000, 0, 0],
                output:nil),
            ("error if invalid value2 for multiplication", 
                input: [2, 0, 1000, 0],
                output:nil),
            ("error if no stop code", 
                input: [2, 0, 0, 0],
                output:nil),
            ("can chain multiple operations", 
                input: [1, 9, 10, 11, 2, 12, 13, 14, 99, 11, 22, 0,  10, 20, 0],
                output:[1, 9, 10, 11, 2, 12, 13, 14, 99, 11, 22, 33, 10, 20, 200]),
            ("complex example from webpage",
                input: [1,    9, 10, 3,  2, 3, 11, 0, 99, 30, 40, 50],
                output:[3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50])
        ]

        for (testName, input, expectedOutput) in testCases {
            print("-----")
            let output = computer.compute(input)
            XCTAssertEqual(
                output,
                expectedOutput,
                "Failed for testcase '\(testName)' with input \(input)")
        }
    }

    static var allTests = [
        ("testCompute", testCompute),
    ]
}
