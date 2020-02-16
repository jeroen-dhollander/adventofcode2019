import Foundation

class BlockingQueue<Element> {
    typealias Element = Element
    private var name_: String
    private var data: [Element] = []
    private let dataLock: DispatchQueue
    private let dataAvailable: DispatchSemaphore

    init(name: String = "<queue>") {
        self.name_ = name
        self.dataLock = DispatchQueue(label: "Data lock")
        self.dataAvailable = DispatchSemaphore(value: 0)
    }

    var name: String { get { return name_ } }

    func Add(_ e: Element) {
        dataLock.sync{
            data.append(e)
            dataAvailable.signal()
        }
    }

    func Get(block: Bool = true) -> Element? {
        let timeout = block ? DispatchTime.distantFuture : DispatchTime.now() 

        switch dataAvailable.wait(timeout: timeout) {
        case .success:
            return dataLock.sync{ return data.removeFirst(); }
        case .timedOut:
            return nil
        }
    }
}
