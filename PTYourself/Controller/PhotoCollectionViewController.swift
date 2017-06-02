
import UIKit
import Photos
import RealmSwift

class PhotoCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    fileprivate let showDetailSegueID = "showDetail"
    fileprivate let reuseIdentifier = "photoCell"
    fileprivate let editPhotoDescTitle = "Edit Photo Description"
    fileprivate let defaultPhotoTitle = ""
    
    fileprivate let imagePicker = UIImagePickerController()
    fileprivate var photos:[Photo] = []
    fileprivate var photoType:PhotoType = PhotoType.none
    fileprivate var selectedPhoto = Photo()
    
    func setPhotoType(_ photoType:PhotoType) {
        self.photoType = photoType
    }
    
    func setData() {
        let photoRealms = ModelManager.getData().bodyHistoryPhotos
        if self.photoType == PhotoType.inbody {
            self.photos = Array(photoRealms!.inbody.sorted(byKeyPath: "date", ascending: false))
        }
        else if self.photoType == PhotoType.body {
            self.photos = Array(photoRealms!.body.sorted(byKeyPath: "date", ascending: false))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func longPressToEditDescription(_ gestureRecognizer : UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
            return
        }
        
        var photoToEdit = Photo()
        var newTextField = UITextField()
        
        let p = gestureRecognizer.location(in: self.collectionView)
        if let indexPath:IndexPath = (self.collectionView?.indexPathForItem(at: p)) {
            photoToEdit = photos[indexPath.row]
        }
        
        let alert = UIAlertController(title: editPhotoDescTitle, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
            self.editDescription(photoToEdit, newDesc:newTextField.text!)
            self.setData()
            self.collectionView?.reloadData()
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextField {(textField: UITextField!) -> Void in
            textField.text = photoToEdit.desc
            newTextField = textField!
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func editDescription(_ photo:Photo, newDesc: String) {
        ModelManager.updatePhotoDescription(self.photoType, photo: photo, newDesc: newDesc)
    }
    
    // MARK: - Image picker
    @IBAction func loadImageButtonTapped(_ sender: UIBarButtonItem) {
        // todo : add taking a picture and use it
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var photoCreationDate = Date()
        if let ph = PHAsset.fetchAssets(withALAssetURLs: [(info["UIImagePickerControllerReferenceURL"] as! URL)], options: nil).firstObject {
            photoCreationDate = (ph ).creationDate!
        }
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let photo = Photo(date:photoCreationDate, desc:defaultPhotoTitle, data: UIImageJPEGRepresentation(pickedImage, 0.7)!)
            if self.photoType == PhotoType.body {
                ModelManager.addBodyPhoto(photo)
            }
            else if self.photoType == PhotoType.inbody {
                ModelManager.addInbodyPhoto(photo)
            }
            setData()
        }
        dismiss(animated: true, completion: nil)
        self.collectionView?.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDetailSegueID {
            let scrollVC = segue.destination as! PhotoScrollViewController
            scrollVC.setUIImageView(self.selectedPhoto, type: self.photoType)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.endIndex
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
    
        let photoDTO = photos[indexPath.row]
        cell.desc.numberOfLines = 0
        cell.desc.text = "\(Util.getYYYYMMDD(photoDTO.date))\n\(photoDTO.desc)"
        cell.photo.image = UIImage(data: photoDTO.data as Data)
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPhoto = photos[indexPath.row]
        self.performSegue(withIdentifier: showDetailSegueID, sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
}
