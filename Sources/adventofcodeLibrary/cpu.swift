
public protocol Input {
    mutating func Read() throws -> Int 
}

// For ease of using we allow an [Int] as input
extension Array : Input where Element == Int {
    mutating public func Read() throws -> Int {
        guard !self.isEmpty else {
            throw "Reading from an empty Input"
        }
        return self.removeFirst()
    }
}

public protocol Output {
    mutating func Write(_ value: Int)
}

// For ease of using we allow an [Int] as output
extension Array : Output where Element == Int {

    mutating public func Write(_ value: Int) {
        self.append(value)
    }

}

// Computer that processes a sequence of int-code operations.
// New operations are registered in |GetOperation| in |operations.swift|.
// Returns the memory content after execution concludes,
// or nil if the execution failed (error reason is printed to stdout).
public class Cpu {

    private var memory: MemoryImpl
    public var name: String

    public init(_ initialMemory: [Int], name: String = "<cpu>") {
        memory = MemoryImpl(initialMemory)
        self.name = name
    }

    // Run the program loaded in memory, and returns |true| if it executed
    // successfully.
    public func Run(input: inout Input, output: inout Output) -> Bool {
        do {
            let _ = try tryToRun(input:&input, output: &output)
            return true
        } catch {
            print("Got error: \(error)")
            return false
        }
    }

    // Run the program loaded in memory, and return the memory after execution
    // is completed. Returns nil if the memory could not be executed.
    public func Run() -> [Int]? {
        var input : Input = []
        var output : Output = []
        guard Run(input:&input, output: &output) else {
            return nil
        }
        return memory.Get()
    }

    func tryToRun(input: inout Input, output: inout Output) throws-> [Int]? {
        while true {
            let operation = try GetNextOperation()
            print("CPU \(name): Executing operation \(operation)")
            let actions = try operation.Execute(memory, input:&input)

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
