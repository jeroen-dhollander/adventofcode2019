
public typealias Object = String

public class UniverseMapBuilder {

    // For each object this answers the question what other object it is orbitting
    var parentOf : [Object:Object] = [:]

    var orbits: [String]

    public init(_ orbits: [String]) {
        self.orbits = orbits
    }

    public func Build() -> UniverseMap? {
        do {
            try TryToBuild()
            return UniverseMap(parentOf)
        } catch {
            print("Got error: \(error)")
            return nil
        }
    }

    func TryToBuild() throws {
        for orbit in orbits {
            try AddOrbit(orbit)
        }
    }

    private func AddOrbit(_ orbit: String) throws {
        let (center, object) = try SplitOrbit(orbit)
        try AddOrbit(center:center, object:object)
    }

    private func AddOrbit(center: Object, object: Object) throws {
        parentOf[object] = center
    }

    private func SplitOrbit(_ orbit: String) throws -> (center:Object, object:Object) {
        guard orbit.contains(")") else {
            throw "Invalid orbit '\(orbit)'"
        }
        let elements = orbit.split(separator:")", maxSplits:2)
        return (
            center:Object(elements[0]),
            object: Object(elements[1])
        )
    }

}

public class UniverseMap {

    // For each object this answers the question what other object it is orbitting
    var parentOf : [Object:Object] = [:]

    public static func CountOrbits(orbits:[String]) -> Int? {
        let mapMaybe = UniverseMapBuilder(orbits).Build()
        if let map = mapMaybe {
            return map.CountAllOrbits()
        }
        return nil
    }

    init(_ parentOf: [Object:Object]) {
        self.parentOf = parentOf
    }

    func CountAllOrbits() -> Int {
        return parentOf.keys
            .map(DistanceToCOM)
            .reduce(0, { $0 + $1 })
    }

    public func CountOrbitalTransfersBetween(_ start: Object, _ end: Object) -> Int {
        assert(!IsAncestorOf(start, child:end))
        return DistanceBetween(parentOf[start]!, parentOf[end]!) - 2
    }

    func DistanceBetween(_ start: Object, _ end: Object) -> Int {
        if start == end {
            return 0
        }
        if IsAncestorOf(end, child:start) {
            return DistanceToAncestor(start:start, ancestor:end)
        }
        else {
            let parent = parentOf[end]
            assert(parent != nil)
            return 1 + DistanceBetween(start, parent!)
        }
    }

    func DistanceToCOM(_ object: Object) -> Int {
        return DistanceToAncestor(start: object, ancestor: "COM")
    }

    func IsAncestorOf(_ ancestor: Object, child: Object) -> Bool {
        guard let parent = parentOf[child]  else {
            return false
        }
        if ancestor == parent {
            return true
        }

        return IsAncestorOf(ancestor, child: parent)
    }

    func DistanceToAncestor(start: Object, ancestor: Object) -> Int {
        if start == ancestor {
            return 0
        }
        let next = parentOf[start]
        assert(next != nil, "No parent found for \(start)")
        let next_distance = DistanceToAncestor(start:next!, ancestor: ancestor)
        return 1 + next_distance
    }

}
