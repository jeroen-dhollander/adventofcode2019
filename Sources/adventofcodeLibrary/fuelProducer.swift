

public class FuelProducer {

    private let reactionsByName : [String:Reaction]

    private var availableComponents : [String:Int] = [:]
    public var consumedOre : Int = 0
    public var producedFuel : Int = 0

    public static func create(_ formulas: [String]) -> FuelProducer {
        return FuelProducerbuilder(formulas).build()
    }

    init(_ reactionsByName: [String:Reaction]) {
        self.reactionsByName = reactionsByName
    }

    public func produceFuel(quantity: Int) {
        consume("FUEL", quantity:quantity)
        producedFuel += quantity
    }

    public func calculateRequiredOre() -> Int {
        consume("FUEL", quantity:1)
        return consumedOre
    }

    // Consume |quantity| instances of |name|.
    // This will first check the available stock,
    // and produce more if the stock is insufficient.
    func consume(_ name: String, quantity: Int) 
    {
        if quantityInStock(of:name) < quantity {
            // DNP test
            let missing = quantity - quantityInStock(of:name)
            produceMore(of:name, quantity: missing)
        }

        takeFromStock(name, quantity:quantity)
        return

    }

    func produceMore(of name: String, quantity: Int) {
        Logger.Info("We need to produce \(quantity) more \(name).")
        // DNP horrible name!
        if name == "ORE" {
            consumedOre += quantity
            addToStock("ORE", quantity:quantity)
            return
        }

        let reaction = reactionsByName[name]!
        let num_reactions = DivideAndRoundUp(quantity, reaction.result.quantity)
        Logger.Info("For \(quantity) \(name) we need \(num_reactions) reactions")

        for component in reaction.components {
            consume(component.name,
                    quantity:component.quantity * num_reactions)
        }

        addToStock(reaction.result.name,
                   quantity:reaction.result.quantity * num_reactions)
    }

    func quantityInStock(of name: String) -> Int {
        return availableComponents[name] ?? 0
    }

    func addToStock(_ name: String, quantity: Int) {
        availableComponents[name] = quantityInStock(of:name) + quantity
        Logger.Info("Added \(quantity) \(name) to the stock -> It now contains \(quantityInStock(of:name)).")
    }

    func takeFromStock(_ name: String, quantity: Int) {
        assert(quantityInStock(of:name) >= quantity, "Needed \(quantity) \(name)")
        Logger.Info("Taking \(quantity) \(name) from the stock.")
        availableComponents[name] = quantityInStock(of:name) - quantity
    }
}

struct Reaction {
    typealias Component = (name:String, quantity:Int)

    let result : Component
    let components : [Component]
}

fileprivate class FuelProducerbuilder {

    var reactionsByName : [String:Reaction] = [:]
    let formulas : [String]

    init(_ formulas: [String]) {
        self.formulas = formulas
    }

    func build() -> FuelProducer {
        buildReactions()
        return FuelProducer(reactionsByName)
    }

    func buildReactions() {

        for formula in formulas {
            buildReaction(formula)
        }
    }

    func buildReaction(_ formula: String) {
        let (all_components, result) = formula.splitAround(separator:" => ")!
        let components = all_components.components(separatedBy: ", ")

        let reaction = Reaction(
            result: toComponent(result)!,
            components: Array(components.map{ toComponent($0) })
        )

        reactionsByName[reaction.result.name] = reaction
    }

    // Translates "1 FUEL" in Reaction.Component("FUEL", 1)
    func toComponent(_ string: String ) -> Reaction.Component! {
        return string.splitAround(separator: " ").map{
            Reaction.Component(name:$1, quantity:Int($0)!)
        }
    }
}

extension String {
    func splitAround(separator: String) -> (left:String, right:String)? {
        let components = self.components(separatedBy: separator)
        if components.count != 2 {
            return nil
        }
        return (components[0], components[1])
    }
}
