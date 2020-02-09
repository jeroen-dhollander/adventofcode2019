

// Computer that processes a sequence of int-code operations.
// New operations are registered in |GetOperation| in |operations.swift|.
// Returns the memory content after execution concludes,
// or nil if the execution failed (error reason is printed to stdout).
public class Cpu {

    private var memory: MemoryImpl!

    public init() {
    }

    public func Run(_ initialMemory: [Int]) -> [Int]? {
        do {
            return try tryToRun(initialMemory)
        } catch {
            print("Got error: \(error)")
            return nil
        }
    }

    func tryToRun(_ initialMemory: [Int]) throws-> [Int]? {
        memory = MemoryImpl(initialMemory)

        while true {
            let operation = try GetNextOperation()
            let actions = try operation.Execute(memory)

            for action in actions {
                switch action {
                case .Stop:
                    return memory.Get()
                case .Advance(let offset):
                    memory.Advance(offset)
                case .Write(let value, let address):
                    try memory.Write(value, at:address)
                }
            }
        }
    }

    func GetNextOperation() throws -> Operation {
        let opcode = try memory.Read()
        return try GetOperation(opcode:opcode)
    }

}
