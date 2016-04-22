		
import UIKit
import RealmSwift

class RecordExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var memo: UITextView!
    @IBOutlet var exerciseListView: UITableView!
    
    private let cellIdentifier = "exercise4Record"
    private var todayRecord = Record()
    private var todayExerciseList = [String:Bool]()
    private var recordIsNowCreated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        exerciseListView.delegate = self
        exerciseListView.dataSource = self
        exerciseListView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(exerciseListView)
        
        setData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    @IBAction func saveRecord(sender: AnyObject) {
        let missionCompleteRate = Util.calculateMissionCompleteRate(todayExerciseList)
        if recordIsNowCreated {
            ModelManager.addRecord(Record(date: ModelManager.getTodayDate(), memo: memo.text, missionCompleteRate: missionCompleteRate, exerciseList: Record.convert(self.todayExerciseList)))
        }
        else {
            ModelManager.updateRecord(todayRecord, memo: memo.text, missionCompleteRate: missionCompleteRate, exerciseDict: self.todayExerciseList)
        }
        [self.navigationController?.popViewControllerAnimated(true)]
    }
    
    private func setData() {
        let data = ModelManager.getData()
        let recordRealmObject =
            data.records.filter("date=%@", ModelManager.getTodayDate())
        if  recordRealmObject.count > 0 {
            todayRecord = recordRealmObject.first!
        }
        else {
            recordIsNowCreated = true
            todayRecord = Record(date: ModelManager.getTodayDate(), memo: "", missionCompleteRate: 0)
        }
        
        self.memo.text = self.todayRecord.memo
        // for adding newly added exercise
        for exercise in data.exerciseList {
            self.todayExerciseList[exercise.name] = exercise.did
        }
        // for setting the value of done
        for exercise in todayRecord.exerciseList {
            self.todayExerciseList[exercise.name] = exercise.did
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todayExerciseList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let exerciseName:String = Array(self.todayExerciseList.keys)[indexPath.row]
        let exerciseDoneValue:Bool = Array(self.todayExerciseList.values)[indexPath.row]
        setCell(cell, exerciseName: exerciseName, exerciseDoneValue: exerciseDoneValue)
        
        return cell
    }

    private func setCell(cell:UITableViewCell, exerciseName:String, exerciseDoneValue:Bool) {
        cell.textLabel!.text = "\(exerciseName)"
        if exerciseDoneValue {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let exerciseName:String = Array(self.todayExerciseList.keys)[indexPath.row]
        let exerciseDoneValue:Bool = !Array(self.todayExerciseList.values)[indexPath.row]
        
        setCell(cell, exerciseName: exerciseName, exerciseDoneValue: exerciseDoneValue)
        self.todayExerciseList[exerciseName] = exerciseDoneValue
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
