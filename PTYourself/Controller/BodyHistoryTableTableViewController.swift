
import UIKit

class BodyHistoryTableTableViewController: UITableViewController {
    private let segueID4showInbody = "showInbodyPhotos"
    private let segueID4showBody = "showBodyPhotos"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        if section == 0 {
            self.performSegueWithIdentifier(segueID4showInbody, sender: self)
        }
        else if section == 1 {
            self.performSegueWithIdentifier(segueID4showBody, sender: self)
        }
        
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PhotoCollectionViewController
        if segue.identifier == segueID4showBody {
            vc.setPhotoType(PhotoType.Body)
        }
        else if segue.identifier == segueID4showInbody {
            vc.setPhotoType(PhotoType.Inbody)
        }
    }
}
