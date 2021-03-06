import XCTest
@testable import adventofcodeLibrary

final class fuelProducerTests: XCTestCase {

    func runTests() throws {
        let testcases = [
            ("Basic case",
             formulas: [
                "2 ORE => 1 FUEL",
                ],
             expected: 2
            ),
            ("One indirection",
             formulas: [
                "1 A => 1 FUEL",
                "2 ORE => 1 A",
                ],
             expected: 2
            ),
            ("One formula creates multiple results",
             formulas: [
                "2 A => 1 FUEL",
                "2 ORE => 2 A",
                ],
             expected: 2
            ),
            ("Sometimes we need to create more components than we really need",
             formulas: [
                "5 A => 1 FUEL",
                "2 ORE => 3 A",
                ],
             expected: 4
            ),
            ("Reactions can use leftovers of other reactions",
             formulas: [
                "10 ORE => 10 A",
                "1 A => 1 B",
                "5 A, 5 B => 1 FUEL",
                ],
             expected: 10
            ),
            ("Reactions consume their resources",
             formulas: [
                "1 ORE => 1 A",
                "1 A => 1 B",
                "1 A, 1 B => 1 FUEL",
                ],
             expected: 2
            ),
            ("Example from task",
             formulas: [
                "10 ORE => 10 A",
                "1 ORE => 1 B",
                "7 A, 1 B => 1 C",
                "7 A, 1 C => 1 D",
                "7 A, 1 D => 1 E",
                "7 A, 1 E => 1 FUEL",
                ],
             expected: 31
            ),
            ("Example from task",
             formulas: [
                "9 ORE => 2 A",
                "8 ORE => 3 B",
                "7 ORE => 5 C",
                "3 A, 4 B => 1 AB",
                "5 B, 7 C => 1 BC",
                "4 C, 1 A => 1 CA",
                "2 AB, 3 BC, 4 CA => 1 FUEL",
                ],
             expected: 165
            ),
            ("Example from task",
             formulas: [
                "171 ORE => 8 CNZTR",
                "7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL",
                "114 ORE => 4 BHXH",
                "14 VRPVC => 6 BMBT",
                "6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL",
                "6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT",
                "15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW",
                "13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW",
                "5 BMBT => 4 WPTQ",
                "189 ORE => 9 KTJDG",
                "1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP",
                "12 VRPVC, 27 CNZTR => 2 XDBXC",
                "15 KTJDG, 12 BHXH => 5 XCVML",
                "3 BHXH, 2 VRPVC => 7 MZWV",
                "121 ORE => 7 VRPVC",
                "7 XCVML => 6 RJRHP",
                "5 BHXH, 4 VRPVC => 5 LTCX",
                ],
             expected: 2210736
            ),
        ]

        for (testName, formulas, expected) in testcases {
            let actual = FuelProducer.create(formulas).calculateRequiredOre()
            XCTAssertEqual(expected, actual, "Failure for test \(testName)")
        }
    }


    static var allTests = [
        ("runTests", runTests),
    ]
}
