
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

    func HasDouble() -> Bool {
        var previous_value = Int.min
        var count = 0
        for index in 0..<digits.count {
            let new_value = digits[index]

            if new_value == previous_value {
                count += 1
            } else {
                if count == 2 {
                    return true
                }
                previous_value = new_value
                count = 1
            }
        }

        if count == 2 {
            return true
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
