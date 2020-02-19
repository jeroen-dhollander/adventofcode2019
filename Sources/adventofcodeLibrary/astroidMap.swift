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

    public func CountVisibleAstroids(_ center: Point) -> Int {
        if !IsAstroid(center) {
            return 0
        }
        // We will remember the angle of all visible astroids.
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

