
import XCTest
@testable import adventofcodeLibrary

final class cpuTests: XCTestCase {
    typealias TestCase = (
        testName:String,
        memory:[Int],
        output: [Int]?
    )
    typealias InputTestCase = (
        testName:String,
        memory:[Int],
        input: Input,
        output: [Int]?
    )

    func RunTests(_ tests : [TestCase]) {
        for (testName, memory, expectedOutput) in tests {
            print("-----")
            let cpu = Cpu(memory)
            let output = cpu.Run()
            XCTAssertEqual(
                output,
                expectedOutput,
                "Failed for testcase '\(testName)'")
        }
    }

    func RunInputTests(_ tests : [InputTestCase]) {
        for (testName, memory, input_values, expectedOutput) in tests {
            print("-----")
            let cpu = Cpu(memory)
            var input : Input = input_values
            var output : Output = []
            if cpu.Run(input:&input, output:&output) {
                XCTAssertEqual(
                    output as? [Int], 
                    expectedOutput,
                    "Failed for testcase '\(testName)' with input \(input)")
            }else {
                XCTAssertEqual(nil, expectedOutput,
                               "Unexpected failure in testcase '\(testName)'")
            }

        }
    }


    func testBasicOperations() throws {
        RunTests([
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
             output: [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]),
        ])
    }

    func testJumps() throws {
        RunTests([
            ("jump-if-true jumps if parameter is non zero",
             // This will crash if we do not take the jump
             memory: [1105, 1, 4, -66, 99],
             output: [1105, 1, 4, -66, 99]),
            ("jump-if-true does not jump if parameter is zero",
             // This will crash if take the jump
             memory: [1105, 0, 4, 99, -66],
             output: [1105, 0, 4, 99, -66]),
            ("jump-if-true supports parameter mode for condition",
             // This will crash if we take the jump
             memory: [1005, 5, 4, 99, -66, 0],
             output: [1005, 5, 4, 99, -66, 0]),
            ("jump-if-true supports parameter mode for destination",
             // This will crash if we do not take the jump
             memory: [0105, 1, 5, -66, 99, 4],
             output: [0105, 1, 5, -66, 99, 4]),
            ("jump-if-false jumps if parameter is zero",
             // This will crash if we do not take the jump
             memory: [1106, 0, 4, -66, 99],
             output: [1106, 0, 4, -66, 99]),
            ("jump-if-false does not jump if parameter is not zero",
             // This will crash if take the jump
             memory: [1106, 1, 4, 99, -66],
             output: [1106, 1, 4, 99, -66]),
            ("jump-if-false supports parameter mode for condition",
             // This will crash if we take the jump
             memory: [1006, 5, 4, 99, -66, 1],
             output: [1006, 5, 4, 99, -66, 1]),
            ("jump-if-false supports parameter mode for destination",
             // This will crash if we do not take the jump
             memory: [0106, 0, 5, -66, 99, 4],
             output: [0106, 0, 5, -66, 99, 4]),
            ("less-than stores one if value1 < value2",
             memory: [1107, 11, 22, 5, 99, -1],
             output: [1107, 11, 22, 5, 99, 1]),
            ("less-than stores zero if value1 == value2",
             memory: [1107, 11, 11, 5, 99, -1],
             output: [1107, 11, 11, 5, 99, 0]),
            ("less-than stores zero if value1 > value2",
             memory: [1107, 22, 11, 5, 99, -1],
             output: [1107, 22, 11, 5, 99, 0]),
            ("equals stores one if value1 == value2",
             memory: [1108, 11, 11, 5, 99, -1],
             output: [1108, 11, 11, 5, 99, 1]),
            ("equals stores zero if value1 < value2",
             memory: [1108, 11, 22, 5, 99, -1],
             output: [1108, 11, 22, 5, 99, 0]),
            ("equals stores zero if value1 > value2",
             memory: [1108, 22, 11, 5, 99, -1],
             output: [1108, 22, 11, 5, 99, 0]),
        ])

        RunInputTests([
            ("First example from the webpage",
             // Outputs '1' if input is 8, '0' otherwise
             memory: [3,9,8,9,10,9,4,9,99,-1,8],
             input: [8],
             output: [1]),
            ("First example from the webpage (2)",
             // Outputs '1' if input is 8, '0' otherwise
             memory: [3,9,8,9,10,9,4,9,99,-1,8],
             input: [7],
             output: [0]),
            ("Second example from the webpage",
             // Outputs '1' if input is less than 8, '0' otherwise
             memory: [3,9,7,9,10,9,4,9,99,-1,8],
             input: [7],
             output: [1]),
            ("Second example from the webpage (2)",
             // Outputs '1' if input is less than 8, '0' otherwise
             memory: [3,9,7,9,10,9,4,9,99,-1,8],
             input: [8],
             output: [0]),
        ])
    }

    func testRelativeMode() throws {
        RunInputTests([
            ("Relative mode starts at zero",
             memory: [204, +3, 99, 111],
             input: [],
             output: [111]
            ),
            ("Opcode 9 changes relative base",
             memory: [204, +11, 109, 10, 204, +1, 109, 10, 204, -9, 99, 111],
             input: [],
             output: [111, 111, 111]
            ),
            ("Opcode 9 supports parameter mode",
             //  set relative_base to '9', then read from 9-7
             memory: [9, 0, 204, -7, 99],
             input: [],
             output: [204]
            ),
            ("Example from webpage day 9",
             memory: [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99],
             input: [],
             output: [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
            ),
            ("destination arguments support relative mode",
             memory: [
                // Set relative_base, 
                109, 10,           
                // read input (111) and store it
                203, +10, 
                // add 222 
                22101, 222, +10, +10,
                // multiply by 2 ,
                22102, 2, +10, +10,
                // print it
                204, +10,
                99],
             input:  [111],
             output: [666]
            )
        ])
    }

    func testInputOutput() throws {
        RunInputTests([
            ("4 means write to output",
             memory: [4, 3, 99, 666],
             input:  [],
             output: [666]),
            ("3 means read from input",
             // This program will read an input value and write it to the output
             memory: [3, 0, 4, 0, 99],
             input:  [999],
             output: [999]),
            ("Can read multiple inputs",
             // This program will read 2 input values and write the second one
             // to the output
             memory: [3, 0, 3, 1, 4, 1, 99],
             input:  [111, 222],
             output: [222]),
            ("4 supports parameter mode",
             memory: [104, 666, 99],
             input:  [],
             output: [666]
            ),
            ("Supports large numbers",
             memory: [104,1125899906842624,99],
             input: [],
             output: [1125899906842624]
            ),
            ("Supports large numbers 2",
             memory: [1102,34915192,34915192,7,4,7,99,0],
             input: [],
             output: [1219070632396864]
            ),
        ])
    }

    func testMemorySpace() throws {
        RunInputTests([
            ("Reading from big addresses returns zero",
             memory: [4, 100, 99],
             input: [],
             output: [0]
            ),
            ("Can write to big addresses",
             memory: [1101, 11, 22, 100, 4, 100, 99],
             input: [],
             output: [33]
            ),
        ])
    }

    static var allTests = [
        ("testBasicOperations", testBasicOperations),
        ("testJumps", testJumps),
        ("testRelativeMode", testRelativeMode),
        ("testInputOutput", testInputOutput),
        ("testMemorySpace", testMemorySpace),
    ]
}
