		
import UIKit
import RealmSwift

class RecordExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate let cellIdentifier = "exercise4Record"
    
    fileprivate var todayRecord = Record()
    fileprivate var todayExerciseList = [String:Bool]()
    fileprivate var recordIsNowCreated = false
    
    @IBOutlet var memo: UITextView!
    @IBOutlet var exerciseListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        exerciseListView.delegate = self
        exerciseListView.dataSource = self
        exerciseListView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(exerciseListView)
        
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    @IBAction func saveRecord(_ sender: AnyObject) {
        let missionCompleteRate = Util.calculateMissionCompleteRate(todayExerciseList)
        if recordIsNowCreated {
            ModelManager.addRecord(Record(date: Util.getTodayDate(), memo: memo.text, missionCompleteRate: missionCompleteRate, exerciseList: Record.convert(self.todayExerciseList)))
        }
        else {
            ModelManager.updateRecord(todayRecord, memo: memo.text, missionCompleteRate: missionCompleteRate, exerciseDict: self.todayExerciseList)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setData() {
        let data = ModelManager.getData()
        let recordRealmObject = data.records.filter("date=%@", Util.getTodayDate())
        if  recordRealmObject.count > 0 {
            todayRecord = recordRealmObject.first!
        }
        else {
            recordIsNowCreated = true
            todayRecord = Record(date: Util.getTodayDate(), memo: "", missionCompleteRate: 0)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todayExerciseList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let exerciseName:String = Array(self.todayExerciseList.keys)[indexPath.row]
        let exerciseDoneValue:Bool = Array(self.todayExerciseList.values)[indexPath.row]
        setCell(cell, exerciseName: exerciseName, exerciseDoneValue: exerciseDoneValue)
        
        return cell
    }

    fileprivate func setCell(_ cell:UITableViewCell, exerciseName:String, exerciseDoneValue:Bool) {
        cell.textLabel!.text = "\(exerciseName)"
        if exerciseDoneValue {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let exerciseName:String = Array(self.todayExerciseList.keys)[indexPath.row]
        let exerciseDoneValue:Bool = !Array(self.todayExerciseList.values)[indexPath.row]
        
        setCell(cell, exerciseName: exerciseName, exerciseDoneValue: exerciseDoneValue)
        self.todayExerciseList[exerciseName] = exerciseDoneValue
    }
}
