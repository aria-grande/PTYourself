
import Foundation
import RealmSwift

class ModelManager {
    // MARK - for test
    static func convertURL(url:String) -> NSData {
        return NSData(contentsOfURL: NSURL(string: url)!)!
    }
    static func setSampleData() {
        let realm = try! Realm()

        if realm.objects(Root.self).count > 0 {
            print(realm.objects(Root.self))
            return
        }
        
        let inbody = Photo(date: NSDate(), desc: "my beautiful body", data: convertURL("https://pub.chosun.com/editor/cheditor_new/attach/IE1KGC6OQPOPFN5JCWIB.jpg"))
        let body = Photo(date: NSDate(), desc: "inbody result!", data: convertURL("https://pub.chosun.com/editor/cheditor_new/attach/IE1KGC6OQPOPFN5JCWIB.jpg"))
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
        data = realm.objects(Root).first!
        return data
    }
    
    static func getExerciseList() -> List<Exercise> {
        return data.exerciseList
    }
    
    static func getMissionCompleteRates() -> Array<Float> {
        return data.records.sort({$0.date < $1.date}).map({Float($0.missionCompleteRate)})
    }
    
    static func getRecordsDate() -> [String] {
        return data.records.sort({$0.date < $1.date}).map({($0.date as NSString).substringWithRange(NSRange(location: 8, length: 2))})
    }
    
    static func removeAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    static func addInbodyPhoto(photo:Photo) {
        try! realm.write {
            data.bodyHistoryPhotos?.addInbodyPhoto(photo)
        }
    }
    
    static func removeBodyPhoto(photo:Photo) {
        try! realm.write {
            data.bodyHistoryPhotos?.removeBodyPhoto(photo)
        }
    }
    
    static func removeInbodyPhoto(photo:Photo) {
        try! realm.write {
            data.bodyHistoryPhotos?.removeInbodyPhoto(photo)
        }
    }
    
    static func addBodyPhoto(photo:Photo) {
        try! realm.write {
            data.bodyHistoryPhotos?.addBodyPhoto(photo)
        }
    }
    
    static func writeBodyInformation(bodyInfo:Body) {
        try! realm.write {
            data.bodyInformation = bodyInfo
        }
    }
    
    static func updatePhotoDescription(photoType:PhotoType, photo:Photo, newDesc:String) {
        try! realm.write {
            var photos = List<Photo>()
            if photoType == PhotoType.Body {
                photos = (self.data.bodyHistoryPhotos?.body)!
            }
            else if photoType == PhotoType.Inbody {
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
    
    static func updateRecord(record:Record, memo:String, missionCompleteRate:Int, exerciseDict:[String:Bool]) {
        try! realm.write {
            record.memo = memo
            record.missionCompleteRate = missionCompleteRate
            record.updateExerciseRecord(exerciseDict)
        }
    }
    
    static func addRecord(record:Record) {
        try! realm.write {
            data.records.append(record)
        }
    }
    
    static func deleteExerciseFromTodayRecord(name:String) {
        try! realm.write {
            let todayExerciseList = data.records.filter("date=%@", Util.getTodayDate()).first?.exerciseList
            if let exercise:Exercise = todayExerciseList?.filter("name=%@", name).first {
                todayExerciseList?.removeAtIndex(todayExerciseList!.indexOf(exercise)!)
            }
        }
    }
    
    static func addExerciseToList(title:String) {
        try! realm.write {
            data.addExercise(Exercise(name: title, did: false))
        }
    }
    
    static func deleteExerciseFromList(index:Int) {
        try! realm.write {
            data.exerciseList.removeAtIndex(index)
        }
    }
}