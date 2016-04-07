import UIKit
import RealmSwift

class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setSampleData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setSampleData() {
        ModelManager.removeAll()
        
        let inbody = Photo(date: NSDate(), desc: "my beautiful body", src: "http://pub.chosun.com/editor/cheditor_new/attach/IE1KGC6OQPOPFN5JCWIB.jpg")
        let body = Photo(date: NSDate(), desc: "inbody result!", src: "http://pub.chosun.com/editor/cheditor_new/attach/IE1KGC6OQPOPFN5JCWIB.jpg")
        let exercise1 = Exercise(name: "lunge 10 times", did: false)
        let exercise2 = Exercise(name: "squart 50 times", did: false)
        let record = Record(date:NSDate(), memo:"Test memo", missionCompleteRate: 80)
        
        let realm = try! Realm()
        try! realm.write {
            let root = realm.create(Root.self)
            root.bodyInformation = Body(height: 166.7, weight: 50.0)
            root.bodyHistoryPhotos = Album(inbody: inbody, body: body)
            root.addExercise(exercise1)
            root.addExercise(exercise2)
            root.addRecord(record)
        }
        
        print(realm.objects(Root.self))
    }
}

