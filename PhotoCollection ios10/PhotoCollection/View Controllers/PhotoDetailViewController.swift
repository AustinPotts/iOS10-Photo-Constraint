//
//  PhotoDetailViewController.swift
//  PhotoCollection
//
//  Created by Spencer Curtis on 8/2/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Photos

class PhotoDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageView: UIImageView!
    var titleTextField: UITextField!
    
    var photo: Photo?
    var photoController: PhotoController?
    var themeHelper: ThemeHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTheme()
        updateViews()
        setUpSubViews()
    }
    
    func setUpSubViews() {
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
        
        
        //Add as subview
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        //Constrain
        let saveTopConstraint = NSLayoutConstraint(item: saveButton,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: view.safeAreaLayoutGuide,
                                                   attribute: .top,
                                                   multiplier: 1,
                                                   constant: 10)
        
        
        let saveButtonTrailing =  NSLayoutConstraint(item: saveButton,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: view.safeAreaLayoutGuide,
                                                     attribute: .trailing,
                                                     multiplier: 1,
                                                     constant: -20)
        
        NSLayoutConstraint.activate([saveTopConstraint,
                                     saveButtonTrailing])
        
        
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -100).isActive = true
        
        self.imageView = imageView
        
        let button = UIButton(type: .system)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Image", for: .normal)
        button.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        
        
        button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        button.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 4).isActive = true
        button.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -4).isActive = true
        
        
        
        
        
        
        let textField = UITextField()
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Give this photo a title:"
        
        
        
        textField.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 4).isActive = true
        textField.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10).isActive = true
        
        self.titleTextField = textField
        
        
        
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        imageView.image = image
    }
    
    // MARK: - Private Methods
    
   @objc private func addImage() {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
    
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
            
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    return
                }
                self.presentImagePickerController()
            }
        default:
            break
        }
    }
    
   @objc private func savePhoto() {
        
        guard let image = imageView.image,
            let imageData = image.pngData(),
            let title = titleTextField.text else { return }
        
        if let photo = photo {
            photoController?.update(photo: photo, with: imageData, and: title)
        } else {
            photoController?.createPhoto(with: imageData, title: title)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        
        guard let photo = photo else {
            title = "Create Photo"
            return
        }
        
        title = photo.title
        
        imageView.image = UIImage(data: photo.imageData)
        titleTextField.text = photo.title
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func setTheme() {
        guard let themePreference = themeHelper?.themePreference else { return }
        
        var backgroundColor: UIColor!
        
        switch themePreference {
        case "Dark":
            backgroundColor = .lightGray
        case "Blue":
            backgroundColor = UIColor(red: 61/255, green: 172/255, blue: 247/255, alpha: 1)
        default:
            break
        }
        
        view.backgroundColor = backgroundColor
    }
}
