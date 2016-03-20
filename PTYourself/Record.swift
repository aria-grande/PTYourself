/*
* used for graph
*
**/

import Foundation

class Record {
    private var date:NSDate
    private var memo:String
    private var missionCompleteRate:Int
    
    init(date:NSDate, missionCompleteRate:Int, memo:String) {
        self.date = date
        self.memo = memo
        self.missionCompleteRate = missionCompleteRate
    }
    
    func getMemo() -> String {
        return self.memo
    }
    
    func getDate() -> NSDate {
        return self.date
    }
    
    func getMissionCompleteRate() -> Int {
        return self.missionCompleteRate
    }
}
