import Foundation
import RealmSwift

class Exercise:Object {
    dynamic var name:String = ""
    dynamic var did:Bool = false
    
    convenience init(name:String, did:Bool) {
        self.init()
        self.name = name
        self.did = did
    }
//    func getName() -> String {
//        return self.name
//    }
//    
//    func getDid() -> Bool {
//        return self.did
//    }
}