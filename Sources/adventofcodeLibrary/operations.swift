
enum Action {
    // Stop execution
    case Stop
    // Advance the current memory address with the given offset.
    case Advance(_ offset:Int)
    // Write a value to the memory at the given address
    case Write(_ value:Int, at:Int)
    // Print a value to the output
    case Print(_ value:Int)
}

// Operations that can be executed by the IntCode computer.
// Register all new operations in GetOperation below.
protocol Operation {
    func Execute(_ memory: Memory, input:  Input) throws -> [Action]
}

class Addition : Operation {
    static let opcode = 1

    func Execute(_ memory: Memory, input:  Input) throws -> [Action] {
        let arguments = ArgumentReader(memory)
        let value1 = try arguments.Get(1)
        let value2 = try arguments.Get(2)
        let destination = try memory.Read(offset:+3)
        return [
            Action.Write(value1+value2, at:destination),
            Action.Advance(4),
        ]
    }
}

class Multiplication : Operation {
    static let opcode = 2

    func Execute(_ memory: Memory, input:  Input) throws -> [Action] {
        let arguments = ArgumentReader(memory)
        let value1 = try arguments.Get(1)
        let value2 = try arguments.Get(2)
        let destination = try memory.Read(offset:+3)
        return [
            Action.Write(value1*value2, at:destination),
            Action.Advance(4),
        ]
    }
}

class Read : Operation {
    static let opcode = 3

    func Execute(_ memory: Memory, input:  Input) throws -> [Action] {
        let address = try memory.Read(offset:+1)
        let value = try input.Read()
        return [
            Action.Write(value, at:address),
            Action.Advance(2),
        ]
    }
}

class Print : Operation {
    static let opcode = 4

    func Execute(_ memory: Memory, input:  Input) throws -> [Action] {
        let arguments = ArgumentReader(memory)
        let value = try arguments.Get(1)
        return [
            Action.Print(value),
            Action.Advance(2),
        ]
    }
}

class Stop : Operation {
    static let opcode = 99

    func Execute(_ memory: Memory, input:  Input) throws -> [Action] {
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
        Print.opcode: Print(),
        Read.opcode: Read(),
    ]

    if let operation = operation_builders[opcode] {
        return operation
    }else {
        throw "Invalid opcode \(opcode)"
    }

}
