import XCTest
@testable import adventofcodeLibrary

final class nBodiesTests: XCTestCase {

    func velocityIsUpdated() throws {
        let testcases = [
            ("Gravity of 2 bodies affects their x positions",
             bodies: [
                ("Body 1", Position(1, 0, 0), Velocity(0, 0, 0)),
                ("Body 2", Position(5, 0, 0), Velocity(0, 0, 0)),
                ],
             expected: [
                ("Body 1", Velocity(1, 0, 0)),
                ("Body 2", Velocity(-1, 0, 0)),
                ]
            ),
            ("Gravity of 2 bodies affects their y positions",
             bodies: [
                ("Body 1", Position(0, 1, 0), Velocity(0, 0, 0)),
                ("Body 2", Position(0, 5, 0), Velocity(0, 0, 0)),
                ],
             expected: [
                ("Body 1", Velocity(0, 1, 0)),
                ("Body 2", Velocity(0, -1, 0)),
                ]
            ),
            ("Gravity of 2 bodies affects their z positions",
             bodies: [
                ("Body 1", Position(0, 0, 1), Velocity(0, 0, 0)),
                ("Body 2", Position(0, 0, 5), Velocity(0, 0, 0)),
                ],
             expected: [
                ("Body 1", Velocity(0, 0, 1)),
                ("Body 2", Velocity(0, 0, -1)),
                ]
            ),
            ("Gravity of 3 bodies",
             bodies: [
                ("Body 1", Position(01, 01, 01), Velocity(0, 0, 0)),
                ("Body 2", Position(10, 10, 10), Velocity(0, 0, 0)),
                ("Body 3", Position(20, 20, 20), Velocity(0, 0, 0)),
                ],
             expected: [
                ("Body 1", Velocity(2, 2, 2)),
                ("Body 2", Velocity(0, 0, 0)),
                ("Body 3", Velocity(-2, -2, -2)),
                ]
            ),
            ("Velocity is added to previous velocity",
             bodies: [
                ("Body 1", Position(01, 01, 01), Velocity(10, 20, 30)),
                ("Body 2", Position(10, 10, 10), Velocity(0, 0, 0)),
                ],
             expected: [
                ("Body 1", Velocity(11, 21, 31)),
                ]
            ),
        ]

        for (testName, bodies, expected) in testcases {
            let nBodies = NBodies(bodies)

            nBodies.advanceTime()

            for (name, expected) in expected {
                let actual = nBodies.velocityOf(name)
                XCTAssertEqual(expected, actual,
                               "Failure in test '\(testName)' for body \(name)")
            }
        }
    }

    func positionIsUpdated() throws {
        let testcases = [
            ("Velocity is added to the position",
             bodies: [
                ("Body 1", Position(10, 100, 1000), Velocity(1, 5, 7)),
                ],
             expected: [
                ("Body 1", Position(11, 105, 1007)),
                ]
            ),
            ("Velocity is updated before position",
             bodies: [
                ("Body 1", Position(10, 100, 1000), Velocity(0, 0, 0)),
                ("Body 2", Position(20, 200, 2000), Velocity(0, 0, 0)),
                ],
             expected: [
                ("Body 1", Position(11, 101, 1001)),
                ("Body 2", Position(19, 199, 1999)),
                ]
            ),
        ]

        for (testName, bodies, expected) in testcases {
            let nBodies = NBodies(bodies)

            nBodies.advanceTime()

            for (name, expected) in expected {
                let actual = nBodies.positionOf(name)
                XCTAssertEqual(expected, actual,
                               "Failure in test '\(testName)' for body \(name)")
            }
        }
    }

    func ExampleFromInstructions() throws {

        let nBodies = NBodies([
            ("Body 1", Position(-1, 0, 2), Velocity(0, 0, 0)),
            ("Body 2", Position(2, -10, -7), Velocity(0, 0, 0)),
            ("Body 3", Position(4, -8, 8), Velocity(0, 0, 0)),
            ("Body 4", Position(3, 5, -1), Velocity(0, 0, 0)),
        ])

        for _ in 0..<10 {
            nBodies.advanceTime()
        }

        XCTAssertEqual(nBodies.positionOf("Body 1"), Position(2,  1, -3))
        XCTAssertEqual(nBodies.velocityOf("Body 1"), Velocity(-3, -2,  1))
        XCTAssertEqual(nBodies.positionOf("Body 2"), Position(1, -8,  0))
        XCTAssertEqual(nBodies.velocityOf("Body 2"), Velocity(-1,  1,  3))
        XCTAssertEqual(nBodies.positionOf("Body 3"), Position(3, -6,  1))
        XCTAssertEqual(nBodies.velocityOf("Body 3"), Velocity( 3,  2, -3))
        XCTAssertEqual(nBodies.positionOf("Body 4"), Position(2,  0,  4))
        XCTAssertEqual(nBodies.velocityOf("Body 4"), Velocity( 1, -1, -1))

        XCTAssertEqual(179, nBodies.energy)
    }

    static var allTests = [
        ("velocityIsUpdated", velocityIsUpdated),
        ("positionIsUpdated", positionIsUpdated),
        ("ExampleFromInstructions", ExampleFromInstructions),
    ]
}
