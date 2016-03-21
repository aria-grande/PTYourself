import UIKit

class BodyInformationViewController: UIViewController {

    private var data:Root = Root.sharedInstance
    
    @IBOutlet var alertMessage: UILabel!
    @IBOutlet var height: UITextField!
    @IBOutlet var weight: UITextField!
    
    @IBAction func save(sender: UIButton) {
        if let h = Double(height.text!), w = Double(weight.text!) {
            let body = Body(height: h, weight: w)
            data.setBodyInformation(body)
            alertMessage.text = ""
            
            [self.navigationController?.popViewControllerAnimated(true)]
        }
        else {
            alertMessage.text = "fill the information correctly"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let body = data.getBodyInformation()
        height.text = String(body.getHeight())
        weight.text = String(body.getWeight())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
