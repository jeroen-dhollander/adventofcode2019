

// Computer that processes a sequence of int-code operations.
// New operations are registered in |GetOperation| in |operations.swift|.
// Returns the memory content after execution concludes,
// or nil if the execution failed (error reason is printed to stdout).
public class IntCode {

    private var memory: Memory!

    public init() {
    }

    public func compute(_ initialMemory: [Int]) -> [Int]? {
        do {
            return try tryToCompute(initialMemory)
        } catch {
            print("Got error: \(error)")
            return nil
        }
    }

    func tryToCompute(_ initialMemory: [Int]) throws-> [Int]? {
        memory = Memory(initialMemory)

        while true {
            let operation = try GetNextOperation()
            let action = try operation.Execute(memory)

            switch action {
                case .Stop:
                    return memory.Get()
                case .Advance(let offset):
                    memory.Advance(offset)
            }
        }
    }

    func GetNextOperation() throws -> Operation {
        let opcode = try memory.Read()
        return try GetOperation(opcode:opcode)
    }

}
