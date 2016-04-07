import UIKit
import RealmSwift

class BodyInformationViewController: UIViewController {

    private var data:Root = Root();
    private let realm = try! Realm()
    
    @IBOutlet var alertMessage: UILabel!
    @IBOutlet var height: UITextField!
    @IBOutlet var weight: UITextField!
    
    @IBAction func save(sender: UIButton) {
        if let h = Double(height.text!), w = Double(weight.text!) {
            
            ModelManager.writeBodyInformation(Body(height: h, weight: w))
            alertMessage.text = ""
            
            [self.navigationController?.popViewControllerAnimated(true)]
        }
        else {
            alertMessage.text = "fill the information correctly"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = ModelManager.getData()
        print(data)
        
        let body = data.bodyInformation
        height.text = String(body!.height)
        weight.text = String(body!.weight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
