import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(adventofcodeTests.allTests),
        testCase(fuelcalculatorTests.allTests),
        testCase(cpuTests.allTests),
        testCase(crossingwiresTests.allTests),
        testCase(distanceTests.allTests),
        testCase(countOrbitsTests.allTests),
        testCase(permutationsTests.allTests),
        testCase(amplifierTests.allTests),
        testCase(imageTests.allTests),
        testCase(astroidMapTests.allTests),
        testCase(mathTests.allTests),
        testCase(paintingRobotTests.allTests),
        testCase(nBodiesTests.allTests),
        testCase(arcadeTests.allTests),
    ]
}
#endif
