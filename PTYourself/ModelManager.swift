
import Foundation
import RealmSwift

class ModelManager {
    private static let realm = try! Realm()
    private static var data = Root()
    
    static func getData() -> Root {
        data = realm.objects(Root).first!
        return data
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