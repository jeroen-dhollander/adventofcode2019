
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

public class SingleDimensionNBodies {

    private var velocities_ : [Int] = []
    private var positions_ : [Int] = []

    public func addBody(position: Int, velocity: Int) {
        self.velocities_.append(velocity)
        self.positions_.append(position)
    }

    public func advanceTime() {
        self.updateVelocities()
        self.updatePositions()
    }

    private func updateVelocities() {
        func GetDelta(_ this: Int, _ other: Int) -> Int {
            if this < other {
                return 1
            } else if this > other {
                return -1
            }
            else {
                return 0
            }
        }

        for (index, position) in self.positions_.enumerated() {
            let delta = self.positions_
                .map{ GetDelta(position, $0) }
                .reduce(0, +)

            self.velocities_[index] += delta
        }
    }

    private func updatePositions() {
        for (index, velocity) in self.velocities_.enumerated() {
            self.positions_[index] += velocity
        }
    }

    public func velocityOf(_ index: Int) -> Int {
        return self.velocities_[index]
    }

    public func positionOf(_ index: Int) -> Int {
        return self.positions_[index]
    }

    public var velocities : [Int] { return self.velocities_ }
    public var positions : [Int] { return self.positions_ }

}

public class NBodies {

    private var names: [String]
    // Should not really be public
    public var x: SingleDimensionNBodies 
    public var y: SingleDimensionNBodies
    public var z: SingleDimensionNBodies

    private var velocities : [String:Velocity]
    private var positions : [String:Position]

    public init(_ bodies: [(name: String, position:Position, velocity:Velocity)]) {
        self.names = bodies.map{$0.name}

        self.velocities = bodies.reduce(into: [String:Velocity]()) {
            $0[$1.name] = $1.velocity
        }
        self.positions = bodies.reduce(into: [String:Position]()) {
            $0[$1.name] = $1.position
        }

        x = SingleDimensionNBodies()
        for (_, position, velocity) in bodies {
            x.addBody(position:position.x, velocity:velocity.x)
        }
        y = SingleDimensionNBodies()
        for (_, position, velocity) in bodies {
            y.addBody(position:position.y, velocity:velocity.y)
        }
        z = SingleDimensionNBodies()
        for (_, position, velocity) in bodies {
            z.addBody(position:position.z, velocity:velocity.z)
        }

    }

    public func advanceTime() {
        x.advanceTime()
        y.advanceTime()
        z.advanceTime()
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
        let index = self.names.firstIndex(of: name)!
        return Velocity(
            x.velocityOf(index),
            y.velocityOf(index),
            z.velocityOf(index)
        )
    }

    public func positionOf(_ name: String) -> Position! {
        let index = self.names.firstIndex(of: name)!
        return Position(
            x.positionOf(index),
            y.positionOf(index),
            z.positionOf(index)
        )
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
