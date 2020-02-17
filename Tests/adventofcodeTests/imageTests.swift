import XCTest
@testable import adventofcodeLibrary

final class imageTests: XCTestCase {

    func testFromString() throws {
        let image = Image.FromString(
            width:2,
            height:3,
            pixels: """
                112233\
                445566
                """
        )

        XCTAssertEqual(2, image.width)
        XCTAssertEqual(3, image.height)
        XCTAssertEqual(2, image.layers.count)
        XCTAssertEqual([[1, 1], [2, 2], [3, 3]], image.layers[0].pixels)
        XCTAssertEqual([[4, 4], [5, 5], [6, 6]], image.layers[1].pixels)
    }

    func testNumberOf() throws {
        let layer = Layer([
            [1, 1, 1],
            [1, 1, 1],
            [2, 2, 2],
        ])

        XCTAssertEqual(layer.NumberOf(3), 0)
        XCTAssertEqual(layer.NumberOf(1), 6)
        XCTAssertEqual(layer.NumberOf(2), 3)
    }

    static var allTests = [
        ("testFromString", testFromString),
        ("testNumberOf", testNumberOf),
    ]
}
