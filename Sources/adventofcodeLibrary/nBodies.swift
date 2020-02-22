
public struct Position : Hashable, Equatable, CustomStringConvertible {
    var x: Int
    var y: Int
    var z: Int

    public init(_ x:Int, _ y:Int, _ z:Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    public var description : String { return "(\(x), \(y), \(z))" }

    public static func +(_ left: Position, _ right: Position) -> Position {
        return Position(left.x+right.x, left.y+right.y, left.z+right.z)
    }

    public static func +=(_ left: inout Position, _ right: Position) {
        left = left + right
    }
}

public typealias Velocity = Position


public class NBodies {

    private var velocities : [String:Velocity]
    private var positions : [String:Position]

    public init(_ bodies: [(name: String, position:Position, velocity:Velocity)]) {
        self.velocities = bodies.reduce(into: [String:Velocity]()) {
            $0[$1.name] = $1.velocity
        }
        self.positions = bodies.reduce(into: [String:Position]()) {
            $0[$1.name] = $1.position
        }
    }

    public func advanceTime() {
        self.updateVelocities()
        self.updatePositions()
    }

    private func updateVelocities() {
        func delta(_ this: Int, _ other: Int) -> Int {
            if this < other {
                return 1
            } else if this > other {
                return -1
            }
            else {
                return 0
            }
        }

        for (body, position) in self.positions {
            let delta_x = self.positions.values
                .map{ $0.x }
                .map{ delta(position.x, $0) }
                .reduce(0, +)
            let delta_y = self.positions.values
                .map{ $0.y }
                .map{ delta(position.y, $0) }
                .reduce(0, +)
            let delta_z = self.positions.values
                .map{ $0.z }
                .map{ delta(position.z, $0) }
                .reduce(0, +)

            self.velocities[body]! += Velocity(delta_x, delta_y, delta_z)
        }
    }

    private func updatePositions() {
        for (body, velocity) in self.velocities {
            self.positions[body]! += velocity
        }
    }

    public func velocityOf(_ name: String) -> Velocity! {
        return self.velocities[name]
    }

    public func positionOf(_ name: String) -> Position! {
        return self.positions[name]
    }

    public var bodies : [String] { return Array(self.positions.keys) }

    public var energy : Int {
        return 
            self.bodies
                .map(self.energyOf)
                .reduce(0, +)
    }

    public func energyOf(_ body: String) -> Int {

        let velocity = self.velocityOf(body)!
        let position = self.positionOf(body)!

        let kineticEnergy = abs(velocity.x) + abs(velocity.y) + abs(velocity.z)
        let potentialEnergy = abs(position.x) + abs(position.y) + abs(position.z)

        return kineticEnergy * potentialEnergy
    }
}
