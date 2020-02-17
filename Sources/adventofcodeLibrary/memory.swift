
enum MemoryError : Error {
    case Invalidaddress(_ address: Int)
}

extension Array where Element == Int {

    mutating func EnlargeTo(_ size: Int, fill_with new_value : Int) {
        if self.count >= size {
            return
        }

        var new_array = Array(repeating: new_value, count: size)
        for i in 0..<self.count {
            new_array[i] = self[i]
        }

        self = new_array
    }

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

    var relative_base :Int { get }
}

class MemoryImpl : Memory {
    private var memory: [Int]
    private var current_address: Int
    public var relative_base: Int

    init(_ memory:[Int]) {
        self.memory = memory
        self.current_address = 0
        self.relative_base = 0
    }

    func Read(address: Int) throws -> Int {
        if address < 0 {
            throw MemoryError.Invalidaddress(address)
        }
        if address < memory.count {
            Logger.Verbose("Reading from address \(address) -> \(memory[address])")
            return memory[address]
        }
        Logger.Verbose("Reading from address \(address) -> \(0)")
        return 0
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
        memory.EnlargeTo(address+1, fill_with:0)
        memory[address] = value

        Logger.Verbose("Writing to address \(address) -> \(memory[address])")
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
        if address < 0 {
            throw MemoryError.Invalidaddress(address)
        }
    }

}
