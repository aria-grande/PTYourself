
import Foundation
import RealmSwift

class ModelManager {
    // MARK - for test
    static func convertURL(_ url:String) -> Data {
        return (try! Data(contentsOf: URL(string: url)!))
    }
    
    class func setSampleData() {
        let realm = try! Realm()

        if realm.objects(Root.self).count > 0 {
            print("data is already set, will not load the sample data")
            return
        }
        
        let body = Photo(date: Date(), desc: "my beautiful body", data: UIImageJPEGRepresentation(UIImage(named: "running_woman.jpg")!, 0.7)!)
        let inbody = Photo(date: Date(), desc: "inbody result!", data: UIImageJPEGRepresentation(UIImage(named: "inbody_result.png")!, 0.7)!)
        let exercise1 = Exercise(name: "lunge 10 times", did: true)
        let exercise2 = Exercise(name: "squart 50 times", did: false)
        let exerciseList = List<Exercise>([exercise1, exercise2])
        
        try! realm.write {
            let root = realm.create(Root.self)
            root.bodyInformation = Body(height: 166.7, weight: 50.0)
            root.bodyHistoryPhotos = Album(inbody: inbody, body: body)
            root.addExercise(exercise1)
            root.addExercise(exercise2)
            root.addRecord(Record(date: Util.getTodayDate(), memo: "Test memo", missionCompleteRate: 50, exerciseList: exerciseList))
            root.addRecord(Record(date: Util.getYesterdayDate(), memo: "Test memo", missionCompleteRate: 50, exerciseList: exerciseList))
        }
    }
    
    // MARK - real code starts
    
    private static let realm = try! Realm()
    private static var data = Root()
    
    static func getData() -> Root {
        data = realm.objects(Root.self).first!
        return data
    }
    
    static func getExerciseList() -> List<Exercise> {
        return data.exerciseList
    }
    
    static func getMissionCompleteRates() -> Array<Float> {
        return data.records.sorted(by: {$0.date < $1.date}).map({Float($0.missionCompleteRate)})
    }
    
    static func getRecordsDate() -> [String] {
        return data.records.sorted(by: {$0.date < $1.date}).map({($0.date as NSString).substring(with: NSRange(location: 8, length: 2))})
    }
    
    static func removeAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    static func addInbodyPhoto(_ photo:Photo) {
        try! realm.write {
            data.bodyHistoryPhotos?.addInbodyPhoto(photo)
        }
    }
    
    static func removeBodyPhoto(_ photo:Photo) {
        try! realm.write {
            data.bodyHistoryPhotos?.removeBodyPhoto(photo)
        }
    }
    
    static func removeInbodyPhoto(_ photo:Photo) {
        try! realm.write {
            data.bodyHistoryPhotos?.removeInbodyPhoto(photo)
        }
    }
    
    static func addBodyPhoto(_ photo:Photo) {
        try! realm.write {
            data.bodyHistoryPhotos?.addBodyPhoto(photo)
        }
    }
    
    static func writeBodyInformation(_ bodyInfo:Body) {
        try! realm.write {
            data.bodyInformation = bodyInfo
        }
    }
    
    static func updatePhotoDescription(_ photoType:PhotoType, photo:Photo, newDesc:String) {
        try! realm.write {
            var photos = List<Photo>()
            if photoType == PhotoType.body {
                photos = (self.data.bodyHistoryPhotos?.body)!
            }
            else if photoType == PhotoType.inbody {
                photos = (self.data.bodyHistoryPhotos?.inbody)!
            }
            
            if let photo = photos.filter("data=%@",photo.data).filter("desc=%@",photo.desc).filter("date=%@",photo.date).first {
                photo.desc = newDesc   
            }
        }
    }
    
    static func updateTodayRecordMissionComplete() {
        try! realm.write {
            if let todayRecord:Record = data.records.filter("date=%@", Util.getTodayDate()).first {
                todayRecord.missionCompleteRate = Util.calculateMissionCompleteRate(todayRecord.exerciseList)
            }
        }
    }
    
    static func updateRecord(_ record:Record, memo:String, missionCompleteRate:Int, exerciseDict:[String:Bool]) {
        try! realm.write {
            record.memo = memo
            record.missionCompleteRate = missionCompleteRate
            record.updateExerciseRecord(exerciseDict)
        }
    }
    
    static func addRecord(_ record:Record) {
        try! realm.write {
            data.records.append(record)
        }
    }
    
    static func deleteExerciseFromTodayRecord(_ name:String) {
        try! realm.write {
            var todayExerciseList = data.records.filter("date=%@", Util.getTodayDate()).first?.exerciseList
            if let exercise:Exercise = todayExerciseList?.filter("name=%@", name).first {
                todayExerciseList?.remove(at: todayExerciseList!.index(of: exercise)!)
            }
        }
    }
    
    static func addExerciseToList(_ name:String) {
        try! realm.write {
            data.addExercise(Exercise(name: name, did: false))
        }
    }
    
    static func findExerciseBy(_ name: String) -> Exercise? {
        let rs = getExerciseList().filter("name = \(name)")
        return rs.isEmpty ? nil : rs.first!
    }
    
    static func updateExercise(exercise:Exercise, newName:String) {
        try! realm.write {
            exercise.name = newName
        }
    }
    
    static func deleteExerciseFromList(_ index:Int) {
        try! realm.write {
            data.exerciseList.remove(at: index)
        }
    }
}
