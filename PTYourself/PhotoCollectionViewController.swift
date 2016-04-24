
import UIKit
import Photos
import RealmSwift

enum PhotoType {
    case Inbody
    case Body
    case None
}

class PhotoCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    let reuseIdentifier = "photoCell"
    let defaultTitle = ""

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
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressToEditDescription(_:)))
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.delegate = self
        self.collectionView?.addGestureRecognizer(longPressGesture)
        
        imagePicker.delegate = self
    }
    
    // MARK: - Image Editor
    
    func longPressToEditDescription(gestureRecognizer : UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != UIGestureRecognizerState.Ended){
            return
        }
        
        var photoToEdit = Photo()
        var newTextField = UITextField()
        
        let p = gestureRecognizer.locationInView(self.collectionView)
        if let indexPath:NSIndexPath = (self.collectionView?.indexPathForItemAtPoint(p)) {
            photoToEdit = photos[indexPath.row]
        }
        
        let alert = UIAlertController(title: "Edit Photo Description", message: nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.editDescription(photoToEdit, newDesc:newTextField.text!)
            self.setData()
            self.collectionView?.reloadData()
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextFieldWithConfigurationHandler {(textField: UITextField!) -> Void in
            textField.text = photoToEdit.desc
            newTextField = textField!
        }
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func editDescription(photo:Photo, newDesc: String) {
        ModelManager.updatePhotoDescription(self.photoType, photo: photo, newDesc: newDesc)
    }
    
    // MARK: - Image picker
    @IBAction func loadImageButtonTapped(sender: UIBarButtonItem) {
        // todo : add taking a picture and use it
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var photoCreationDate = NSDate()
        if let ph = PHAsset.fetchAssetsWithALAssetURLs([(info["UIImagePickerControllerReferenceURL"] as! NSURL)], options: nil).firstObject {
            photoCreationDate = (ph as! PHAsset).creationDate!
        }
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let photo = Photo(date:photoCreationDate, desc:defaultTitle, data: UIImageJPEGRepresentation(pickedImage, 0.7)!)
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
        cell.desc.numberOfLines = 0
        cell.desc.text = "\(Util.getYYYYMMDD(photoDTO.date))\n\(photoDTO.desc)"
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
