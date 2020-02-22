import adventofcodeLibrary
import Foundation

let bodies = [
    ("Body 1", Position(-7, -1, 6), Velocity(0, 0, 0)),
    ("Body 2", Position(6, -9, -9), Velocity(0, 0, 0)),
    ("Body 3", Position(-12, 2, -7), Velocity(0, 0, 0)),
    ("Body 4", Position(4, -17, -12), Velocity(0, 0, 0)),
]

func Day12() {
    let nBodies = NBodies(bodies)

    for _ in 0..<1000 {
        nBodies.advanceTime()
    }

    print("Energy is \(nBodies.energy)")
}

func SolveForDimension(_ dimension: SingleDimensionNBodies) {
    var previousStates : Set<[Int]> = []

    for day in 0..<Int.max {

        dimension.advanceTime()
        let state = dimension.positions + dimension.velocities

        if previousStates.contains(state) {
            print("This dimension repeats after \(day) days")
            return
        }

        previousStates.insert(state)

        if day % 100_000 == 0 {
            print("   Still looking after \(day) days")
        }
    }
}

func Day12Part2() {
    // This solution uses the fact that movement in each dimension (x, y, z)
    // is completely independent.
    // So we search the period of each dimension, and then (online)
    // we calculate the Lowest Common Multiple.
    // Without this it will take ages, as the answer is
    //     452,582,583,272,768
    let nBodies = NBodies(bodies)
    SolveForDimension(nBodies.x)
    SolveForDimension(nBodies.y)
    SolveForDimension(nBodies.z)
}

