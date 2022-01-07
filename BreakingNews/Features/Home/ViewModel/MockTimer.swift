
import Foundation

class MockTimer: Timer {
    
    var block: ((Timer) -> Void)?
    
    static var currentTimer = MockTimer()

    override func fire() {
        block?(self)
    }
    
    override open class func scheduledTimer(withTimeInterval interval: TimeInterval,
                                            repeats: Bool,
                                            block: @escaping (Timer) -> Void) -> Timer {
        currentTimer.block = block
        return currentTimer
    }
}