
// FIFO queue
public struct Queue<T> {
    fileprivate var array : [T] = []

    init() {
    }

    init(_ values: [T]) {
        array = values
    }

    public var isEmpty: Bool {
        return array.isEmpty
    }

    public var count: Int {
        return array.count
    }

    public mutating func add(_ element: T) {
        array.append(element)
    }

    public mutating func get() -> T? {
        if isEmpty {
            return nil
        }
        return array.removeFirst()
    }
}
