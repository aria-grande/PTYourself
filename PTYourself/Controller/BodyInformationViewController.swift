import UIKit
import RealmSwift

class BodyInformationViewController: UIViewController {

    fileprivate let errorMessage = "올바르지 않은 형태입니다."
    
    fileprivate var data:Root = Root();
    fileprivate let realm = try! Realm()
    
    @IBOutlet var alertMessage: UILabel!
    @IBOutlet var height: UITextField!
    @IBOutlet var weight: UITextField!
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let h = Double(height.text!), let w = Double(weight.text!) {
            ModelManager.writeBodyInformation(Body(height: h, weight: w))
            alertMessage.text = ""
            
            self.navigationController?.popViewController(animated: true)
        }
        else {
            alertMessage.text = errorMessage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = ModelManager.getData()
        
        let body = data.bodyInformation
        height.text = String(body!.height)
        weight.text = String(body!.weight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.weight.becomeFirstResponder()
    }
}
