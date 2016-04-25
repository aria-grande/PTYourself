import UIKit
import RealmSwift
import SwiftChart

class ExerciseRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let showHistorySegueID = "showExerciseHistory"
    private let cellIdentifier = "exerciseRecordCell"
    
    private let records = List<Record>()
    private let chart = Chart()
    private var chartRect = CGRect(x: 0, y: 0, width: 350, height: 170)
    private var bodyInformation = Body()
    
    @IBOutlet var graphView: UIView!
    @IBOutlet var recordTableView: UITableView!
    @IBOutlet var header: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        recordTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        
        graphView.addSubview(chart)
        
        loadDynamicData()
    }
    
    override func viewWillLayoutSubviews() {
        print("viewWillLayoutSubviews")
        super.viewWillLayoutSubviews()
        let graphViewFrame = self.graphView.frame
        chartRect = CGRect(x: 0, y: 0, width: graphViewFrame.width, height: graphViewFrame.height)
        chart.frame = chartRect
        drawGraph()
    }

    override func viewWillAppear(animated: Bool) {
        print("viewwillApoear")
        super.viewWillAppear(animated)
        loadDynamicData()
        self.recordTableView.reloadData()
    }
    
    private func drawGraph() {
        let recordsDate:[String] = ModelManager.getRecordsDate()
        let series = ChartSeries(ModelManager.getMissionCompleteRates())
        series.area = true
        series.color = ChartColors.orangeColor()
        
        chart.removeSeries()
        chart.xLabelsFormatter = {(labelIndex:Int , labelValue:Float) -> String in return recordsDate[labelIndex]}
        chart.yLabelsFormatter = {String(Int($1)) + "%"}
        chart.yLabelsOnRightSide = true
        chart.minY = 0
        chart.maxY = 100
        chart.addSeries(series)
        
    }
    
    private func loadDynamicData() {
        let data = ModelManager.getData()
        self.records.removeAll()
        self.records.appendContentsOf(data.records.sort({$0.date > $1.date}))
        self.bodyInformation = data.bodyInformation!
        
        setNavigationHeader()
        drawGraph()
        chart.setNeedsDisplay()
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
            cell.backgroundColor = UIColor(red: CGFloat(0.941), green: CGFloat(0.843), blue: CGFloat(0.627), alpha: CGFloat(1))
        }
        
        return cell
    }

    // MARK: - Navigation
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(showHistorySegueID, sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showHistorySegueID {
            let detailVC = segue.destinationViewController as! ExerciseHistoryDetailViewController
            detailVC.setRecord(self.records[(sender as! NSIndexPath).row])
            
        }
    }

}