import UIKit
import RealmSwift

class ExerciseListViewController: UITableViewController {

    private let cellID = "exercise"
    private let editExerciseSegueId = "editExercise"
    
    private var data:Root = Root()
    private var exerciseList:List<Exercise> = List()
    
    private var selectedExercise:Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = ModelManager.getData()
        exerciseList = data.exerciseList
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = exerciseList[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedExercise = exerciseList[indexPath.row]
        self.performSegue(withIdentifier: editExerciseSegueId, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ModelManager.deleteExerciseFromTodayRecord(exerciseList[indexPath.row].name)
            ModelManager.updateTodayRecordMissionComplete()
            ModelManager.deleteExerciseFromList(indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddNewExerciseViewController
        if segue.identifier == editExerciseSegueId {
            if let se = self.selectedExercise {
                vc.setExercise(exercise: se)
            }
            else {
                print("error occurred. selected exercise did not assigned.")
            }
        }
    }
}
