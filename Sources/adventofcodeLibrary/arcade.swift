import Glibc

public enum Tile : String {
    // 2 spaces seems to render with the same width as the unicode characters.
    case Empty = "  "
    case Paddle = "🏓"
    case Wall = "🧱"
    case Block = "🚪"
    case Ball = "⚽"

    static func fromInt(_ value: Int) -> Tile? {
        switch (value) {
        case 0:
            return .Empty
        case 1:
            return .Wall
        case 2:
            return .Block
        case 3:
            return .Paddle
        case 4:
            return .Ball
        default:
            return nil
        }
    }
}


public struct ArcadeScreen {

    public typealias Cell = Point

    let kDefaultValue = Tile.Empty

    public var cells : [Cell:Tile] = [:]

    public init() {}

    public subscript(_ cell: Cell) -> Tile { 
        get { return cells[cell] ?? kDefaultValue }
        set { cells[cell] = newValue }
    }

    public func format() -> [String] {
        let min_x = Min(cells.keys.map{ $0.x } )
        let max_x = Max(cells.keys.map{ $0.x } )
        let min_y = Min(cells.keys.map{ $0.y } )
        let max_y = Max(cells.keys.map{ $0.y } )

        func formatRow(_ y: Int) -> String {
            return (min_x...max_x)
                .map{ self[Cell($0, y)] }
                .reduce("", { $0 + String($1.rawValue) })
        }

        return Array((min_y...max_y).map(formatRow))
    }

    public func draw() {
        let _ = self.format().map{
            print($0)
        }
    }
}

public class Arcade {

    public typealias Cell = ArcadeScreen.Cell

    public var screen = ArcadeScreen()
    public var score : Int = 0
    private var cpu : Cpu

    public init(_ instructions: [Int]) {
        cpu = Cpu(instructions)
    }

    public func run() {
        var input: Input = []
        run(input: &input)
    }

    public func run(input: inout Input, drawOnOutput: Bool = false) {
        var output : Output = ArcadeOutput(self, drawOnOutput:drawOnOutput)
        guard cpu.Run(input: &input, output: &output) else {
            fatalError("Failed to run")
        }
    }

    public func draw() {
        print("")
        self.screen.draw()
        print("Score: \(self.score)")
    }

    fileprivate func processOutput(_ x: Int, _ y: Int, _ value: Int) {
        switch (x, y) {
        case (-1, 0):
            self.score = value
        default:
            let tile = Tile.fromInt(value)!
            update(tile, at:Cell(x,y))
        }
    }

    public func update(_ value: Tile, at: Cell) {
        screen[at] = value
    }
}

// Input for the Arcade, driven by an AI.
// Will always move the paddle closer to the ball
public class ArcadeAiInput : Input {
    private var arcade: Arcade

    public init(_ arcade: Arcade) {
        self.arcade = arcade
    }

    public func Read() throws -> Int {
        if ball < paddle {
            return -1
        } else if ball > paddle {
            return 1
        } else {
            return 0
        }
    }

    private var ball : Int { return xPosOf(.Ball) }
    private var paddle : Int { return xPosOf(.Paddle) }

    private func xPosOf(_ tile: Tile) -> Int {
        return arcade.screen.cells
            .map{ (cell:$0, value:$1) }
            .filter{ $0.value == tile }
            .map { $0.cell.x }
            .first!
    }


}

private class ArcadeOutput : Output {
    private var arcade: Arcade
    private var drawOnOutput: Bool
    private var buffer: [Int] = []

    init(_ arcade: Arcade, drawOnOutput: Bool) {
        self.arcade = arcade
        self.drawOnOutput = drawOnOutput
    }

    func Write(_ value: Int) {
        if buffer.count == 2 {
            arcade.processOutput(buffer[0], buffer[1], value)
            if drawOnOutput {
                system("clear")
                arcade.draw() // Does not really belong here :/
            }
            buffer = []
        }
        else {
            buffer.append(value)
            return
        }


    }
}
