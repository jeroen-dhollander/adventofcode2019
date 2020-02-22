import adventofcodeLibrary

let astroids = [
    "#.#.###.#.#....#..##.#....",
    ".....#..#..#..#.#..#.....#",
    ".##.##.##.##.##..#...#...#",
    "#.#...#.#####...###.#.#.#.",
    ".#####.###.#.#.####.#####.",
    "#.#.#.##.#.##...####.#.##.",
    "##....###..#.#..#..#..###.",
    "..##....#.#...##.#.#...###",
    "#.....#.#######..##.##.#..",
    "#.###.#..###.#.#..##.....#",
    "##.#.#.##.#......#####..##",
    "#..##.#.##..###.##.###..##",
    "#..#.###...#.#...#..#.##.#",
    ".#..#.#....###.#.#..##.#.#",
    "#.##.#####..###...#.###.##",
    "#...##..#..##.##.#.##..###",
    "#.#.###.###.....####.##..#",
    "######....#.##....###.#..#",
    "..##.#.####.....###..##.#.",
    "#..#..#...#.####..######..",
    "#####.##...#.#....#....#.#",
    ".#####.##.#.#####..##.#...",
    "#..##..##.#.##.##.####..##",
    ".##..####..#..####.#######",
    "#.#..#.##.#.######....##..",
    ".#.##.##.####......#.##.##",
]

func Day10() {
    let map = AstroidMap.Build(astroids)
    let point = map.BestSpot()

    print("Best point is \(point) where you see \(map.CountVisibleAstroids(point)) astroids")
}

func Day10Part2() {
    let map = AstroidMap.Build(astroids)

    let center = map.BestSpot()
    for (count, point) in map.GetVaporizationOrder(center).enumerated() {
        if count + 1 == 200 {
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        }
        print("\(count+1): \(point)")
        if count + 1 == 200 {
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        }
    }


}
