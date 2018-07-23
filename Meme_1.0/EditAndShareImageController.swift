//
//  ViewController.swift
//  Meme_1.0
//
//  Created by Sai Venkata Pranay Boggarapu on 7/12/18.
//  Copyright © 2018 Sai Venkata Pranay Boggarapu. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Dispatch

class EditAndShareImageController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    //MARK:- Initialization and Declaration
    
    //MARK: Bottom Text
    @IBOutlet weak var bottomText: UITextField!
    
    //MARK: Top Text
    @IBOutlet weak var topText: UITextField!
    
    //MARK:Top Nav Bar
    @IBOutlet weak var topNav: UINavigationBar!
    
    //MARK: Bottom Tool Bar
    @IBOutlet weak var navBar: UIToolbar!
    
    //MARK:Camera Icon
    @IBOutlet weak var cameraIcon: UIBarButtonItem!
    
    //MARK:Image viewer
    @IBOutlet weak var uiImageViewer: UIImageView!
    
    //MARK: Gallery button
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    
    //MARK: Cancel Image Editing
    @IBOutlet weak var cancelImageEditing: UIBarButtonItem!
    
    //MARK: Share Image Button
    @IBOutlet weak var shareImage: UIBarButtonItem!
    
    
    
    //MARK: Meme variable
    var meme: Meme!
    
    //MARK: Variables for Camera and gallery access description
    var cameraAccessDescription:AVAuthorizationStatus = AVAuthorizationStatus.notDetermined
    var galleryAccessDescription:PHAuthorizationStatus = PHAuthorizationStatus.notDetermined
    
    //MARK:- View Did Load function
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //MARK:To enable camera only when it is available
        cameraIcon.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        //MARK:Initialize the text fields
        initializeTextFields(topText, "TOP")
        initializeTextFields(bottomText, "BOTTOM")
        
        //MARK:Center alignment for text fields
        topText.textAlignment = .center
        bottomText.textAlignment = .center
        //MARK:Disable the share icon untill editing is complete
        shareImage.isEnabled = false
        
    }
    //MARK:- View will appear function
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //MARK: Disable share and cancel buttons
        if uiImageViewer.image == nil {
            shareImage.isEnabled = false
            cancelImageEditing.isEnabled = false
        }
        
        //MARK: Subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
    }
    
    //MARK:- View will Disappear function
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //MARK: Unsubscribe from keyboard notifications
        unSubscribeToKeyboardNotifications()
    }
    //MARK:- Initialize text fields function
    func initializeTextFields(_ textField: UITextField, _ placeHolderText: String) {
        
        //MARK: Insert place holder text
        textField.placeholder = placeHolderText
        
        //MARK: Border style and borderwidth
        textField.borderStyle = .none
        textField.layer.borderWidth = 0
        
        //MARK: Font color and attributes
        let memeTextAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black/* TODO: fill in appropriate UIColor */,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white/* TODO: fill in appropriate UIColor */,
            
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -5.0/* TODO: fill in appropriate Float */]
        
        textField.defaultTextAttributes = memeTextAttributes
        
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderText,
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        //MARK: assign the delegate to self
        textField.delegate = self
    }

    //MARK:- Text field should begin editing function
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //MARK: empty the placeholder
        textField.placeholder = ""
        
        return true
    }
    
    //MARK:- Text field did begin editing function
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //MARK: empty the placeholder
        textField.placeholder = ""
    }
    
    //MARK:- Text field should return function - function implemented after return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Function to change the keyboard height change in order to show bottom text
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomText.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    //MARK:- Function to change the keyboard height to zero in order to show everything AS-IS
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomText.isEditing {
            view.frame.origin.y = 0
        }
    }
    //MARK:- Function to get keyboard height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //MARK:- Subscribe to keyboard notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    //MARK:- Un-Subscribe to keyboard notifications
    func unSubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK:- Function to execute when Camera icon is pressed
    @IBAction func cameraPress(_ sender: Any) {
        
        //MARK: Present the UIImagePicker
        showPickerController(.camera)
        
        //MARK: Capture users permission
        captureAuthorizationStatus_Camera()
        
    }
    
    //MARK:- Function to show UIImagePickerController
    func showPickerController(_ pickerType: UIImagePickerControllerSourceType) {
        let uiImageViewer = UIImagePickerController()
        uiImageViewer.delegate = self
        uiImageViewer.sourceType = pickerType
        present(uiImageViewer, animated: true, completion: nil)
    }
    
    //MARK:- Capture authorization status for camera
    func captureAuthorizationStatus_Camera() {
        //MARK: Capture the authorization status
        cameraAccessDescription = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        //MARK: If authorization status is missing
        if(cameraAccessDescription != .authorized) {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { granted in
                if granted {
                    self.cameraAccessDescription = .authorized
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    //MARK:- Capture authorization status for gallery
    func captureAuthorizationStatus_Gallery() {
        //MARK: Capture the authorization status
        galleryAccessDescription = PHPhotoLibrary.authorizationStatus()
        
        //MARK: If authorization status is missing
        if galleryAccessDescription != .authorized {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.galleryAccessDescription = .authorized
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    //MARK:- Function to execute when Gallery icon is pressed
    @IBAction func galleryPress(_ sender: Any) {
        //MARK: Present the UIImagePicker
        showPickerController(.photoLibrary)
        //MARK: Capture user's permission
        captureAuthorizationStatus_Gallery()
    }
    
    //MARK:- Gallery view selecting an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            uiImageViewer.image = image
            shareImage.isEnabled = true
            cancelImageEditing.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Gallery view cancel button press function
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        uiImageViewer.image = nil
        shareImage.isEnabled = false
        cancelImageEditing.isEnabled = false
        dismiss(animated: true, completion: nil)
    }
   
    //MARK:- Save the function
    func save() {
        // Create the meme
         meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: uiImageViewer.image!, memedImage: generateMemedImage())
        
    }
    
    //MARK:- Share Image
    @IBAction func shareActionMethod(_ sender: Any) {
        
        //MARK: Save function call
        save()
        
        //MARK: present activity view controller
        let activityView = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil);
        present(activityView, animated: true, completion: nil)
        activityView.completionWithItemsHandler = {
            (activity, success, items, error) in
            if(success && error == nil){
                self.save()
                self.dismiss(animated: true, completion: nil);
            }
            else if (error != nil){
            }
        };
        
    }
    
    //MARK:- Generate Meme Image
    func generateMemedImage() -> UIImage {
        
        // MARK: Hide toolbar and navbar
        navBar.isHidden = true
        topNav.isHidden = true
        
        //MARK: Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // MARK: Show toolbar and navbar
        navBar.isHidden = false
        topNav.isHidden = false
        
        return memedImage
    }
    
    //MARK:- Cancel sharing
    @IBAction func cancelSharing(_ sender: Any) {
        //MARK:- Empty text fields
        topText.text = ""
        bottomText.text = ""
        //MARK: Initialize text fields
        initializeTextFields(topText, "TOP")
        initializeTextFields(bottomText, "BOTTOM")
        //MARK: Text alignment
        topText.textAlignment = .center
        bottomText.textAlignment = .center
        
        
    }
    
    //MARK:- changing view mode
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            uiImageViewer.contentMode = .scaleAspectFit
        } else if UIDevice.current.orientation.isLandscape {
            uiImageViewer.contentMode = .scaleAspectFit
        }
    }
    
    //MARK: Meme struct
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
}

