//
//  ImageTableViewCell.swift
//  ContactList
//
//  Created by Maksym Humeniuk on 5/21/19.
//  Copyright © 2019 Maksym Humeniuk. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    
    var person: Person!
    let picker = UIImagePickerController()
    
    func setContent(content: UIImage?) {
        pictureImageView.image = content ?? Constants.emptyAvatar
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
//        addImagePicker()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        imageTapAction()
        
       
        // Configure the view for the selected state
    }
    
}

//extension ImageTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let choosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        changeCurrentImage(imageState: .changed(newImage: choosenImage))
//        dismiss(animated:true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}

private extension ImageTableViewCell {
    
//    func addImagePicker() {
//        picker.delegate = self
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap(tapGuestureRecognizer:)))
//        pictureImageView.isUserInteractionEnabled = true
//        pictureImageView.addGestureRecognizer(recognizer)
//        pictureImageView.contentMode = .scaleAspectFit
//    }
//
//    @objc func onImageTap (tapGuestureRecognizer: UITapGestureRecognizer) {
//
//        if let _ = person.image {
//
//            let actionTitle = NSLocalizedString("CHANGE_IMAGE_TITLE", comment: "Choose action")
//            let changeActionTitle = NSLocalizedString("CHANGE_IMAGE_ACTION", comment: "Change image")
//            let removeActionTitle = NSLocalizedString("REMOVE_IMAGE_ACTION", comment: "Remove image")
//            let cancelTitle = NSLocalizedString("CANCEL_ACTION", comment: "Cancel")
//
//            let choosePhotoAction = UIAlertController(title: actionTitle, message: nil, preferredStyle: .actionSheet)
//            let changeAction = UIAlertAction(title: changeActionTitle, style: .default) {action in self.runChooseImageHandler()}
//            let removeAction = UIAlertAction(title: removeActionTitle, style: .destructive) {action in self.changeCurrentImage(imageState: .removed)}
//            let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
//
//            choosePhotoAction.addAction(changeAction)
//            choosePhotoAction.addAction(removeAction)
//            choosePhotoAction.addAction(cancel)
//            present(choosePhotoAction, animated: true, completion: nil)
//        } else {
//            runChooseImageHandler()
//        }
//    }
//
//    func changeCurrentImage(imageState: ImageEditState) {
//        switch imageState {
//        case .removed:
//            pictureImageView.image = Constants.emptyAvatar
//            person.image = nil
//        case .changed(let newImage):
//            pictureImageView.image = newImage
//            person.image = newImage
//        default:
//            break
//        }
//
//        self.imageState = imageState
//        changeSaveButtonAvailability()
//    }
//
//    func runChooseImageHandler() {
//        #if targetEnvironment(simulator)
//        showPhotoLibrary()
//        #else
//
//        let actionTitle = NSLocalizedString("CHANGE_SOURCE_TITLE", comment: "Choose image source")
//        let galleryActionTitle = NSLocalizedString("GALLERY_ACTION", comment: "Gallery")
//        let cameraActionTitle = NSLocalizedString("CAMERA_ACTION", comment: "Camera")
//        let cancelTitle = NSLocalizedString("CANCEL_ACTION", comment: "Cancel")
//
//        let alertController = UIAlertController(title: actionTitle, message: nil, preferredStyle: .actionSheet)
//        let galleryAction = UIAlertAction(title: galleryActionTitle, style: .default){action in self.showPhotoLibrary()}
//        let cameraAction = UIAlertAction(title: cameraActionTitle, style: .default){action in self.runCamera()}
//        let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
//        alertController.addAction(galleryAction)
//        alertController.addAction(cameraAction)
//        alertController.addAction(cancel)
//        self.present(alertController, animated: true, completion: nil)
//        #endif
//    }
//
//    func showPhotoLibrary() {
//        picker.allowsEditing = false
//        picker.sourceType = .photoLibrary
//        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//        present(self.picker, animated: true, completion: nil)
//    }
//
//    func runCamera() {
//        picker.allowsEditing = false
//        picker.sourceType = .camera
//        picker.cameraCaptureMode = .photo
//        picker.modalPresentationStyle = .fullScreen
//        present(self.picker, animated: true, completion: nil)
//    }
//    func imageTapAction() {
//        if let _ = person.image {
//            let actionTitle = NSLocalizedString("CHANGE_IMAGE_TITLE", comment: "Choose action")
//            let changeActionTitle = NSLocalizedString("CHANGE_IMAGE_ACTION", comment: "Change image")
//            let removeActionTitle = NSLocalizedString("REMOVE_IMAGE_ACTION", comment: "Remove image")
//            let cancelTitle = NSLocalizedString("CANCEL_ACTION", comment: "Cancel")
//            
//            let choosePhotoAction = UIAlertController(title: actionTitle, message: nil, preferredStyle: .actionSheet)
//            let changeAction = UIAlertAction(title: changeActionTitle, style: .default) {action in self.runChooseImageHandler()}
//            let removeAction = UIAlertAction(title: removeActionTitle, style: .destructive) {action in self.changeCurrentImage(imageState: .removed)}
//            let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
//            
//            choosePhotoAction.addAction(changeAction)
//            choosePhotoAction.addAction(removeAction)
//            choosePhotoAction.addAction(cancel)
//            present(choosePhotoAction, animated: true, completion: nil)
//        } else {
//            runChooseImageHandler()
//        }
//    }
//    
//    func runChooseImageHandler() {
//        #if targetEnvironment(simulator)
//        showPhotoLibrary()
//        #else
//        
//        let actionTitle = NSLocalizedString("CHANGE_SOURCE_TITLE", comment: "Choose image source")
//        let galleryActionTitle = NSLocalizedString("GALLERY_ACTION", comment: "Gallery")
//        let cameraActionTitle = NSLocalizedString("CAMERA_ACTION", comment: "Camera")
//        let cancelTitle = NSLocalizedString("CANCEL_ACTION", comment: "Cancel")
//        
//        let alertController = UIAlertController(title: actionTitle, message: nil, preferredStyle: .actionSheet)
//        let galleryAction = UIAlertAction(title: galleryActionTitle, style: .default){action in self.showPhotoLibrary()}
//        let cameraAction = UIAlertAction(title: cameraActionTitle, style: .default){action in self.runCamera()}
//        let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
//        alertController.addAction(galleryAction)
//        alertController.addAction(cameraAction)
//        alertController.addAction(cancel)
//        self.present(alertController, animated: true, completion: nil)
//        #endif
//    }
//    
//    func showPhotoLibrary() {
//        picker.allowsEditing = false
//        picker.sourceType = .photoLibrary
//        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//        present(self.picker, animated: true, completion: nil)
//    }
//    
//    func runCamera() {
//        picker.allowsEditing = false
//        picker.sourceType = .camera
//        picker.cameraCaptureMode = .photo
//        picker.modalPresentationStyle = .fullScreen
//        present(self.picker, animated: true, completion: nil)
//    }
    
}
