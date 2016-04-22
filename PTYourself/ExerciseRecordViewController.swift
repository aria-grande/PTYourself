import UIKit
import RealmSwift

class ExerciseRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let cellIdentifier = "exerciseRecordCell"
    private var bodyInformation = Body()
    private let records = List<Record>()
    
    @IBOutlet var recordTableView: UITableView!
    @IBOutlet var header: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordTableView.delegate = self
        recordTableView.dataSource = self
        recordTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        loadDynamicData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadDynamicData()
        self.recordTableView.reloadData()
    }
    
    private func loadDynamicData() {
        let data = ModelManager.getData()
        self.records.removeAll()
        self.records.appendContentsOf(data.records.sort({$0.date > $1.date}))
        self.bodyInformation = data.bodyInformation!
        
        setNavigationHeader()
        self.recordTableView.reloadData()
    }
    
    private func setNavigationHeader() {
        header.title = "\(self.bodyInformation.height)cm, \(self.bodyInformation.weight)kg"
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.records.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let record = Array(self.records)[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = "\(record.date)"
        cell.detailTextLabel?.text = "\(record.missionCompleteRate)%"
        if indexPath.row == 0 {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .Middle)
        }
        
        return cell
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
