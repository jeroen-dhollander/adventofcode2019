
public enum Color : Int {
    case Black = 0
    case White = 1
    case Yellow = 2
    case Red = 3
    case Green = 4
}

enum Turn : Int {
    case Left = 0
    case Right = 1
}

public enum Orientation: Int {
    case North = 0, East, South, West


    fileprivate mutating func TurnTo(_ turn: Turn) {
        func GetNextOrientation() -> Orientation {
            switch turn {
            case .Right:
                switch self {
                case .North:
                    return .East
                case .East:
                    return .South
                case .South:
                    return .West
                case .West:
                    return .North
                }
            case .Left:
                switch self {
                case .North:
                    return .West
                case .West:
                    return .South
                case .South:
                    return .East
                case .East:
                    return .North
                }

            }
        }

        self = GetNextOrientation()
    }
}

public typealias Cell = Point

public struct ColorGrid {

    let kDefaultValue = Color.Black

    private var cells : [Cell:Color] = [:]

    public init() {}

    public subscript(_ cell: Cell) -> Color { 
        get { return cells[cell] ?? kDefaultValue }
        set { 
            Logger.Debug("Setting \(cell) to \(newValue)")
            cells[cell] = newValue 
        }
    }

    public func GetCells(color: Color) -> [Cell] {
        return cells
            .filter{ (_: Cell, cellColor: Color) in cellColor == color }
            .map{ (cell: Cell, _: Color) in cell }
    }

    public func Format(_ colors:[Color:String]) -> [String] {
        let min_x = Min(cells.keys.map{ $0.x } )
        let max_x = Max(cells.keys.map{ $0.x } )
        let min_y = Min(cells.keys.map{ $0.y } )
        let max_y = Max(cells.keys.map{ $0.y } )

        func FormatColor(_ color : Color) -> String {
            if let result = colors[color] {
                return result
            }
            return " "
        }

        func FormatRow(_ x: Int) -> String {
            return (min_y...max_y)
                .map{ self[Cell(x, $0)] }
                .reduce("", { $0 + FormatColor($1) })
        }

        return Array((min_x...max_x).map(FormatRow))
    }

}

func Min(_ values: [Int]) -> Int {
    return values.reduce(Int.max, min)
}

func Max(_ values: [Int]) -> Int {
    return values.reduce(Int.min, max)
}


public class PaintingRobot {

    fileprivate var grid : ColorGrid!
    private var cpu : Cpu

    public var orientation : Orientation = .North
    public var position : Cell!

    public init(memory: [Int]) {
        cpu = Cpu(memory)
    }

    public func RunOnGrid(_ grid: inout ColorGrid, startCell:Cell = Cell(0,0)) {
        self.grid = grid
        self.position = startCell

        var output : Output = RobotOutput(self)
        var input : Input = RobotInput(self)
        guard cpu.Run(input: &input, output: &output) else {
            fatalError("Failed to run")
        }

        grid = self.grid
    }

    fileprivate func TurnAndMove(_ turn: Turn) {
        // DNP support current orientation
        func GetDelta() -> (x:Int, y:Int) {
            switch(orientation) {
            case .North:
                return (0, -1)
            case .East:
                return (1, 0)
            case .South:
                return (0, 1)
            case .West:
                return (-1, 0)
            }
        }

        self.orientation.TurnTo(turn)
        self.position += GetDelta()
    }

    private func Turn(_ turn: Turn) {

    }
}

class RobotInput : Input {

    var robot: PaintingRobot

    init(_ robot: PaintingRobot) {
        self.robot = robot
    }

    public func Read() -> Int {
        return self.robot.grid[self.robot.position].rawValue
    }
}

class RobotOutput : Output {

    enum Instruction {
        case Paint, Turn
    }

    var robot: PaintingRobot
    var nextInstruction : Instruction = Instruction.Paint

    init(_ robot: PaintingRobot) {
        self.robot = robot
    }

    func Write(_ value: Int) {
        switch (nextInstruction) {
        case .Paint:
            self.DoPaint(value)
            self.nextInstruction = Instruction.Turn
        case .Turn:
            self.DoTurn(value)
            self.nextInstruction = Instruction.Paint
        }
    }

    func DoPaint(_ value: Int) {
        guard let color = Color(rawValue: value) else {
            fatalError("Invalid color \(value)")
        }
        self.robot.grid[self.robot.position] = color
    }

    func DoTurn(_ value: Int) {
        guard let direction = Turn(rawValue: value) else {
            fatalError("Invalid turn \(value)")
        }
        self.robot.TurnAndMove(direction)
    }

}
