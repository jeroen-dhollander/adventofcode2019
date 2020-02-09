import XCTest
@testable import adventofcodeLibrary

final class crossingwiresTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testPathBuilder() throws {
        let testCases : [(testName:String, input:[String], output:[Point:Distance]?)] = [
            ("Move right", 
             input: ["R2"],
             output:[
                Point(x:1, y:0):1,
                Point(x:2, y:0):2,
            ]),
            ("Move left", 
             input: ["L1"],
             output:[
                Point(x:-1, y:0):1,
            ]),
            ("Move up", 
             input: ["U3"],
             output:[
                Point(x:0, y:1):1,
                Point(x:0, y:2):2,
                Point(x:0, y:3):3,
            ]),
            ("Move down", 
             input: ["D1"],
             output:[
                Point(x:0, y:-1):1,
            ]),
            ("Invalid direction", 
             input: ["X1"],
             output:nil),
            ("Invalid count", 
             input: ["U1ab"],
             output:nil),
            ("Multiple instructions", 
             input: ["U1", "R1"],
             output:[
                Point(x:0, y:1):1,
                Point(x:1, y:1):2,
            ]),
            ("Distance is the first time a point is encountered",
             input:["R2", "U1", "L1", "D1"],
             output:[
                Point(x:1, y:0):1,
                Point(x:2, y:0):2,
                Point(x:2, y:1):3,
                Point(x:1, y:1):4,
                // Final step revisits (1, 0) but should not override
                // distance
            ])
        ]

        for (testName, input, expectedOutput) in testCases {
            print("-----")
            let output = PathBuilder(input).Build()
            XCTAssertEqual(
                output,
                expectedOutput,
                "Failed for testcase '\(testName)' with input \(input)")
        }
    }

    func testDistanceToFirstIntersection() throws {
        let testCases : [(testName:String, wire1:[String], wire2:[String], expected:Distance?)] = [
            ("Single intersection", 
             wire1: ["R5", "U1"],
             wire2: ["U1", "R5"],
             expected:12),
            ("Closest intersection uses path length as distance", 
             wire1: ["R3", "U3", "U1", "L4", "D5"],
             wire2: ["U3", "R3", "R1", "D4", "L5"],
             // Has intersections at (3, 3) and (-1, -1), but passes (3, 3)
             // first
             expected: 12),
            ("No intersection", 
             wire1: ["L1"],
             wire2: ["R1"],
             expected: nil),
            ("Given example",
             wire1: ["R75","D30","R83","U83","L12","D49","R71","U7","L72"],
             wire2: ["U62","R66","U55","R34","D71","R55","D58","R83"],
             expected:610),
        ]

        for (testName, wire1, wire2, expected) in testCases {
            print("-----")
            let actual = CrossingWires().GetDistanceToFirstIntersection(wire1:wire1, wire2:wire2)
            XCTAssertEqual(
                expected, actual,
                "Failed for testcase '\(testName)'")
        }
    }

    static var allTests = [
        ("testPathBuilder", testPathBuilder),
        ("testDistanceToFirstIntersection", testDistanceToFirstIntersection),
    ]
}
