import Foundation
import RealmSwift

class Photo:Object {
    dynamic var date:NSDate = NSDate()
    dynamic var desc:String = ""
    dynamic var src:String = ""
    
    convenience init(date:NSDate, desc:String, src:String) {
        self.init()
        self.date = date
        self.desc = desc
        self.src = src
    }
//    func getDate() -> NSDate {
//        return self.date
//    }
//    
//    func getDesc() -> String {
//        return self.description
//    }
//    
//    func getSrc() -> String {
//        return self.src
//    }
}
