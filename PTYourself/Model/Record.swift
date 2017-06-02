/*
* used for graph
*
**/

import Foundation
import RealmSwift

class Record:Object {
    dynamic var date:String = ""
    dynamic var memo:String = ""
    dynamic var missionCompleteRate:Int = 0
    let exerciseList = List<Exercise>()
    
    convenience init(date:String, memo:String, missionCompleteRate:Int) {
        self.init()
        self.date = date
        self.memo = memo
        self.missionCompleteRate = missionCompleteRate
        self.exerciseList.removeAll()
        self.exerciseList.append(objectsIn: ModelManager.getExerciseList())
    }
    
    convenience init(date:String, memo:String, missionCompleteRate:Int, exerciseList:List<Exercise>) {
        self.init()
        self.date = date
        self.memo = memo
        self.missionCompleteRate = missionCompleteRate
        self.exerciseList.removeAll()
        self.exerciseList.append(objectsIn: exerciseList)
    }
    
    func updateExerciseRecord(_ exerciseDict:[String:Bool]) {
        self.exerciseList.removeAll()
        for (name, did) in exerciseDict {
            self.exerciseList.append(Exercise(name:name, did:did))
        }
    }
    
    static func convert(_ exerciseDict:[String:Bool]) -> List<Exercise> {
        let list = List<Exercise>()
        for (name, did) in exerciseDict {
            list.append(Exercise(name: name, did: did))
        }
        return list
    }
}
