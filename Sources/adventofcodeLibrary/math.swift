import Foundation

public struct Point: Hashable, CustomStringConvertible, Equatable, Comparable {
    var x: Int
    var y: Int

    public var description : String { return "P(\(x), \(y))" }

    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public func DistanceTo(_ other: Point) -> Int {
        // DNP rename
        return abs(other.x - self.x) + abs(other.y - self.y)
    }

    public static func < (left: Point, right: Point) -> Bool {
        if left.x != right.x {
            return left.x < right.x
        }
        return left.y < right.y
    }

    public static func +(_ point: Point, _ delta: (x:Int, y:Int)) -> Point {
        return Point(point.x + delta.x, point.y + delta.y)
    }

    public static func +=(_ point: inout Point, _ delta: (x:Int, y:Int)) {
        point = point + delta
    }
}

// An angle, represented as a fraction to prevent floating point issues.
// Will always be normalized, i.e. Angle(4, 2) will be translated to Angle(2, 1)
struct Angle: Hashable, Equatable {

    private var dx_ : Int
    private var dy_ : Int

    public init(_ dx: Int, _ dy: Int) {
        let gcd = GreatestCommonDenominator(abs(dx), abs(dy))
        self.dx_ = dx/gcd
        self.dy_ = dy/gcd
    }

    static func Between(_ left: Point, _ right: Point) -> Angle {
        // This is a bit funny and confusing,
        //     If right.x > left.x then the dx is positive,
        //     For y it is reverse as y increases upwards,
        //        but in the grid a higher y value means it is lower
        return Angle(right.x-left.x, left.y-right.y)
    }

    //  Straight up is 0 degrees, right 90, down 180 and left 270
    func ToDegrees() -> Double {
        func ToDegrees(_ dx : Int, _ dy : Int) -> Double {
            let radians = atan(Double(dx)/Double(dy))
            let degrees = radians / Double.pi * 180
            return degrees
        }
        switch (self.dx.sign, self.dy.sign) {
        case (1, 1):
            // 0 - 90 degrees
            return ToDegrees(self.dx, self.dy)
        case (1, -1):
            // 90 - 180 degrees
            return ToDegrees(-self.dy, self.dx) + 90
        case (-1, -1):
            // 180 - 270 degrees
            return ToDegrees(-self.dx, -self.dy) + 180
        case (-1, 1):
            // 270 - 0 degrees
            let result = ToDegrees(self.dy, -self.dx) + 270
            return result > 360.0 ? result - 360 : result
        default:
            // Impossible to hit as |sign| will always return -1 or 1
            fatalError()
        }
    }

    var dx :Int { return dx_ }
    var dy :Int { return dy_ }

}

func GreatestCommonDenominator(_ left: Int, _ right: Int) -> Int {
    if left < right {
        return GreatestCommonDenominator(right, left)
    }
    if left == 0 && right == 0 {
        // Maybe not mathematically correct, but at least it prevents
        // division by zero errors
        return 1
    }
    if right == 0 {
        return left
    }
    return GreatestCommonDenominator(left % right, right)
}

extension Int {
    var sign : Int {
        return self < 0 ? -1 : 1
    }
}

func Min(_ values: [Int]) -> Int {
    return values.reduce(Int.max, min)
}

func Max(_ values: [Int]) -> Int {
    return values.reduce(Int.min, max)
}

