
enum ParameterMode {
    case Position
    case Immediate
}

// Helper method to read the n-th argument of the current instruction.
// This will resolve the parameter-mode.
class ArgumentReader {

    var memory: Memory

    init(_ memory: Memory) {
        self.memory = memory
    }

    func Get(_ argument_index:Int) throws -> Int {
        switch try GetParameterMode(argument_index) {
        case .Position:
            return try memory.Dereference(offset:argument_index)
        case .Immediate:
            return try memory.Read(offset:argument_index)
        }
    }

    // Reads the given argument as a (destination) address.
    func GetAddress(_ argument_index:Int) throws -> Int {
        return try memory.Read(offset:argument_index)
    }


    private func GetParameterMode(_ argument_index:Int) throws -> ParameterMode {
        let opcode_and_parameter_mode = try memory.Read()
        let parameter_mode = opcode_and_parameter_mode / 100

        switch GetNthDigit(parameter_mode, n:argument_index) {
        case 0:
            return ParameterMode.Position
        case 1:
            return ParameterMode.Immediate
        case let x:
            throw "Invalid parameter mode \(x)"
        }
    }

    private func GetNthDigit(_ value: Int, n: Int) -> Int {
        var result = value
        for _ in 1..<n {
            result /= 10
        }
        return result % 10
    }

}
