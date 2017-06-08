
import UIKit
import RealmSwift

class AddNewExerciseViewController: UIViewController {

    private var onEdit:Bool = false
    private var editingExercise:Exercise?
    
    @IBOutlet var newExercise: UITextField!
    @IBOutlet var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let e = editingExercise, !e.name.isEmpty && onEdit {
            self.newExercise.text = e.name
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.newExercise.becomeFirstResponder()
    }
    
    @IBAction func saveNewExercise(_ sender: AnyObject) {
        if let newName = newExercise.text, !newName.isEmpty {
            if let exec = editingExercise, onEdit {
                ModelManager.updateExercise(exercise: exec, newName: newName)
            }
            else {
                ModelManager.addExerciseToList(newName)
            }
            self.navigationController?.popViewController(animated: true)
        }
        else {
            errorMessage.text = "내용을 입력해 주세요"
        }
    }
    
    func setExercise(exercise: Exercise) {
        editingExercise = exercise
        onEdit = true
    }
}
