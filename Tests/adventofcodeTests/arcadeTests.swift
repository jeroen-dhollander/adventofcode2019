import XCTest
@testable import adventofcodeLibrary

final class arcadeTests: XCTestCase {

    let kStop = 99
    let kOutput = 104

    private func rendersOutput() throws {
        let testcases = [
            ("0 draws an empty space",
             instructions: [
                kOutput, 1,
                kOutput, 2,
                kOutput, 0,
                kStop
                ],
             expected: [
                Cell(1, 2): Tile.Empty,
                ]
            ),
            ("1 draws a wall",
             instructions: [
                kOutput, 1,
                kOutput, 2,
                kOutput, 1,
                kStop
                ],
             expected: [ Cell(1, 2): Tile.Wall, ]
            ),
            ("2 draws a block",
             instructions: [
                kOutput, 1,
                kOutput, 2,
                kOutput, 2,
                kStop
                ],
             expected: [ Cell(1, 2): Tile.Block, ]
            ),
            ("3 draws a paddle",
             instructions: [
                kOutput, 1,
                kOutput, 2,
                kOutput, 3,
                kStop
                ],
             expected: [ Cell(1, 2): Tile.Paddle, ]
            ),
            ("3 draws a ball",
             instructions: [
                kOutput, 1,
                kOutput, 2,
                kOutput, 4,
                kStop
                ],
             expected: [ Cell(1, 2): Tile.Ball, ]
            ),
        ]

        for (testName, instructions, expected) in testcases {
            let arcade = Arcade(instructions)
            arcade.run()

            let actual = arcade.screen.cells
            XCTAssertEqual(expected, actual, "Failure for test '\(testName)'")
        }

    }

    func testScore() throws {
        // (-1, 0) sets the score
        let arcade = Arcade([
            kOutput, -1,
            kOutput, 0,
            kOutput, 666,
            kStop
        ])
        arcade.run()

        XCTAssertEqual(666, arcade.score)
    }

    func testAiInput() throws {

        let testcases = [
            ("Returns -1 if ball is to the left of the paddle",
             initial: [
                Cell(1,1): Tile.Ball,
                Cell(2,1): Tile.Paddle,
                ],
             expected: -1
            ),
            ("Returns 1 if ball is to the right of the paddle",
             initial: [
                Cell(3,1): Tile.Ball,
                Cell(2,1): Tile.Paddle,
                ],
             expected: 1
            ),
            ("Returns 0 if ball has same x coordinate as the paddle",
             initial: [
                Cell(2,1): Tile.Ball,
                Cell(2,2): Tile.Paddle,
                ],
             expected: 0
            ),
        ]

        for (testName, initialState, expectedValue) in testcases {
            let arcade = Arcade([])
            arcade.screen.cells = initialState

            let input = ArcadeAiInput(arcade)
            XCTAssertEqual(expectedValue, try input.Read(), "Failure for test '\(testName)'")
        }
    }

    static var allTests = [
        ("rendersOutput", rendersOutput),
        ("testScore", testScore),
        ("testAiInput", testAiInput),
    ]
}
