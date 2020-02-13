
public class Permutations {

    public init() {}

    // Returns all permutations of the given values.
    // For example, Permutations.Of([1, 3, 6]) returns
    //      [
    //          [1, 3, 6], [1, 6, 3],
    //          [3, 1, 6], [3, 6, 1],
    //          [6, 1, 3], [6, 3, 1],
    //      ]
    public func Of(_ values: [Int]) -> [[Int]] {
        if values.count == 1 {
            return [values]
        }

        let subarrays = Of(Array(values.dropFirst()))

        let new_value = values[0]

        var result : [[Int]] = []
        for subarray in subarrays {
            for position in 0...subarray.count {
                result.append(
                    InsertAtPosition(new_value, in:subarray, position:position)
                )
            }
        }
        return result.sorted{$0.lexicographicallyPrecedes($1)}
    }

    // Returns all permutations of the given length,
    // containing the numbers 0..<length.
    // For example, Permutations.OfLength(2) returns
    //      [
    //          [0, 1],
    //          [1, 0],
    //      ]
    public func OfLength(_ length: Int) -> [[Int]] {
        let values = Array(0..<length)
        return Of(values)
    }

    func InsertAtPosition(_ value:Int, in array:[Int], position:Int) -> [Int] {
        return [] + array[0..<position] + [value] + array[position..<array.count]
    }

}
