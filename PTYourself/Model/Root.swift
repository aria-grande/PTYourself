import Foundation
import RealmSwift

class Root:Object {
    
    dynamic var bodyInformation:Body? = Body()
    dynamic var bodyHistoryPhotos:Album? = Album()
    var exerciseList:List<Exercise> = List()
    var records:List<Record> = List()
    
    static let sharedInstance = Root()
  
    func addExercise(_ exercise:Exercise) {
        exerciseList.append(exercise)
    }
    
    func addRecord(_ record:Record) {
        records.append(record)
    }
}
