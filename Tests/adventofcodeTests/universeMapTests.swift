import XCTest
@testable import adventofcodeLibrary

final class countOrbitsTests: XCTestCase {
    typealias TestCase = (
        testName: String,
        orbits: [String],
        result: Int?
    )

    func RunTests(_ tests : [TestCase]) {
        for (testName, orbits, expected) in tests {
            print("-----")
            let actual = UniverseMap.CountOrbits(orbits:orbits)
            XCTAssertEqual(
                actual,
                expected,
                "Failed for testcase '\(testName)'")
        }
    }

    func testCountOrbits() throws {
        RunTests([
            ("Single orbit", 
             orbits: [
                "COM)B",
                ],
             result: 1
            ),
            ("Direct orbits", 
             orbits: [
                "COM)A",
                "COM)B",
                "COM)C",
                ],
             result: 3
            ),
            ("Indirect orbit", 
             orbits: [
                "COM)A",
                "A)B",
                ],
             result: 3
            ),
            ("Direct and indirect orbit", 
             orbits: [
                "COM)A",
                "COM)C",
                "A)B",
                ],
             result: 4
            ),
            ("Orbits can be specified in any order", 
             orbits: [
                "B)C",
                "A)B",
                "COM)A",
                ],
             result: 6
            ),
            ("Invalid orbit", 
             orbits: [
                "COM-A",
                ],
             result: nil
            ),
            ("Example from webpage",
             orbits: [
                "COM)B",
                "B)C",
                "C)D",
                "D)E",
                "E)F",
                "B)G",
                "G)H",
                "D)I",
                "E)J",
                "J)K",
                "K)L",
                ],
             result: 42
            ),
        ])
    }

    static var allTests = [
        ("testCountOrbits", testCountOrbits),
    ]
}

final class distanceTests: XCTestCase {
    typealias TestCase = (
        testName: String,
        orbits: [String],
        start: String,
        end: String,
        distance: Int
    )

    func RunTests(_ tests : [TestCase]) {
        for (testName, orbits, start, end, expected) in tests {
            print("-----")
            let universe = UniverseMapBuilder(orbits).Build()!
            let distance = universe.DistanceBetween(start, end)
            XCTAssertEqual(
                distance,
                expected,
                "Failed for testcase '\(testName)'")
        }
    }

    func testDistance() throws {
        RunTests([
            ("Same object", 
             orbits: [
                "COM)B",
                ],
             start: "B", 
             end:   "B",
             distance: 0
            ),
            ("Parent", 
             orbits: [
                "COM)B",
                ],
             start: "B", 
             end:   "COM",
             distance: 1
            ),
            ("Ancestor", 
             orbits: [
                "COM)A",
                "A)B",
                "B)C",
                ],
             start: "C", 
             end:   "A",
             distance: 2
            ),
            ("Descendant", 
             orbits: [
                "COM)A",
                "A)B",
                "B)C",
                ],
             start: "A", 
             end:   "C",
             distance: 2
            ),
            ("Indirect", 
             orbits: [
                "COM)A",
                "A)Sibling_1",
                "A)Sibling_2",
                ],
             start: "Sibling_1", 
             end:   "Sibling_2",
             distance: 2
            ),
            ("Example from webpage",
             orbits: [
                "COM)B",
                "B)C",
                "C)D",
                "D)E",
                "E)F",
                "B)G",
                "G)H",
                "D)I",
                "E)J",
                "J)K",
                "K)L",
                "K)YOU",
                "I)SAN",
                ],
             start: "YOU",
             end: "SAN",
             distance: 6
            )
        ])
    }

    static var allTests = [
        ("testDistance", testDistance),
    ]
}

