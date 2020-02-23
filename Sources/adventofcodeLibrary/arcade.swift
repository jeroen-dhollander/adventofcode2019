
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
    private var cpu : Cpu

    public init(_ instructions: [Int]) {
        cpu = Cpu(instructions)
    }

    public func run() {

        var output : Output = []
        var input : Input = []

        guard cpu.Run(input: &input, output: &output) else {
            fatalError("Failed to run")
        }

        processOutput(output as! [Int])
    }

    private func processOutput(_ output: [Int]) {
        assert(output.count % 3 == 0)

        for i in stride(from: 0, to: output.count, by: 3) {
            let x = output[i]
            let y = output[i+1]
            let tile = Tile.fromInt(output[i+2])!

            update(tile, at:Cell(x,y))
        }
    }

    public func update(_ value: Tile, at: Cell) {
        screen[at] = value
    }
}
