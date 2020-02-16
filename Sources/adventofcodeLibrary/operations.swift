
enum Action {
    // Stop execution
    case Stop
    // Advance the current memory address with the given offset.
    case Advance(_ offset:Int)
    // Moves the current memory address to the given address.
    case JumpTo(address:Int)
    // Write a value to the memory at the given address
    case Write(_ value:Int, at:Int)
    // Print a value to the output
    case Print(_ value:Int)
}

// Operations that can be executed by the IntCode computer.
// Register all new operations in GetOperation below.
protocol Operation {
    func Execute(_ memory: Memory, input: inout Input) throws -> [Action]
}

class Addition : Operation {
    static let opcode = 1

    func Execute(_ memory: Memory, input: inout Input) throws -> [Action] {
        let arguments = ArgumentReader(memory)
        let value1 = try arguments.Get(1)
        let value2 = try arguments.Get(2)
        let destination = try arguments.GetAddress(3)
        return [
            Action.Write(value1+value2, at:destination),
            Action.Advance(4),
        ]
    }
}

class Multiplication : Operation {
    static let opcode = 2

    func Execute(_ memory: Memory, input: inout Input) throws -> [Action] {
        let arguments = ArgumentReader(memory)
        let value1 = try arguments.Get(1)
        let value2 = try arguments.Get(2)
        let destination = try arguments.GetAddress(3)
        return [
            Action.Write(value1*value2, at:destination),
            Action.Advance(4),
        ]
    }
}

class Read : Operation {
    static let opcode = 3

    func Execute(_ memory: Memory, input:inout Input) throws -> [Action] {
        let arguments = ArgumentReader(memory)
        let address = try arguments.GetAddress(1)
        let value = try input.Read()
        return [
            Action.Write(value, at:address),
            Action.Advance(2),
        ]
    }
}

class Print : Operation {
    static let opcode = 4

    func Execute(_ memory: Memory, input: inout Input) throws -> [Action] {
        let arguments = ArgumentReader(memory)
        let value = try arguments.Get(1)
        return [
            Action.Print(value),
            Action.Advance(2),
        ]
    }
}

class JumpIfTrue : Operation {
    static let opcode = 5

    func Execute(_ memory: Memory, input: inout Input) throws -> [Action] {
        let arguments = ArgumentReader(memory)
        let condition = try arguments.Get(1)
        let destination = try arguments.Get(2)

        if condition > 0 {
            return [ Action.JumpTo(address:destination) ]
        } else {
            return [ Action.Advance(3) ]
        }
    }
}

class JumpIfFalse : Operation {
    static let opcode = 6

    func Execute(_ memory: Memory, input: inout Input) throws -> [Action] {
        let arguments = ArgumentReader(memory)
        let condition = try arguments.Get(1)
        let destination = try arguments.Get(2)

        if condition == 0 {
            return [ Action.JumpTo(address:destination) ]
        } else {
            return [ Action.Advance(3) ]
        }
    }
}

class LessThan : Operation {
    static let opcode = 7

    func Execute(_ memory: Memory, input: inout Input) throws -> [Action] {
        let arguments = ArgumentReader(memory)
        let value1 = try arguments.Get(1)
        let value2 = try arguments.Get(2)
        let destination = try arguments.GetAddress(3)

        let result = (value1 < value2) ? 1 : 0

        return [ 
            Action.Write(result, at:destination),
            Action.Advance(4),
        ]
    }
}

class Equals : Operation {
    static let opcode = 8

    func Execute(_ memory: Memory, input: inout Input) throws -> [Action] {
        let arguments = ArgumentReader(memory)
        let value1 = try arguments.Get(1)
        let value2 = try arguments.Get(2)
        let destination = try arguments.GetAddress(3)

        let result = (value1 == value2) ? 1 : 0

        return [ 
            Action.Write(result, at:destination),
            Action.Advance(4),
        ]
    }
}
class Stop : Operation {
    static let opcode = 99

    func Execute(_ memory: Memory, input: inout Input) throws -> [Action] {
        return [Action.Stop]
    }
}


// Allow us to throw strings as errors.
extension String: Error{}

func GetOperation(opcode: Int) throws -> Operation {
    let operation_builders : [Int:Operation] = [
        Addition.opcode: Addition(),
        Multiplication.opcode: Multiplication(),
        Print.opcode: Print(),
        Read.opcode: Read(),
        JumpIfTrue.opcode: JumpIfTrue(),
        JumpIfFalse.opcode: JumpIfFalse(),
        LessThan.opcode: LessThan(),
        Equals.opcode: Equals(),
        Stop.opcode: Stop(),
    ]

    if let operation = operation_builders[opcode] {
        return operation
    }else {
        throw "Invalid opcode \(opcode)"
    }

}
