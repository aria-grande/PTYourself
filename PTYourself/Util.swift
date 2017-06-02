import RealmSwift
import Foundation

class Util {
    fileprivate static let todayDateTime = Date()
    static var format = DateFormatter()
    
    static func getYYYYMMDD(_ dateTime:Date) -> String {
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: dateTime)
    }

    static func getYesterdayDate() -> String {
        format.dateFormat = "yyyy-MM-dd";
        return format.string(from: todayDateTime.addingTimeInterval(-60*60*24))
    }
    
    static func getTodayDate() -> String {
        return getYYYYMMDD(Date())
    }
    
    
    static func getCountOfDoneExercises(_ exerciseList:[String:Bool]) -> Int {
        return exerciseList.filter { $1 == true }.count
    }
    
    static func getCountOfDoneExercises(_ exerciseList:List<Exercise>) -> Int {
        return exerciseList.filter("did=%@", true).count
    }
    
    static func calculateMissionCompleteRate(_ exerciseList:List<Exercise>) -> Int {
        return Int(100*getCountOfDoneExercises(exerciseList)/exerciseList.count)
    }
    
    static func calculateMissionCompleteRate(_ exerciseList:[String:Bool]) -> Int {
        return Int(100*getCountOfDoneExercises(exerciseList)/exerciseList.count)
    }
}
