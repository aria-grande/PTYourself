import Foundation
import RealmSwift

class Photo:Object {
    dynamic var date = NSDate()
    dynamic var desc = ""
    dynamic var data = NSData()
    
    convenience init(date:NSDate, desc:String, data:NSData) {
        self.init()
        self.date = date
        self.desc = desc
        self.data = data
    }
}
