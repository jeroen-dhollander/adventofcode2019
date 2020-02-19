
import XCTest
@testable import adventofcodeLibrary

final class astroidMapTests: XCTestCase {

    func testBuild() {
        let result = AstroidMap.Build([
            "#..",
            ".#.",
            "..#",
        ])

        XCTAssertEqual(
            result.grid,
            [
                ["#", ".", "."],
                [".", "#", "."],
                [".", ".", "#"],
        ])
    }

    func testGetAstroids() {
        let result = AstroidMap.Build([
            "#.#",
            ".#.",
            "...",
        ])

        XCTAssertEqual(
            result.astroids,
            [Point(0,0), Point(2,0), Point(1,1)]
        )
    }

    func testCountVisibleAstroids() {
        let testcases = [
            ([
                "#.#",
                ".#.",
                "...", ],
             [
                [2, 0, 2],
                [0, 2, 0],
                [0, 0, 0], ]
            ),
            ([
                "#.#",
                ".#.",
                "..#", ],
             [
                [2, 0, 3],
                [0, 3, 0],
                [0, 0, 2], ]
            ),
            (
                [
                    ".#..#",
                    ".....",
                    "#####",
                    "....#",
                    "...##"],
                [
                    [0,7,0,0,7],
                    [0,0,0,0,0],
                    [6,7,7,7,5],
                    [0,0,0,0,7],
                    [0,0,0,8,7], ]
            )
        ]

        for (rows, expected) in testcases {
            let map = AstroidMap.Build(rows)
            let actual = map.CountVisibleAstroids()
            XCTAssertEqual(expected, actual, "Failure for map \(rows)")
        }
    }

    func testBestSpot() {
        let testcases = [
            (
                [
                    ".#..#",
                    ".....",
                    "#####",
                    "....#",
                    "...##"],
                Point(3, 4)
            ),
            (
                [
                    "......#.#.",
                    "#..#.#....",
                    "..#######.",
                    ".#.#.###..",
                    ".#..#.....",
                    "..#....#.#",
                    "#..#....#.",
                    ".##.#..###",
                    "##...#..#.",
                    ".#....####", ], 
                Point(5,8)
            ),
        ]

        for (rows, expected) in testcases {
            let map = AstroidMap.Build(rows)
            let actual = map.BestSpot()
            XCTAssertEqual(expected, actual, "Failure for map \(rows)")
        }
    }

    func testGetVisibleAstroids() {
        let testcases = [
            (
                [
                    "###",
                    "###",
                    "###", ],
                center: Point(1, 1),
                expected: [
                    Point(1, 0),
                    Point(2, 0),
                    Point(2, 1),
                    Point(2, 2),
                    Point(1, 2),
                    Point(0, 2),
                    Point(0, 1),
                    Point(0, 0),
                ]
            ),
            (
                [
                    "#.#",
                    ".#.",
                    "..#", ],
                center: Point(0, 0),
                expected: [
                    Point(2, 0),
                    Point(1, 1),
                ]
            ),
        ]

        for (rows, center, expected) in testcases {
            let map = AstroidMap.Build(rows)
            let actual = map.GetVisibleAstroids(center)
            XCTAssertEqual(expected.sorted(), actual.sorted(), "Failure for map \(rows)")
        }
    }

    func testVaporizationOrder() {
        let testcases = [
            (
                [
                    "..#",
                    ".#.",
                    "..#", ],
                center: Point(1, 1),
                expected: [
                    Point(2, 0),
                    Point(2, 2),
                ]
            ),
            (
                [
                    "###",
                    "###",
                    "###", ],
                center: Point(1, 1),
                expected: [
                    Point(1, 0),
                    Point(2, 0),
                    Point(2, 1),
                    Point(2, 2),
                    Point(1, 2),
                    Point(0, 2),
                    Point(0, 1),
                    Point(0, 0),
                ]
            ),
            (
                [
                    "#.#",
                    ".#.",
                    "#.#", ],
                center: Point(0, 2),
                expected: [
                    Point(0, 0),
                    Point(1, 1),
                    Point(2, 2),
                    Point(2, 0),
                ]
            ),
        ]

        for (rows, center, expected) in testcases {
            let map = AstroidMap.Build(rows)
            let actual = map.GetVaporizationOrder(center)
            XCTAssertEqual(expected, actual, "Failure for map \(rows)")
        }
    }

    static var allTests = [
        ("testBuild", testBuild),
        ("testGetAstroids", testGetAstroids),
        ("testCountVisibleAstroids", testCountVisibleAstroids),
        ("testBestSpot", testBestSpot),
        ("testGetVisibleAstroids", testGetVisibleAstroids),
        ("testVaporizationOrder", testVaporizationOrder),
    ]
}
