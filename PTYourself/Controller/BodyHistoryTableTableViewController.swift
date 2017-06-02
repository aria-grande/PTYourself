
import UIKit

class BodyHistoryTableTableViewController: UITableViewController {
    fileprivate let segueID4showInbody = "showInbodyPhotos"
    fileprivate let segueID4showBody = "showBodyPhotos"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 0 {
            self.performSegue(withIdentifier: segueID4showInbody, sender: self)
        }
        else if section == 1 {
            self.performSegue(withIdentifier: segueID4showBody, sender: self)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 2 - 50
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoCollectionViewController
        let segueId = segue.identifier!
        if segueId == segueID4showBody {
            vc.setPhotoType(PhotoType.body)
        }
        else if segueId == segueID4showInbody {
            vc.setPhotoType(PhotoType.inbody)
        }
    }
}
