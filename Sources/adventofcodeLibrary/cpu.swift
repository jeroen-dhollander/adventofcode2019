
public class Input {
    private var values : Stack<Int>

    public init(_ values: [Int] = []) {
        self.values = Stack<Int>(values)
    }

    func Read() throws -> Int {
        if let result = values.pop() {
            return result
        }
        throw "Reading input value that is not there"
    }

}

public class Output {
    private var values : [Int] = []

    func Write(_ value : Int) {
        values.append(value)
    }

    public func Get() -> [Int] {
        return values
    }

}

// Computer that processes a sequence of int-code operations.
// New operations are registered in |GetOperation| in |operations.swift|.
// Returns the memory content after execution concludes,
// or nil if the execution failed (error reason is printed to stdout).
public class Cpu {

    private var memory: MemoryImpl
    private var output = Output()

    public init(_ initialMemory: [Int]) {
        memory = MemoryImpl(initialMemory)
    }


    // DNP explain
    // Run the program loaded in memory, using the given input.
    // Returns the output written by the memory, or nil if the memory could not be executed.
    public func Run(input: Input) -> Output? {
        do {
            let _ = try tryToRun(input:input)
            return output
        } catch {
            print("Got error: \(error)")
            return nil
        }
    }

    // Run the program loaded in memory, and return the memory after execution
    // is completed. Returns nil if the memory could not be executed.
    public func Run() -> [Int]? {
        do {
            return try tryToRun(input:Input())
        } catch {
            print("Got error: \(error)")
            return nil
        }
    }

    func tryToRun(input: Input) throws-> [Int]? {
        while true {
            let operation = try GetNextOperation()
            let actions = try operation.Execute(memory, input:input)

            for action in actions {
                switch action {
                case .Stop:
                    return memory.Get()
                case .Advance(let offset):
                    try memory.Advance(offset)
                case .Write(let value, let address):
                    try memory.Write(value, at:address)
                case .Print(let value):
                    output.Write(value)
                case .JumpTo(let address):
                    try memory.JumpTo(address)
                }
            }
        }
    }

    func GetNextOperation() throws -> Operation {
        guard let opcode_and_parameter_mode = try? memory.Read() else {
            throw "Missing |stop| operation"
        }
        let opcode = opcode_and_parameter_mode % 100
        return try GetOperation(opcode:opcode)
    }

}
