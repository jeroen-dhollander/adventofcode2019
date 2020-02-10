
import XCTest
@testable import adventofcodeLibrary

final class cpuTests: XCTestCase {
    func testRun() throws {
        let testCases : [(testName:String, memory:[Int], output: [Int]?)] = [
            ("99 means stop", 
             memory: [99],
             output: [99]),
            ("Ignore values after 99", 
             memory: [99, 666],
             output: [99, 666]),
            ("Returns nil on invalid opcode", 
             memory: [42],
             output: nil),
            ("1 means addition", 
             memory: [1, 5, 6, 7, 99, 11, 22, 0],
             output: [1, 5, 6, 7, 99, 11, 22, 33]),
            ("2 means multiplication", 
             memory: [2, 5, 6, 7, 99, 10, 20, 0],
             output: [2, 5, 6, 7, 99, 10, 20, 200]),
            ("1 supports parameter mode for value 1",
             memory: [101, 11, 5, 6, 99, 22, 0],
             output: [101, 11, 5, 6, 99, 22, 33]),
            ("1 supports parameter mode for value 2",
             memory: [1001, 5, 11, 6, 99, 22, 0],
             output: [1001, 5, 11, 6, 99, 22, 33]),
            ("2 supports parameter mode for value 1", 
             memory: [102, 10, 5, 6, 99, 20, 0],
             output: [102, 10, 5, 6, 99, 20, 200]),
            ("2 supports parameter mode for value 2", 
             memory: [1002, 5, 10, 6, 99, 20, 0],
             output: [1002, 5, 10, 6, 99, 20, 200]),
            ("error if not enough arguments for addition", 
             memory: [1, 11, 22],
             output: nil),
            ("error if invalid destination for addition", 
             memory: [1, 0, 0, 1000],
             output: nil),
            ("error if invalid value1 for addition", 
             memory: [1, 1000, 0, 0],
             output: nil),
            ("error if invalid value2 for addition", 
             memory: [1, 0, 1000, 0],
             output: nil),
            ("error if not enough arguments for multiplication", 
             memory: [2, 11, 22],
             output: nil),
            ("error if invalid destination for multiplication", 
             memory: [2, 0, 0, 1000],
             output: nil),
            ("error if invalid value1 for multiplication", 
             memory: [2, 1000, 0, 0],
             output: nil),
            ("error if invalid value2 for multiplication", 
             memory: [2, 0, 1000, 0],
             output: nil),
            ("error if no stop code", 
             memory: [2, 0, 0, 0],
             output: nil),
            ("can chain multiple operations", 
             memory: [1, 9, 10, 11, 2, 12, 13, 14, 99, 11, 22, 0,  10, 20, 0],
             output: [1, 9, 10, 11, 2, 12, 13, 14, 99, 11, 22, 33, 10, 20, 200]),
            ("complex example from webpage",
             memory: [1,    9, 10, 3,  2, 3, 11, 0, 99, 30, 40, 50],
             output: [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50])
        ]

        for (testName, memory, expectedOutput) in testCases {
            print("-----")
            let cpu = Cpu(memory)
            let output = cpu.Run()
            XCTAssertEqual(
                output,
                expectedOutput,
                "Failed for testcase '\(testName)'")
        }
    }

    func testRunWithInput() throws {
        let testCases : [(
            testName: String,
            memory: [Int],
            input: Input,
            output: [Int]?)] 
            = [
                ("4 means write to output",
                 memory: [4, 3, 99, 666],
                 input:  Input([]),
                 output: [666]),
                ("3 means read from input",
                 // This program will read an input value and store it 
                 // in the spot of the "-1" so it is written to the output.
                 memory: [3, 0, 4, 0, 99],
                 input:  Input([999]),
                 output: [999]),
                ("4 supports parameter mode",
                 memory: [104, 666, 99],
                 input:  Input([]),
                 output: [666])
        ]

        for (testName, memory, input, expectedOutput) in testCases {
            print("-----")
            let cpu = Cpu(memory)
            let output = cpu.Run(input:input)

            XCTAssertEqual(
                output.map{ $0.Get() }, 
                expectedOutput,
                "Failed for testcase '\(testName)' with input \(input)")
        }
    }

    static var allTests = [
        ("testRun", testRun),
        ("testRunWithInput", testRunWithInput),
    ]
}
