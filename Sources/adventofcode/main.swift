import adventofcodeLibrary

func CalculateFuelConsumption() -> Int {
    let masses = [
        127117, 121199, 80494, 83466, 125933, 80813,
        137787, 122687, 123256, 128013, 90525, 116909,
        95227, 86368, 96748, 131600, 101434, 98226,
        88614, 76871, 65553, 141639, 55075, 133494,
        149211, 51775, 139337, 94542, 76351, 100791,
        107426, 91462, 78691, 70162, 95006, 101280,
        59398, 77396, 66276, 100207, 67200, 58985,
        64763, 125001, 149661, 129085, 114919, 77844,
        108209, 121125, 54662, 103292, 112164, 121118,
        71847, 130912, 81068, 137253, 56703, 107683,
        108181, 142507, 112673, 97242, 50195, 123852,
        130090, 144719, 133862, 73461, 81374, 56574,
        147026, 140613, 148938, 123768, 64967, 106133,
        123961, 87190, 71348, 148830, 87261, 58942,
        132417, 101993, 94510, 138358, 72539, 80356,
        74249, 103109, 135176, 128635, 116062, 82975,
        135814, 62702, 80696, 95607, 
    ] 
    return FuelCalculator().calculateCombined(masses) 
}

func RunCpu() {
    var memory = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,2,6,19,23,1,23,5,27,1,27,13,31,2,6,31,35,1,5,35,39,1,39,10,43,2,6,43,47,1,47,5,51,1,51,9,55,2,55,6,59,1,59,10,63,2,63,9,67,1,67,5,71,1,71,5,75,2,75,6,79,1,5,79,83,1,10,83,87,2,13,87,91,1,10,91,95,2,13,95,99,1,99,9,103,1,5,103,107,1,107,10,111,1,111,5,115,1,115,6,119,1,119,10,123,1,123,10,127,2,127,13,131,1,13,131,135,1,135,10,139,2,139,6,143,1,143,9,147,2,147,6,151,1,5,151,155,1,9,155,159,2,159,6,163,1,163,2,167,1,10,167,0,99,2,14,0,0]

    for noun in 0...99 {
        for verb in 0...99 {
            memory[1] = noun
            memory[2] = verb

            let result = Cpu(memory).Run()!
            if result[0] == 19690720 {
                print("Noun: \(noun), Verb: \(verb) --> \(100*noun+verb)")
                return
            }
        }
    }
    print("ERROR ERROR NO SOLUTION FOUND")
}

func Day5() {
    let memory = [3,225,1,225,6,6,1100,1,238,225,104,0,1001,92,74,224,1001,224,-85,224,4,224,1002,223,8,223,101,1,224,224,1,223,224,223,1101,14,63,225,102,19,83,224,101,-760,224,224,4,224,102,8,223,223,101,2,224,224,1,224,223,223,1101,21,23,224,1001,224,-44,224,4,224,102,8,223,223,101,6,224,224,1,223,224,223,1102,40,16,225,1102,6,15,225,1101,84,11,225,1102,22,25,225,2,35,96,224,1001,224,-350,224,4,224,102,8,223,223,101,6,224,224,1,223,224,223,1101,56,43,225,101,11,192,224,1001,224,-37,224,4,224,102,8,223,223,1001,224,4,224,1,223,224,223,1002,122,61,224,1001,224,-2623,224,4,224,1002,223,8,223,101,7,224,224,1,223,224,223,1,195,87,224,1001,224,-12,224,4,224,1002,223,8,223,101,5,224,224,1,223,224,223,1101,75,26,225,1101,6,20,225,1102,26,60,224,101,-1560,224,224,4,224,102,8,223,223,101,3,224,224,1,223,224,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,108,677,226,224,102,2,223,223,1006,224,329,1001,223,1,223,1108,226,677,224,1002,223,2,223,1006,224,344,101,1,223,223,7,226,677,224,102,2,223,223,1006,224,359,1001,223,1,223,1007,226,677,224,1002,223,2,223,1006,224,374,1001,223,1,223,1108,677,226,224,102,2,223,223,1005,224,389,1001,223,1,223,107,226,226,224,102,2,223,223,1006,224,404,101,1,223,223,1107,226,226,224,1002,223,2,223,1005,224,419,1001,223,1,223,1007,677,677,224,102,2,223,223,1006,224,434,101,1,223,223,1107,226,677,224,1002,223,2,223,1006,224,449,101,1,223,223,107,677,677,224,102,2,223,223,1005,224,464,1001,223,1,223,1008,226,226,224,1002,223,2,223,1005,224,479,101,1,223,223,1007,226,226,224,102,2,223,223,1005,224,494,1001,223,1,223,8,677,226,224,1002,223,2,223,1005,224,509,1001,223,1,223,108,677,677,224,1002,223,2,223,1005,224,524,1001,223,1,223,1008,677,677,224,102,2,223,223,1006,224,539,1001,223,1,223,7,677,226,224,1002,223,2,223,1005,224,554,101,1,223,223,1108,226,226,224,1002,223,2,223,1005,224,569,101,1,223,223,107,677,226,224,102,2,223,223,1005,224,584,101,1,223,223,8,226,226,224,1002,223,2,223,1005,224,599,101,1,223,223,108,226,226,224,1002,223,2,223,1006,224,614,1001,223,1,223,7,226,226,224,102,2,223,223,1006,224,629,1001,223,1,223,1107,677,226,224,102,2,223,223,1005,224,644,101,1,223,223,8,226,677,224,102,2,223,223,1006,224,659,1001,223,1,223,1008,226,677,224,1002,223,2,223,1006,224,674,1001,223,1,223,4,223,99,226]
    let output = Cpu(memory).Run(input:Input([1]))
    print("output is \(output!.Get())")

}

