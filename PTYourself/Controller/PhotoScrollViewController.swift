
import UIKit

class PhotoScrollViewController: UIViewController, UIScrollViewDelegate {
    
    var photo:Photo!
    var photoType:PhotoType = PhotoType.none
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.maximumZoomScale = 5.0
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.delegate = self
        
        self.imageView.image = UIImage(data:photo.data as Data)
        self.navigationItem.title = photo.desc
    }

    @IBAction func removeThisPhoto(_ sender: UIBarButtonItem) {
        if self.photoType == PhotoType.body {
            ModelManager.removeBodyPhoto(self.photo)
        }
        else if self.photoType == PhotoType.inbody {
            ModelManager.removeInbodyPhoto(self.photo)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUIImageView(_ photo: Photo, type:PhotoType) {
        self.photo = photo
        self.photoType = type
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
