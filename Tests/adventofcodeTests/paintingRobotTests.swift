
import XCTest
@testable import adventofcodeLibrary


final class paintingRobotTests: XCTestCase {
    let kStop = [99]
    let kRead = 3
    let kWrite = 4

    // This will have a value after |RunRobot| is called.
    var robot : PaintingRobot!
    var grid = ColorGrid()

    func allCellsAreInitiallyEmpty() throws {
        RunRobot(
            instructions:[kStop]
        )

        XCTAssertEqual(
            [],
            grid.GetCells(color:.White)
        )
    }

    func CanPaintCurrentCell() throws {
        RunRobot(
            instructions: [
                PaintAndMove(.White, .Right),
                kStop,
            ],
            startCell: Cell(1,1)
        )

        XCTAssertEqual(
            [Cell(1, 1)],
            grid.GetCells(color:.White)
        )
    }

    func CanTurnAndMove() throws {
        RunRobot(
            instructions: [
                PaintAndMove(.Black, .Right),
                PaintAndMove(.White, .Right),
                kStop]
        )

        XCTAssertEqual(
            [Cell(1, 0)],
            grid.GetCells(color:.White)
        )
    }

    func ChangesOrientationAfterRightTurns() throws {
        RunRobot(
            instructions: [
                PaintAndMove(.Black, .Right),
                PaintAndMove(.White, .Right),
                PaintAndMove(.Yellow, .Right),
                PaintAndMove(.Red, .Right),
                PaintAndMove(.Green, .Right),
                kStop]
        )

        XCTAssertEqual(grid[Cell(1,0)], Color.White)
        XCTAssertEqual(grid[Cell(1,1)], Color.Yellow)
        XCTAssertEqual(grid[Cell(0,1)], Color.Red)
        XCTAssertEqual(grid[Cell(0,0)], Color.Green)
    }

    func ChangesOrientationAfterLeftTurns() throws {
        RunRobot(
            instructions: [
                PaintAndMove(.Black, .Left),
                PaintAndMove(.White, .Left),
                PaintAndMove(.Yellow, .Left),
                PaintAndMove(.Red, .Left),
                PaintAndMove(.Green, .Left),
                kStop]
        )

        XCTAssertEqual(grid[Cell(-1,0)], Color.White)
        XCTAssertEqual(grid[Cell(-1,1)], Color.Yellow)
        XCTAssertEqual(grid[Cell(0,1)], Color.Red)
        XCTAssertEqual(grid[Cell(0,0)], Color.Green)
    }

    func CanReadCurrentCellValueFromTheInput() throws {
        grid[Cell(0,0)] = .Yellow

        RunRobot(
            instructions: [
                [ kRead, 100 ],
                PaintAndMove(.Black, .Right),
                [ kWrite, 100 ],
                kStop,
            ]
        )

        XCTAssertEqual(grid[Cell(1,0)], Color.Yellow)
    }

    func RunRobot(instructions: [[Int]], startCell: Cell = Cell(0,0)) {
        let memory = Array(instructions.joined())
        print("instructions are \(memory)")
        robot = PaintingRobot(memory:memory)
        robot.RunOnGrid(&grid, startCell:startCell)
    }

    func PaintAndMove( _ color: Color, _ direction: Turn) -> [Int] {
        return [
            104,
            color.rawValue,
            104,
            direction.rawValue,
        ]
    }

    static var allTests = [
        ("allCellsAreInitiallyEmpty", allCellsAreInitiallyEmpty),
        ("CanPaintCurrentCell", CanPaintCurrentCell),
        ("CanTurnAndMove", CanTurnAndMove),
        ("ChangesOrientationAfterRightTurns", ChangesOrientationAfterRightTurns),
        ("ChangesOrientationAfterLeftTurns", ChangesOrientationAfterLeftTurns),
        ("CanReadCurrentCellValueFromTheInput", CanReadCurrentCellValueFromTheInput),
    ]
}
