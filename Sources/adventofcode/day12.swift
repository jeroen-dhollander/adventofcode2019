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

