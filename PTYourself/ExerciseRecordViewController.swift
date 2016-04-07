import UIKit
import RealmSwift

class ExerciseRecordViewController: UIViewController {

    @IBOutlet var header: UINavigationItem!
    
    private let realm = try! Realm()
    private var data:Root = Root()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = ModelManager.getData()
        loadDynamicData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadDynamicData()
    }
    
    private func loadDynamicData() {
        setNavigationHeader()
    }
    
    private func setNavigationHeader() {
        header.title = "\(data.bodyInformation!.height)cm, \(data.bodyInformation!.weight)kg"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
