
import UIKit

class PhotoScrollViewController: UIViewController, UIScrollViewDelegate {
    
    var photo:Photo!
    var photoType:PhotoType = PhotoType.None
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.maximumZoomScale = 5.0
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.delegate = self
        
        self.imageView.image = UIImage(data:photo.data)
        self.navigationItem.title = photo.desc
    }

    @IBAction func removeThisPhoto(sender: UIBarButtonItem) {
        if self.photoType == PhotoType.Body {
            ModelManager.removeBodyPhoto(self.photo)
        }
        else if self.photoType == PhotoType.Inbody {
            ModelManager.removeInbodyPhoto(self.photo)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setUIImageView(photo: Photo, type:PhotoType) {
        self.photo = photo
        self.photoType = type
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
