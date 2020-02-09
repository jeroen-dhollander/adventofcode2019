import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(adventofcodeTests.allTests),
        testCase(fuelcalculatorTests.allTests),
        testCase(cpuTests.allTests),
        testCase(crossingwiresTests.allTests),
    ]
}
#endif
