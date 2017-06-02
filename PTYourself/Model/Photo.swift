import Foundation
import RealmSwift

class Photo:Object {
    dynamic var date = Date()
    dynamic var desc = ""
    dynamic var data = Data()
    
    convenience init(date:Date, desc:String, data:Data) {
        self.init()
        self.date = date
        self.desc = desc
        self.data = data
    }
}
