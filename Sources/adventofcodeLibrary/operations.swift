
enum Action {
    case Stop
    case Advance(_ offset:Int)
    case Write(_ value:Int, at:Int)
}

// Operations that can be executed by the IntCode computer.
// Register all new operations in GetOperation below.
protocol Operation {
    func Execute(_ memory: Memory) throws -> [Action]
}

class Addition : Operation {
    static let opcode = 1

    func Execute(_ memory: Memory) throws -> [Action] {
        let value1 = try memory.Dereference(offset:+1)
        let value2 = try memory.Dereference(offset:+2)
        let destination = try memory.Read(offset:+3)
        return [
            Action.Write(value1+value2, at:destination),
            Action.Advance(4),
        ]
    }
}

class Multiplication : Operation {
    static let opcode = 2

    func Execute(_ memory: Memory) throws -> [Action] {
        let value1 = try memory.Dereference(offset:+1)
        let value2 = try memory.Dereference(offset:+2)
        let destination = try memory.Read(offset:+3)
        return [
            Action.Write(value1*value2, at:destination),
            Action.Advance(4),
        ]
    }
}

class Stop : Operation {
    static let opcode = 99

    func Execute(_ memory: Memory) throws -> [Action] {
        return [Action.Stop]
    }
}

// Allow us to throw strings as errors.
extension String: Error{}

func GetOperation(opcode: Int) throws -> Operation {
    let operation_builders : [Int:Operation] = [
        Addition.opcode: Addition(),
        Multiplication.opcode: Multiplication(),
        Stop.opcode: Stop(),
    ]

    if let operation = operation_builders[opcode] {
        return operation
    }else {
        throw "Invalid opcode \(opcode)"
    }

}
