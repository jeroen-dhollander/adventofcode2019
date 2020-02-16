import XCTest
@testable import adventofcodeLibrary

let kAdd = 1
let kAddConstant = 1001
let kRead = 3
let kOutputConstant = 104
let kOutput = 4
let kStop = 99

final class amplifierTests: XCTestCase {
    typealias TestCase = (
        testName:String,
        memory:[[Int]],
        input: [[Int]],
        output: Int
    )

    func RunTests(_ tests : [TestCase]) {
        for (testName, memory, input, expectedOutput) in tests {
            print("-----")
            print("Starting test '\(testName)'")
            let amplifier = Amplifier(memory)
            let output = amplifier.Run(inputs:input)
            XCTAssertEqual(
                output,
                expectedOutput,
                "Failed for testcase '\(testName)'")
        }
    }

    func test() throws {
        RunTests([
            ("Returns output", 
             memory: [
                [kOutputConstant, 123, kStop],
                ],
             input: [],
             output: 123),
            ("Output is forwarded to the next CPU", 
             memory: [
                [kOutputConstant, 111, kStop],
                // read value from input, add 222 to it and print it
                [kRead, 0, kAddConstant, 0, 222, 0, kOutput, 0, kStop],
                ],
             input: [],
             output: 333),
            ("Output of last CPU is fed to the first CPU", 
             memory: [
                // read value from input, add 222 to it and print it
                [kRead, 0, kAddConstant, 0, 222, 0, kOutput, 0, kStop],
                // prints a value and then prints the value it reads from the
                // input
                [kOutputConstant, 111, kRead, 0, kOutput, 0, kStop],
                ],
             input: [],
             output: 333),
            ("Initial input is passed to the CPUs",
             memory: [
                [kRead, 0, kOutput, 0, kStop],
                [kRead, 0, kRead, 1, kAdd, 0, 1, 2, kOutput, 2, kStop],
                ],
             input: [[100], [200]],
             output: 300
            ),
            ("Supports more than 2 CPUs",
             memory: [
                [kOutputConstant, 1, kStop],
                [kRead, 0, kAddConstant, 0, 10, 0, kOutput, 0, kStop],
                [kRead, 0, kAddConstant, 0, 100, 0, kOutput, 0, kStop],
                [kRead, 0, kAddConstant, 0, 1000, 0, kOutput, 0, kStop],
                ],
             input: [],
             output: 1111
            ),
            ("Non looping example from website",
             memory: [
                // Read  Read   Multiply        Add          Print  End
                [3,15,   3,16,  1002,16,10,16,  1,16,15,15,  4,15,  99,0,0],
                [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0],
                [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0],
                [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0],
                [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0],
                ],
             input: [[4,0], [3], [2], [1], [0]],
             output: 43210
            ),
            ("Example from website",
             memory: [
                //Read Add            Read  Multiply       Add         Write
                [3,26, 1001,26,-4,26, 3,27, 1002,27,2,27,  1,27,26,27, 4,27,
                 //Add   20     Jump        End    26
                 1001,28,-1,28, 1005,28,6,  99,    0,0,5],
                [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26, 27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5],
                [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26, 27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5],
                [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26, 27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5],
                [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26, 27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5],
                ],
             input: [[9, 0], [8], [7], [6], [5]],
             output: 139629729
            )
        ])
    }


    static var allTests = [
        ("test", test),
    ]
}
