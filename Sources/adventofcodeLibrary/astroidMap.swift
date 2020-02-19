
public class AstroidMap {

    let Astroid : Character = "#"
    let Empty  : Character = "."

    public static func Build(_ rows:[String]) -> AstroidMap {
        return AstroidMap(rows.map{Array($0)})
    }

    private var grid_ : [[Character]]

    init(_ grid: [[Character]]) {
        self.grid_ = grid
    }

    public var grid : [[Character]] { return grid_ }

    public var astroids : [Point] { 
        var result : [Point] = []
        for y in 0..<grid.count {
            for x in 0..<grid[0].count {
                if IsAstroid(Point(x,y)) {
                    result.append(Point(x,y))
                }
            }
        }
        return result
    }

    public func CountVisibleAstroids() -> [[Int]] {
        var result : [[Int]] = []
        for y in 0..<grid.count {
            var row : [Int] = []
            for x in 0..<grid[0].count {
                row.append(CountVisibleAstroids(Point(x,y)))
            }
            result.append(row)
        }
        return result
    }

    public func BestSpot() -> Point {
        let result = self.astroids
            .map{ (CountVisibleAstroids($0), $0) }
            .max(by: { $0.0 < $1.0 })
        return result!.1
    }

    public func GetVaporizationOrder(_ center: Point) -> [Point] {
        func CompareAngles  (_ left: Point, _ right: Point) -> Bool {
            let left_angle = Angle.Between(center, left)
            let right_angle = Angle.Between(center, right)
            print("Angle \(center) -> \(left): \(left_angle) (degrees \(left_angle.ToDegrees()))")
            print("Angle \(center) -> \(right): \(right_angle) (degrees \(right_angle.ToDegrees()))")
            return left_angle.ToDegrees() < right_angle.ToDegrees()
        }

        var remaining_astroids = self.astroids.filter{ $0 != center }
        var result : [Point] = []

        while !remaining_astroids.isEmpty {
            result += AstroidMap.GetVisibleAstroids(center, remaining_astroids).sorted(by: CompareAngles )
            remaining_astroids = remaining_astroids.filter{
                !result.contains($0)
            }
        }

        return result
    }

    public func GetVisibleAstroids(_ center: Point) -> [Point] {
        return AstroidMap.GetVisibleAstroids(center, self.astroids)
    }

    static func GetVisibleAstroids(_ center: Point, _ astroids: [Point]) -> [Point] {
        // Store the astroid at a given angle.
        // If 2 such astroids exist, we keep the closest one
        var astroids_by_angle : [Angle:Point] = [:]

        func closest(_ left: Point, _ right: Point) -> Point {
            if center.DistanceTo(left) < center.DistanceTo(right) {
                return left
            }
            return right
        }

        func add(_ new_point: Point) {
            let angle = Angle.Between(center, new_point)

            switch astroids_by_angle[angle] {
            case nil:
                // Adding the first astroid at the given angle
                astroids_by_angle[angle] = new_point
            case let old_point:
                astroids_by_angle[angle] = closest(new_point, old_point!)
            }
        }

        for astroid in astroids.filter({$0 != center}) {
            add(astroid)
        }

        return Array(astroids_by_angle.values)
    }

    public func CountVisibleAstroids(_ center: Point) -> Int {
        if !IsAstroid(center) {
            return 0
        }
        // We simply remember the angle of all visible astroids.
        // Because astoids on the same line have the same angle from the center
        // point, this will filter out ocluded astroids.

        let angles = Set<Angle>( 
            self.astroids.filter{ $0 != center }
                .map{ Angle.Between(center, $0) }
        )
        return angles.count
    }

    private func IsAstroid(_ point: Point) -> Bool {
        return grid[point.y][point.x] == Astroid
    }
}

