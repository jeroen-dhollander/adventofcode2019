import adventofcodeLibrary

func Day7() {
    let memory = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]

    func SolveForPhaseSettings(_ phase_settings:[Int]) -> Int {
        print("Phase settings: \(phase_settings)")
        var previous_output = 0
        for phase in phase_settings {
            let output = Cpu(memory).Run(input:Input([phase, previous_output])) 
            assert(output != nil)
            print("   CPU: Input \([phase, previous_output]) -> Output \(output!.Get())")

            previous_output = output!.Get()[0]
        }
        return previous_output
    }

    let possible_phase_settings = Permutations().OfLength(5)

    for phase_settings in possible_phase_settings {
        let thrust = SolveForPhaseSettings(phase_settings)
        print("\(phase_settings) --> \(thrust)")
    }
}

