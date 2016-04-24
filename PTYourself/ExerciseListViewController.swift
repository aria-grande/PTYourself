import UIKit
import RealmSwift

class ExerciseListViewController: UITableViewController {

    private let cellID = "exercise"
    
    private var data:Root = Root()
    private var exerciseList:List<Exercise> = List()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = ModelManager.getData()
        exerciseList = data.exerciseList
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        cell.textLabel?.text = exerciseList[indexPath.row].name
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            ModelManager.deleteExerciseFromTodayRecord(exerciseList[indexPath.row].name)
            ModelManager.updateTodayRecordMissionComplete()
            ModelManager.deleteExerciseFromList(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
