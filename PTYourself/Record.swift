/*
* used for graph
*
**/

import Foundation
import RealmSwift

class Record:Object {
    dynamic var date:NSDate = NSDate()
    dynamic var memo:String = ""
    dynamic var missionCompleteRate:Int = 0
    
    convenience init(date:NSDate, memo:String, missionCompleteRate:Int) {
        self.init()
        self.date = date
        self.memo = memo
        self.missionCompleteRate = missionCompleteRate
    }
//    func getMemo() -> String {
//        return self.memo
//    }
//    
//    func getDate() -> NSDate {
//        return self.date
//    }
//    
//    func getMissionCompleteRate() -> Int {
//        return self.missionCompleteRate
//    }
}
