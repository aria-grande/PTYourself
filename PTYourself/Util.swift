import RealmSwift
import Foundation

class Util {
    private static let todayDateTime = NSDate()
    static var format = NSDateFormatter()
    
    static func getYYYYMMDD(dateTime:NSDate) -> String {
        format.dateFormat = "yyyy-MM-dd"
        return format.stringFromDate(dateTime)
    }

    static func getYesterdayDate() -> String {
        format.dateFormat = "yyyy-MM-dd";
        return format.stringFromDate(todayDateTime.dateByAddingTimeInterval(-60*60*24))
    }
    
    static func getTodayDate() -> String {
        return getYYYYMMDD(NSDate())
    }
    
    
    static func getCountOfDoneExercises(exerciseList:[String:Bool]) -> Int {
        return exerciseList.filter { $1 == true }.count
    }
    
    static func getCountOfDoneExercises(exerciseList:List<Exercise>) -> Int {
        return exerciseList.filter("did=%@", true).count
    }
    
    static func calculateMissionCompleteRate(exerciseList:List<Exercise>) -> Int {
        return Int(100*getCountOfDoneExercises(exerciseList)/exerciseList.count)
    }
    
    static func calculateMissionCompleteRate(exerciseList:[String:Bool]) -> Int {
        return Int(100*getCountOfDoneExercises(exerciseList)/exerciseList.count)
    }
}