func CrossingWiresIntersection() {
    let wire1=["R997","D443","L406","D393","L66","D223","R135","U452","L918","U354","L985","D402","R257","U225","R298","U369","L762","D373","R781","D935","R363","U952","L174","D529","L127","D549","R874","D993","L890","U881","R549","U537","L174","U766","R244","U131","R861","D487","R849","U304","L653","D497","L711","D916","R12","D753","R19","D528","L944","D155","L507","U552","R844","D822","R341","U948","L922","U866","R387","U973","R534","U127","R48","U744","R950","U522","R930","U320","R254","D577","L142","D29","L24","D118","L583","D683","L643","U974","L683","U985","R692","D271","L279","U62","R157","D932","L556","U574","R615","D428","R296","U551","L452","U533","R475","D302","R39","U846","R527","D433","L453","D567","R614","U807","R463","U712","L247","D436","R141","U180","R783","D65","L379","D935","R989","U945","L901","D160","R356","D828","R45","D619","R655","U104","R37","U793","L360","D242","L137","D45","L671","D844","R112","U627","R976","U10","R942","U26","L470","D284","R832","D59","R97","D9","L320","D38","R326","U317","L752","U213","R840","U789","L152","D64","L628","U326","L640","D610","L769","U183","R844","U834","R342","U630","L945","D807","L270","D472","R369","D920","R283","U440","L597","U137","L133","U458","R266","U91","R137","U536","R861","D325","R902","D971","R891","U648","L573","U139","R951","D671","R996","U864","L749","D681","R255","U306","R154","U706","L817","D798","R109","D594","R496","D867","L217","D572","L166","U723","R66","D210","R732","D741","L21","D574","L523","D646","R313","D961","L474","U990","R125","U928","L58","U726","R200","D364","R244","U622","R823","U39","R918","U549","R667","U935","R372","U241","L56","D713","L735","U735","L812","U700","L408","U980","L242","D697","L580","D34","L266","U190","R876","U857","L967","U493","R871","U563","L241","D636","L467","D793","R304","U103","L950","D503","R487","D868","L358","D747","L338","D273","L485","D686","L974","D724","L534","U561","R729","D162","R731","D17","R305","U712","R472","D158","R921","U827","L944","D303","L526","D782","R575","U948","L401","D142","L48","U766","R799","D242","R821","U673","L120"]
    let wire2=["L991","D492","L167","D678","L228","U504","R972","U506","R900","U349","R329","D802","R616","U321","R252","U615","R494","U577","R322","D593","R348","U140","L676","U908","L528","D247","L498","D79","L247","D432","L569","U206","L668","D269","L25","U180","R181","D268","R655","D346","R716","U240","L227","D239","L223","U760","L10","D92","L633","D425","R198","U222","L542","D790","L596","U667","L87","D324","R456","U366","R888","U319","R784","D948","R641","D433","L519","U950","L689","D601","L860","U233","R21","D214","L89","U756","L361","U258","L950","D483","R252","U206","L184","U574","L540","U926","R374","U315","R357","U512","R503","U917","R745","D809","L94","D209","R616","U47","R61","D993","L589","D1","R387","D731","R782","U771","L344","U21","L88","U614","R678","U259","L311","D503","L477","U829","R861","D46","R738","D138","L564","D279","L669","U328","L664","U720","L746","U638","R790","D242","R504","D404","R409","D753","L289","U128","L603","D696","L201","D638","L902","D279","L170","D336","L311","U683","L272","U396","R180","D8","R816","D904","L129","D809","R168","D655","L459","D545","L839","U910","L642","U704","R301","D235","R469","D556","L624","D669","L174","D272","R515","D60","L668","U550","L903","D881","L600","D734","R815","U585","R39","D87","R198","D418","L150","D964","L818","D250","L198","D127","R521","U478","L489","D676","L84","U973","R384","D167","R372","D981","L733","D682","R746","D803","L834","D421","R153","U752","L381","D990","R216","U469","L446","D763","R332","D813","L701","U872","L39","D524","L469","U508","L700","D382","L598","U563","R652","D901","R638","D358","L486","D735","L232","U345","R746","U818","L13","U618","R881","D647","R191","U652","R358","U423","L137","D224","R415","U82","R778","D403","R661","D157","R393","D954","L308","D986","L293","U870","R13","U666","L232","U144","R887","U364","L507","U520","R823","D11","L927","D904","R618","U875","R143","D457","R459","D755","R677","D561","L499","U267","L721","U274","L700","D870","L612","D673","L811","D695","R929","D84","L578","U201","L745","U963","L185","D687","L662","U313","L853","U314","R336"]
    let distance = CrossingWires().GetDistanceToFirstIntersection(wire1:wire1, wire2:wire2)!
    print("The wires cross at distance \(distance)")
}

func BreakPassword() {
    let valid_passwords = PasswordBreaker().GetValidPasswordInRange(382345, to:843167)

    for password in valid_passwords {
        print(" --> \(password)")
    }
    print("There are \(valid_passwords.count) valid password")
}

//print("We need \(CalculateFuelConsumption()) fuel")
//RunCpu()
//CrossingWiresIntersection()
// BreakPassword()
Day5()
