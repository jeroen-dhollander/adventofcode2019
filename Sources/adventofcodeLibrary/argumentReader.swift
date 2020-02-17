
enum ParameterMode {
    case Position
    case Immediate
    case Relative
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
            Logger.Verbose("Reading using position mode")
            return try memory.Dereference(offset:argument_index)
        case .Immediate:
            Logger.Verbose("Reading using immediate mode")
            return try memory.Read(offset:argument_index)
        case .Relative:
            let offset = try memory.Read(offset: argument_index)
            let address = memory.relative_base + offset
            Logger.Verbose("Reading using relative mode")
            return try memory.Read(address:address)
        }
    }

    // Reads the given argument as a (destination) address.
    func GetAddress(_ argument_index:Int) throws -> Int {
        switch try GetDestinationParameterMode(argument_index) {
        case .Position:
            assert(false)
        case .Immediate:
            return try memory.Read(offset:argument_index)
        case .Relative:
            let offset = try memory.Read(offset: argument_index)
            return memory.relative_base + offset
        }
    }

    private func Read(_ argument_index:Int, mode: ParameterMode) throws -> Int {
        switch mode {
        case .Position:
            return try memory.Dereference(offset:argument_index)
        case .Immediate:
            return try memory.Read(offset:argument_index)
        case .Relative:
            let offset = try memory.Read(offset: argument_index)
            let address = memory.relative_base + offset
            return try memory.Read(address:address)
        }
    }

    private func GetParameterMode(_ argument_index:Int) throws -> ParameterMode {
        switch try GetNthArgumentModeIntValue(argument_index) {
        case 0:
            return ParameterMode.Position
        case 1:
            return ParameterMode.Immediate
        case 2:
            return ParameterMode.Relative
        case let x:
            throw "Invalid parameter mode \(x)"
        }
    }

    private func GetDestinationParameterMode(_ argument_index:Int) throws -> ParameterMode {
        switch try GetNthArgumentModeIntValue(argument_index) {
        case 0:
            return ParameterMode.Immediate
        case 1:
            throw "Unsupported parameter mode 1 for destination parameter"
        case 2:
            return ParameterMode.Relative
        case let x:
            throw "Invalid parameter mode \(x)"
        }
    }

    private func GetNthArgumentModeIntValue(_ argument_index:Int) throws -> Int {
        let opcode_and_parameter_mode = try memory.Read()
        let parameter_mode = opcode_and_parameter_mode / 100

        return GetNthDigit(parameter_mode, n:argument_index)
    }

    private func GetNthDigit(_ value: Int, n: Int) -> Int {
        var result = value
        for _ in 1..<n {
            result /= 10
        }
        return result % 10
    }

}
