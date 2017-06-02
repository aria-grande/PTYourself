import UIKit
import RealmSwift
import SwiftChart

class ExerciseRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let showHistorySegueID = "showExerciseHistory"
    fileprivate let cellIdentifier = "exerciseRecordCell"
    
    fileprivate let records = List<Record>()
    fileprivate let chart = Chart()
    fileprivate var chartRect = CGRect(x: 0, y: 0, width: 350, height: 170)
    fileprivate var bodyInformation = Body()
    
    @IBOutlet var graphView: UIView!
    @IBOutlet var recordTableView: UITableView!
    @IBOutlet var header: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        recordTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        graphView.addSubview(chart)
        loadDynamicData()   // todo : check and delete the line
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDynamicData()
        self.recordTableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let graphViewFrame = self.graphView.frame
        chartRect = CGRect(x: 0, y: 0, width: graphViewFrame.width, height: graphViewFrame.height)
        chart.frame = chartRect
        drawGraph()
    }

    fileprivate func drawGraph() {
        let recordsDate:[String] = ModelManager.getRecordsDate()
        let missionCompleteRates:Array<Float> = ModelManager.getMissionCompleteRates()
        let series = ChartSeries(missionCompleteRates)
        series.area = true
        series.color = ChartColors.orangeColor()
        
        if (recordsDate.isEmpty || missionCompleteRates.isEmpty) {
            print("[Error] cannot draw because records are empty")
            return
        }
        chart.removeAllSeries()
        chart.xLabelsFormatter = {(labelIndex:Int , labelValue:Float) -> String in return recordsDate[labelIndex]}
        chart.yLabelsFormatter = {String(Int($1)) + "%"}
        chart.yLabelsOnRightSide = true
        chart.minY = 0
        chart.maxY = 100
        chart.add(series)
    }
    
    fileprivate func loadDynamicData() {
        let data = ModelManager.getData()
        self.records.removeAll()
        
        data.records.sorted(byKeyPath: "date").forEach { (record) in
            self.records.append(record)
        }
        self.bodyInformation = data.bodyInformation!
        
        setNavigationHeader()
        drawGraph()
        chart.setNeedsDisplay()
        self.recordTableView.reloadData()
    }
    
    fileprivate func setNavigationHeader() {
        header.title = "\(self.bodyInformation.height)cm, \(self.bodyInformation.weight)kg"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = Array(self.records)[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = "\(record.date)"
        cell.detailTextLabel?.text = "\(record.missionCompleteRate)%"
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(red: CGFloat(0.941), green: CGFloat(0.843), blue: CGFloat(0.627), alpha: CGFloat(1))
        }
        
        return cell
    }

    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: showHistorySegueID, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showHistorySegueID {
            let detailVC = segue.destination as! ExerciseHistoryDetailViewController
            detailVC.setRecord(self.records[(sender as! IndexPath).row])
            
        }
    }

}
