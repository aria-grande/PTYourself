import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get data
       
        // save to object
        setSampleData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setSampleData() -> Root {
        let body = [Photo(date: NSDate(), description: "my beautiful body", src: "http://pub.chosun.com/editor/cheditor_new/attach/IE1KGC6OQPOPFN5JCWIB.jpg")]
        let inbody = [Photo(date: NSDate(), description:"inbody result T.T", src:"http://www.inbody.com/images/product/inbody720/inbody720_results01.jpg")]
        
        let data = Root.sharedInstance
        data.setBodyInformation(Body(height: 166.7, weight: 50.0))
        data.addExercise(Exercise(name: "lunge 10 times", did: false))
        data.addExercise(Exercise(name: "squart 50 times", did: false))
        data.addRecord(Record(date: NSDate(), missionCompleteRate: 80, memo: "test memo"))
        data.setBodyHistoryPhotos(Album(inbody: inbody, body: body))
        
        return data
    }
    
}

