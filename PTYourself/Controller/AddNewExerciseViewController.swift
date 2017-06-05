
import UIKit
import RealmSwift

class AddNewExerciseViewController: UIViewController {

    @IBOutlet var newExercise: UITextField!

    @IBAction func saveNewExercise(_ sender: AnyObject) {
        if let exercise = newExercise.text, !exercise.isEmpty {
            ModelManager.addExerciseToList(newExercise.text!)
        }
        else {
            print("내용을 입력해 주세요")    // todo: make alert
        }
        self.navigationController?.popViewController(animated: true)
    }
}
