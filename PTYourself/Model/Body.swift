import Foundation
import RealmSwift

class Body:Object {
    dynamic var height:Double = 0
    dynamic var weight:Double = 0
    
    convenience init(height:Double, weight:Double) {
        self.init()
        self.height = height
        self.weight = weight
    }
}
