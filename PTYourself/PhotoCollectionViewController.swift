
import UIKit
import RealmSwift

private let reuseIdentifier = "photoCell"

enum PhotoType {
    case Inbody
    case Body
    case None
}

class PhotoCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    private var photos:[Photo] = []
    private var photoType:PhotoType = PhotoType.None
    var selectedPhoto = Photo()
    
    func setPhotoType(photoType:PhotoType) {
        self.photoType = photoType
    }
    
    func setData() {
        let photoRealms = ModelManager.getData().bodyHistoryPhotos
        if self.photoType == PhotoType.Inbody {
            self.photos = Array(photoRealms!.inbody.sorted("date", ascending: false))
        }
        else if self.photoType == PhotoType.Body {
            self.photos = Array(photoRealms!.body.sorted("date", ascending: false))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setData()
        self.collectionView?.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        
        imagePicker.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    // MARK: - Image picker
    @IBAction func loadImageButtonTapped(sender: UIBarButtonItem) {
        // todo : add taing a picture and use it
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // todo edit
            let photo = Photo(date:NSDate(), desc:"test desc", data: UIImageJPEGRepresentation(pickedImage, 0.7)!)
            if self.photoType == PhotoType.Body {
                ModelManager.addBodyPhoto(photo)
            }
            else if self.photoType == PhotoType.Inbody {
                ModelManager.addInbodyPhoto(photo)
            }
            setData()
        }
        dismissViewControllerAnimated(true, completion: nil)
        self.collectionView?.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let scrollVC = segue.destinationViewController as! PhotoScrollViewController
            scrollVC.setUIImageView(self.selectedPhoto, type: self.photoType)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.endIndex
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
    
        let photoDTO = photos[indexPath.row]
        cell.desc.text = "\(photoDTO.date), \(photoDTO.desc)"
        cell.photo.image = UIImage(data: photoDTO.data)
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedPhoto = photos[indexPath.row]
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */


    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }


}
