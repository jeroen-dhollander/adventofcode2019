
func ToArray(_ number: Int) -> [Int] {
    var result : [Int] = []
    var remainder = number
    while remainder > 0 {
        result.append(remainder % 10)
        remainder = remainder / 10
    }
    return result.reversed()
}

class NumberChecker {

    let digits: [Int]

    init(_ number:Int) {
        digits = ToArray(number)
    }

    public func IsValid() -> Bool {
        return HasDouble() && IsAscending()

    }

    func IsAscending() -> Bool {
        for index in 1..<digits.count {
            if digits[index-1] > digits[index] {
                return false
            }
        }
        return true
    }

    func ValueOrMinusOne(index:Int) -> Int {
        if index < 0 || index >= digits.count {
            return -1
        }
        return digits[index]
    }

    func HasDouble() -> Bool {
        for index in 1..<digits.count {
            if digits[index-1] == digits[index] {
                if ValueOrMinusOne(index:index-2) != digits[index] {
                    if ValueOrMinusOne(index:index+1) != digits[index] {
                        return true
                    }
                }
            }
        }
        return false
    }
}

// Note: completely untested as I simply bruteforced this
public class PasswordBreaker {

    public init() {}

    public func GetValidPasswordInRange(_ start:Int, to end:Int) ->[Int] {

        func IsValid(_ number: Int) -> Bool {
            return NumberChecker(number).IsValid()
        }

        let range = 382345...843167
        return range.filter(IsValid)
    }

}
