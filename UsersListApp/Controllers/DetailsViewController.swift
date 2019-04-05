//
//  DetailsViewController.swift
//  UsersListApp
//
//  Created by Anatolii Zavialov on 10/18/18.
//  Copyright © 2018 Anatolii Zavialov. All rights reserved.
//

import UIKit
import SDWebImage
import Photos
import VMaskTextField

enum AuthorizationStatusAccessType: String {
    case camera
    case photoLibrary
}

enum ErrorValidationType: String {
    case email = "Email"
    case firstName = "First Name"
    case lastName = "Last Name"
}

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var changePhotoLabel: UILabel!
    @IBOutlet weak var userDetailsBackground: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: VMaskTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pickedImageURL: NSURL?
    
    var isAdd: Bool?
    var selectedUser: StoredUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let user = selectedUser else {
            return
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionChangeAvatar))
        
        changePhotoLabel.addGestureRecognizer(tapGesture)
        changePhotoLabel.isUserInteractionEnabled = true
        
        userAvatar.layer.cornerRadius = userAvatar.frame.height / 2
        userAvatar.sd_setImage(with: URL(string: user.avatarURLString ?? ""), completed: nil)
        
        firstNameTextField.text = user.firstName?.capitalized
        lastNameTextField.text = user.lastName?.capitalized
        emailTextField.text = user.email
        
        let phoneMask = (user.phoneNumber?.components(separatedBy: CharacterSet.decimalDigits))?.joined(separator: "#")
        phoneNumberTextField.mask = phoneMask
        phoneNumberTextField.text = user.phoneNumber
        phoneNumberTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
            self.saveImage(image, imageURL ?? nil)
        } else{
            print("Something went wrong in  image")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    //MARK: - UITextFieldDelegate
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let maskTextField = textField as? VMaskTextField else {
            return false
        }
        
        return maskTextField.shouldChangeCharacters(in: range, replacementString: string)
    }
    
    //MARK: - Camera/Gallery methods
    
    func saveImage(_ image: UIImage, _ imagePath: NSURL?) {
        if let imageURL = imagePath {
            pickedImageURL = imageURL
        } else {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // choose a name for your image
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyy-hh-mm"
            let fileName = dateFormatter.string(from: Date())
            // create the destination file url to save your image
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            // get your UIImage jpeg data representation and check if the destination file url already exists
            if let data = image.jpegData(compressionQuality: 1),
                !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    pickedImageURL = NSURL(string: fileURL.absoluteString)
                } catch {
                    print("error saving file:", error)
                }
            }
        }
        
        if let filePath = URL(string: pickedImageURL?.absoluteString ?? "") {
            userAvatar.sd_setImage(with: filePath, completed: nil)
        } else {
            userAvatar.image = image
        }
    }
    
    func authorizationStatus(_ status: AuthorizationStatusAccessType) {
        switch status {
        case .photoLibrary:
            checkAuthStatusForGallery()
        case .camera:
            checkAuthStatusForCamera()
        }
    }
    
    func checkAuthStatusForCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status{
        case .authorized:
            self.openCamera()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openCamera()
                }
            }
        case .denied, .restricted:
            self.openSettingsFor(.camera)
            return
            
        default:
            break
        }
    }
    
    func openSettingsFor(_ mediaType: AuthorizationStatusAccessType) {
        var title: String? = ""
        var message: String? = ""
        switch mediaType {
        case .camera:
            title = "Camera is not available"
            message = "Please, give permissions to use camera"
        case .photoLibrary:
            title = "No access to photos"
            message = "Please, give permissions to access photos."
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func checkAuthStatusForGallery() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            openPhotoGallery()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                        self.openPhotoGallery()
                    }
                }
            })
        case .restricted, .denied:
            self.openSettingsFor(.photoLibrary)
        @unknown default:
            break
        }
    }
    
    func openPhotoGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Validation
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func validateName(candidate: String) -> Bool {
        let regExp = "^[\\p{L}\\p{Pd}\\p{Zs}']{1,30}(?: [\\p{L}\\p{Pd}\\p{Zs}']+){0,1}$"
        
        return NSPredicate(format: "SELF MATCHES %@", regExp).evaluate(with: candidate)
    }
    
    func showErrorWithValidationType(type: ErrorValidationType) {
        let message = "\(type.rawValue) is not valid"
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    
    @objc func actionChangeAvatar(_ tapGesture: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let openCameraAlertAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            self.authorizationStatus(.camera)
        }
        let openPhotoLibraryAlertAction = UIAlertAction(title: "Open Gallery", style: .default) { (action) in
            self.authorizationStatus(.photoLibrary)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(openCameraAlertAction)
        alertController.addAction(openPhotoLibraryAlertAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        guard let isAdd = isAdd else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        let email = emailTextField.text ?? ""
        
        if !validateEmail(candidate: email) {
            showErrorWithValidationType(type: .email)
            return
        }
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        
        if !validateName(candidate: firstName) {
            showErrorWithValidationType(type: .firstName)
            return
        }
        
        if !validateName(candidate: lastName) {
            showErrorWithValidationType(type: .lastName)
            return
        }
        
        let storageService = StorageService()
        
        storageService.realm?.beginWrite()
        if isAdd {
            let newUser = StoredUser()
            newUser.firstName = firstName
            newUser.lastName = lastName
            newUser.email = email
            newUser.phoneNumber = phoneNumberTextField.text ?? ""
            newUser.avatarURLString = pickedImageURL?.absoluteString ?? selectedUser?.avatarURLString
            newUser.insertDate = Date()
            
            storageService.realm?.add(newUser)
        } else {
            selectedUser?.firstName = firstName
            selectedUser?.lastName = lastName
            selectedUser?.email = email
            selectedUser?.phoneNumber = phoneNumberTextField.text ?? ""
            selectedUser?.avatarURLString = pickedImageURL?.absoluteString ?? selectedUser?.avatarURLString
        }
        
        do {
            try storageService.realm?.commitWrite()
        } catch  {
            print("Error")
            print("Failed to \(isAdd ? "insert" : "update") item")
        }
        
        self.navigationController?.popToRootViewController(animated: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AZTabBarRequestAction"), object: nil)
    }
}
