
import UIKit
import RealmSwift

class ExerciseHistoryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let exerciseCellID = "exercise4History"
    
    fileprivate var record = Record()
    fileprivate var doneExercises:Array<Exercise> = []
    fileprivate var undoneExercises:Array<Exercise> = []
    
    @IBOutlet var review: UITextView!
    @IBOutlet var exerciseRecord: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.exerciseRecord.delegate = self
        self.exerciseRecord.dataSource = self
        self.exerciseRecord.register(UITableViewCell.self, forCellReuseIdentifier: exerciseCellID)
        self.navigationItem.title = self.record.date
        self.review.text = self.record.memo
        
        if self.record.exerciseList.count > 0 {
            self.doneExercises = Array(self.record.exerciseList.filter("did=%@", true))
            self.undoneExercises = Array(self.record.exerciseList.filter("did=%@", false))
        }
    }
    
    func setRecord(_ record:Record) {
        self.record = record
    }

    // MARK: - exercise list table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.undoneExercises.count
        }
        else {
            return self.doneExercises.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "하지 않은 운동"
        }
        else {
            return "완료한 운동"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: exerciseCellID, for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = self.undoneExercises[indexPath.row].name
            cell.textLabel?.isEnabled = true
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        else {
            cell.textLabel?.text = self.doneExercises[indexPath.row].name
            cell.textLabel?.isEnabled = false
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        return cell
    }
}
