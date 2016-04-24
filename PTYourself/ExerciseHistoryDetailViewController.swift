
import UIKit
import RealmSwift

class ExerciseHistoryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let exerciseCellID = "exercise4History"
    
    private var record = Record()
    private var doneExercises:Array<Exercise> = []
    private var undoneExercises:Array<Exercise> = []
    
    @IBOutlet var review: UITextView!
    @IBOutlet var exerciseRecord: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.exerciseRecord.delegate = self
        self.exerciseRecord.dataSource = self
        self.exerciseRecord.registerClass(UITableViewCell.self, forCellReuseIdentifier: exerciseCellID)
        self.navigationItem.title = self.record.date
        self.review.text = self.record.memo
        
        if self.record.exerciseList.count > 0 {
            self.doneExercises = Array(self.record.exerciseList.filter("did=%@", true))
            self.undoneExercises = Array(self.record.exerciseList.filter("did=%@", false))
        }
    }
    
    func setRecord(record:Record) {
        self.record = record
    }

    // MARK: - exercise list table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.undoneExercises.count
        }
        else {
            return self.doneExercises.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "UNDONE EXERCISES"
        }
        else {
            return "DONE EXERCISES"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(exerciseCellID, forIndexPath: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = self.undoneExercises[indexPath.row].name
            cell.textLabel?.enabled = true
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        else {
            cell.textLabel?.text = self.doneExercises[indexPath.row].name
            cell.textLabel?.enabled = false
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
}
