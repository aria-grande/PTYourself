import Foundation
import RealmSwift

class Root:Object {
    
    dynamic var bodyInformation:Body? = Body()
    dynamic var bodyHistoryPhotos:Album? = Album()
    let exerciseList:List<Exercise> = List()
    let records:List<Record> = List()
    
    static let sharedInstance = Root()
  
    func addExercise(exercise:Exercise) {
        exerciseList.append(exercise)
    }
    
    func addRecord(record:Record) {
        records.append(record)
    }
}