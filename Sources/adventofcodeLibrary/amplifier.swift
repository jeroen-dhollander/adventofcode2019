import Foundation

// We use |BlockingQueue| both as |Input| and as |Output|
extension BlockingQueue : Input, Output where Element == Int {

    func Read() throws -> Int {
        print("Reading from queue \(self.name)")
        let result = self.Get()!
        print("Read value \(result) from queue \(self.name)")
        return result
    }

    func Write(_ value: Int) {
        print("Writing \(value) to queue \(self.name)")
        self.Add(value)
    }

}

public class Amplifier {
    private var cpus : [Cpu] = []
    private var queues : [BlockingQueue<Int>] = []
    private var inputs : [Input] = []
    private var outputs : [Output] = []
    private var dispatcher : DispatchQueue
    private var dispatchGroup : DispatchGroup

    public init(_ memories: [[Int]]) {
        self.dispatcher = DispatchQueue(label: "CPU dispatcher", attributes: .concurrent)
        self.dispatchGroup = DispatchGroup()
        self.cpus = CreateCpus(memories)
        self.queues = CreateQueues()
        self.inputs = CreateInputs(queues)
        self.outputs = CreateOutputs(queues)
    }

    public convenience init(num_cpus: Int, _ memory: [Int]) {
        self.init([[Int]](repeating: memory, count: num_cpus))
    }

    public func Run(inputs: [[Int]]) -> Int {
        SetInitialInput(inputs)
        RunAllCpus()
        WaitUntilAllCpusAreDone()
        return GetResult()

    }

    private func SetInitialInput(_ inputs: [[Int]]) {
        if !inputs.isEmpty {
            //assert(inputs.count == num_cpus)
            for (index, values) in inputs.enumerated() {
                for value in values {
                    queues[index].Add(value)
                }
            }
        }
    }

    private func RunAllCpus() {
        for i in 0..<num_cpus {
            self.dispatcher.async(group:dispatchGroup) { [self] in 
                self.RunCpu(i)
            }
        }

    }

    private func RunCpu(_ index: Int) {
        let cpu = self.cpus[index]
        var input = self.inputs[index]
        var output = self.outputs[index]
        print("Starting CPU \(cpu.name)")
        let success =  cpu.Run(input:&input, output:&output) 
        //assert(success, "Execution failed on CPU \(cpu.name)")
        print("CPU \(cpu.name) is done")
    }

    private func WaitUntilAllCpusAreDone() {
        self.dispatchGroup.wait()
        print("All CPUS are done")
    }

    private func GetResult() -> Int {
        let last_output = queues[0]
        guard let result = last_output.Get(block: false) else {
            fatalError( "No result printed to \(last_output.name)")
        }
        return result
    }

    private func CreateCpus(_ memories: [[Int]]) -> [Cpu] {
        var result : [Cpu] = []
        for (i, memory) in memories.enumerated() {
            result.append(Cpu(memory, name:String(i+1)))
        }
        return result
    }

    private func CreateQueues() -> [BlockingQueue<Int>] {
        var result : [BlockingQueue<Int>] = []
        for i in 0..<num_cpus {
            let name = "<input of cpu \(cpus[i].name)>"
            result.append(BlockingQueue<Int>(name:name))
        }
        return result
    }

    private func CreateInputs(_ queues: [BlockingQueue<Int>]) -> [Input]
    {
        // We simply use the queues as input
        return queues
    }

    private func CreateOutputs(_ inputs: [BlockingQueue<Int>]) -> [Output]
    {
        // The output of CPU N is passed to the input of CPU N+1,
        // so the output of CPU 1 feeds into the input of CPU 2
        let result = [] + inputs[1..<inputs.count] + [inputs.first!]  
        return result
    }

    private var num_cpus : Int { get { cpus.count } } 

}
