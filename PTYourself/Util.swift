import RealmSwift
import Foundation

class Util {
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