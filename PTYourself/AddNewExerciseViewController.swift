
import UIKit
import RealmSwift

class AddNewExerciseViewController: UIViewController {

    @IBOutlet var newExercise: UITextField!

    @IBAction func saveNewExercise(sender: AnyObject) {
        ModelManager.addExerciseToList(newExercise.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
