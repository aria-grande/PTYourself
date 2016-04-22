
import Foundation
import RealmSwift

class ModelManager {
    // MARK - for test
    private static let todayDateTime = NSDate()
    static var format = NSDateFormatter()
    
    static func getTodayDate() -> String {
        format.dateFormat = "yyyy-MM-dd";
        return format.stringFromDate(todayDateTime)
    }
    
    static func getYesterdayDate() -> String {
        format.dateFormat = "yyyy-MM-dd";
        return format.stringFromDate(todayDateTime.dateByAddingTimeInterval(-60*60*24))
    }
    
    static func convertURL(url:String) -> NSData {
        return NSData(contentsOfURL: NSURL(string: url)!)!
    }
    static func setSampleData() {
        let realm = try! Realm()
//        try! realm.write {
//            realm.deleteAll()
//        }
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
            root.addRecord(Record(date: ModelManager.getTodayDate(), memo: "Test memo", missionCompleteRate: 50, exerciseList: exerciseList))
            root.addRecord(Record(date: ModelManager.getYesterdayDate(), memo: "Test memo", missionCompleteRate: 50, exerciseList: exerciseList))
            
        }
        
        print(realm.objects(Root.self))
    }
    
    
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
    
    static func removeAll() -> Bool {
        do {
            try realm.write {
                realm.deleteAll()
            }
            return true
        } catch {
            return false
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
    static func writeBodyInformation(bodyInfo:Body) -> Bool {
        do {
            try realm.write {
                data.bodyInformation = bodyInfo
            }
            return true
        } catch {
            return false
        }
    }
    
    static func updateTodayRecordMissionComplete() {
        try! realm.write {
            if let todayRecord:Record = data.records.filter("date=%@", getTodayDate()).first {
                todayRecord.missionCompleteRate = Util.calculateMissionCompleteRate(todayRecord.exerciseList)
            }
        }
    }
    
    static func updateRecord(record:Record, memo:String, missionCompleteRate:Int, exerciseDict:[String:Bool]) -> Bool {
        do {
            try realm.write {
                record.memo = memo
                record.missionCompleteRate = missionCompleteRate
                record.updateExerciseRecord(exerciseDict)
            }
            return true
        } catch {
            return false
        }
    }
    
    static func addRecord(record:Record) -> Bool {
        do {
            try realm.write {
                data.records.append(record)
            }
            return true
        } catch {
            return false
        }
    }
    
    static func deleteExerciseFromTodayRecord(name:String) {
        try! realm.write {
            let todayExerciseList = data.records.filter("date=%@", getTodayDate()).first?.exerciseList
            if let exercise:Exercise = todayExerciseList?.filter("name=%@", name).first {
                todayExerciseList?.removeAtIndex(todayExerciseList!.indexOf(exercise)!)
            }
        }
    }
    
    static func addExerciseToList(title:String) -> Bool {
        do {
            try realm.write {
                data.addExercise(Exercise(name: title, did: false))
            }
            return true
        }catch {
            return false
        }
    }
    
    static func deleteExerciseFromList(index:Int) -> Bool {
        do {
            try realm.write {
                data.exerciseList.removeAtIndex(index)
            }
            return true
        } catch {
            return false
        }
    }
}