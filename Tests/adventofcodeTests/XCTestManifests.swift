import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(adventofcodeTests.allTests),
        testCase(fuelcalculatorTests.allTests),
        testCase(intcodeTests.allTests),
        testCase(crossingwiresTests.allTests),
    ]
}
#endif
