
public class Image {

    private var width_ : Int
    private var height_ : Int
    private var layers_ : [Layer]

    public static func FromString(
        width: Int,
        height: Int,
        pixels:String) -> Image {

        return ImageBuilder(width:width, height:height).Build(pixels)
    }

    public init(width:Int, height:Int) {
        self.width_ = width
        self.height_ = height
        self.layers_ = []
    }

    public var width : Int { get { width_ } }
    public var height : Int { get { height_ } }
    public var layers : [Layer] { get { layers_ } }

    public func Render() -> [[Int]] {
        return ImageRenderer(self).Render()
    }

    func AddLayer(_ layer: Layer) {
        assert(layer.width == width)
        assert(layer.height == height)

        self.layers_.append(layer)
    }

}

public struct Layer {

    public var pixels : [[Int]]

    public var width : Int { return pixels[0].count }
    public var height : Int { return pixels.count }

    init(_ pixels: [[Int]]) { self.pixels = pixels }

    public var values : [Int] { return Array(pixels.joined()) }

    public func NumberOf(_ value: Int) -> Int {
        return values.filter{$0 == value}.count
    }
}

class ImageBuilder {

    var image : Image

    init(width: Int, height: Int) {
        image = Image(width:width, height:height)
    }

    func Build(_ pixels: String) -> Image {
        let pixels_per_layer = image.width * image.height
        assert(pixels.count % pixels_per_layer == 0)

        for substring in pixels.split(by: pixels_per_layer) {
            AddLayer(substring)
        }
        return image
    }

    func AddLayer(_ pixels: Substring) {
        var layer = Layer([])

        for row in pixels.split(by:image.width) {
            layer.pixels.append(row.map{Int(String($0))!})
        }

        image.AddLayer(layer)
    }
}

class ImageRenderer {

    var image : Image

    init(_ image: Image) {
        self.image = image
    }

    func Render() -> [[Int]] {
        var result : [[Int]] = []
        for row in 0..<image.height {
            result.append(RenderRow(row))
        }
        return result
    }

    func RenderRow(_ row: Int) -> [Int] {
        return Array(
            (0..<image.width).map {
                RenderPixel(row, $0)
            }
        )
    }

    func RenderPixel(_ row: Int, _ column: Int) -> Int {
        return image.layers
            .map{$0.pixels[row][column]}
            .filter{ $0 != 2 }
            .first!
    }


}

extension StringProtocol {
    func split(by length: Int) -> [SubSequence] {
        var startIndex = self.startIndex
        var results = [SubSequence]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results
    }
}

