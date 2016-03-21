import Foundation

class Body {
    private var height:Double
    private var weight:Double
    
    init() {
        self.height = 0
        self.weight = 0
    }
    
    init(height:Double, weight:Double) {
        self.height = height
        self.weight = weight
    }
    
    func getHeight() -> Double {
        return self.height
    }
    
    func getWeight() -> Double {
        return self.weight
    }
    /* TODO: fill */
    func getBMI() -> Double {
        return 0
    }
}
