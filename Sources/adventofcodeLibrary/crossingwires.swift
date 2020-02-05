
public struct Point: Hashable, CustomStringConvertible, Equatable {
    var x: Int
    var y: Int

    public var description : String { return "P(\(x), \(y))" }
}

enum Direction {
    case Up, Down, Left, Right
}

public typealias Distance = Int

func Contains(_ locations:[Point:Distance], _ point:Point) -> Bool {
    if let _ = locations[point] {
        return true
    }
    return false
}

// Helper class to build the path of a given wire using a set
// of instructions containing a direction (L/R/U/D) and a distance.
// 
// For example, given the input [L2, U3] (left 2, up 3) this will
// create the set of positions
//     (-1, 0), (-2, 0), (-2, 1), (-2, 2), (-2, 3)
public class PathBuilder {
    var instructions: [String]
    var locations: [Point:Distance]
    var current_position : Point
    var current_distance : Distance

    init(_ instructions:[String]) {
        self.instructions = instructions
        locations = [:]
        current_position = Point(x:0, y:0)
        current_distance = 0
    }

    func Build() -> [Point:Distance]? {
        do {
            return try TryToBuild()
        } catch {
            print("Got error \(error)")
            return nil
        }
    }

    func TryToBuild() throws -> [Point:Distance] {
        for instruction in instructions { 
            let (direction, count) = try ParseInstruction(instruction)
            for _ in 1...count {
                MoveTo(direction)
            }
        }
        return locations
    }

    func ParseInstruction(_ instruction:String) throws -> (Direction, Int){
        func GetDirection() throws -> Direction {
            switch instruction.prefix(1) {
            case "R":
                return Direction.Right
            case "L":
                return Direction.Left
            case "U":
                return Direction.Up
            case "D":
                return Direction.Down
            case let x:
                throw "Invalid direction \(x)"
            }
        }
        func GetCount() throws -> Int {
            let count_string = instruction.dropFirst()
            guard let count = Int(count_string) else {
                throw "Invalid count \(count_string)"
            }
            return count

        }

        return try (GetDirection(), GetCount())
    }

    func MoveTo(_ direction:Direction) {
        switch direction {
        case .Right:
            current_position.x += 1
        case .Left:
            current_position.x -= 1
        case .Up:
            current_position.y += 1
        case .Down:
            current_position.y -= 1
        }
        current_distance += 1

        if !Contains(locations, current_position) {
            locations[current_position] = current_distance
        }
    }
}

public class CrossingWires {
    public init() {}

    public func GetDistanceToFirstInterception(wire1:[String], wire2:[String]) -> Distance? {
        do {
            return try TryToGetDistanceToFirstInterception(wire1:wire1, wire2:wire2)
        } catch {
            print("Got error \(error)")
            return nil
        }
    }

    func TryToGetDistanceToFirstInterception(wire1:[String], wire2:[String]) throws -> Distance {
        let wire1Distances = try PathBuilder(wire1).TryToBuild()
        let wire2Distances = try PathBuilder(wire2).TryToBuild()

        let intersections = Set(wire1Distances.keys).intersection(wire2Distances.keys)
        let distances = intersections.map{wire1Distances[$0]! + wire2Distances[$0]!}

        if intersections.isEmpty {
            throw "The wires do not cros."
        }

        for point in intersections {
            let distance = wire1Distances[point]! + wire2Distances[point]!
            print("Point \(point) has distance \(distance)")
        }

        return distances.reduce(Int.max, { min($0, $1) })
    }


}
