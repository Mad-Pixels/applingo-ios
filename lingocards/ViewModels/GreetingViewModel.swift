import SwiftUI

class GreetingViewModel: ObservableObject {
    @Published private(set) var greeting: Greeting
    
    init() {
        self.greeting = Greeting(message: "Hello, World!")
    }
    
    func logGreeting(logger: LoggerProtocol) {
        logger.log("Hello world view", level: .info)
    }
}
