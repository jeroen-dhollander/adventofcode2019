
enum MemoryError : Error {
    case Invalidaddress(_ address: Int)
}

protocol Memory{

    func Read(address: Int) throws -> Int
    func Read(offset: Int) throws -> Int 
    func Read() throws -> Int 

    // Read the value from the given address,
    // and use it as the address of another memory location. Return the value
    // from that memory location.
    // For example, calling |Dereference| for address 0 in
    //     [5, 111, 222, 333, 444, 555, 666]
    // will return 555, as address 0 points to address 5 which has value 555.
    func Dereference(address: Int) throws -> Int 
    func Dereference(offset: Int) throws -> Int 

}

class MemoryImpl : Memory {
    private var memory: [Int]
    private var current_address: Int

    init(_ memory:[Int]) {
        self.memory = memory
        self.current_address = 0
    }

    func Read(address: Int) throws -> Int {
        if address < 0 || address >= memory.count {
            throw MemoryError.Invalidaddress(address)
        }
        return memory[address]
    }

    func Read() throws -> Int { try Read(offset:0) }

    func Read(offset: Int) throws -> Int {
        return try Read(address: current_address+offset)
    }

    // Read the value from the given address,
    // and use it as the address of another memory location. Return the value
    // from that memory location.
    // For example, calling |Dereference| for address 0 in
    //     [5, 111, 222, 333, 444, 555, 666]
    // will return 555, as address 0 points to address 5 which has value 555.
    func Dereference(address: Int) throws -> Int {
        return try Read(address:Read(address:address))
    }

    func Dereference(offset: Int) throws -> Int {
        return try Dereference(address: current_address+offset)
    }

    func Write(_ value: Int, at address: Int) throws {
        try Check(address:address)
        memory[address] = value
    }

    func Write(_ value: Int, at_offset offset: Int) throws {
        try Write(value, at:current_address+offset)
    }

    func Advance(_ offset: Int)  throws{
        try JumpTo(current_address + offset)
    }

    func JumpTo(_ address: Int) throws {
        try Check(address:address)
        current_address = address
    }

    func Get() -> [Int] {
        return memory
    }

    func Check(address: Int) throws {
        if address < 0 || address >= memory.count {
            throw MemoryError.Invalidaddress(address)
        }
    }

}
