
import UIKit
import RealmSwift

class AddNewExerciseViewController: UIViewController {

    @IBOutlet var newExercise: UITextField!

    @IBAction func saveNewExercise(_ sender: AnyObject) {
        ModelManager.addExerciseToList(newExercise.text!)
    }
}
