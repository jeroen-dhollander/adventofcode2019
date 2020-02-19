
public struct Point: Hashable, CustomStringConvertible, Equatable {
    var x: Int
    var y: Int

    public var description : String { return "P(\(x), \(y))" }

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

// An angle, represented as a fraction to prevent floating point issues.
// Will always be normalized, i.e. Angle(4, 2) will be translated to Angle(2, 1)
struct Angle: Hashable, Equatable {

    private var numerator_ : Int
    private var denominator_ : Int

    init(_ numerator: Int, _ denominator: Int) {
        let gcd = GreatestCommonDenominator(abs(numerator), abs(denominator))
        self.numerator_ = numerator/gcd
        self.denominator_ = denominator/gcd
    }

    static func Between(_ left: Point, _ right: Point) -> Angle {
        return Angle(right.x-left.x, right.y-left.y)
    }

    var numerator :Int { return numerator_ }
    var denominator :Int { return denominator_ }

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
