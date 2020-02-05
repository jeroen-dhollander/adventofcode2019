
public class FuelCalculator {

    public init() {}

    public func calculate(_ mass: Int) -> Int {
        if mass==0 {
            return 0
        }
        let fuel_for_mass = max(mass/3 - 2, 0)
        let fuel_for_fuel = calculate(fuel_for_mass)
        return fuel_for_mass + fuel_for_fuel
    }

    public func calculateCombined(_ masses: [Int]) -> Int {
        return masses.map{ calculate($0) }.reduce(0, {$0+$1})
    }
}


