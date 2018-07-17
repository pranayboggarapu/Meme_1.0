//
//  ViewController.swift
//  Meme_1.0
//
//  Created by Sai Venkata Pranay Boggarapu on 7/12/18.
//  Copyright © 2018 Sai Venkata Pranay Boggarapu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var topNav: UINavigationBar!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var cameraIcon: UIBarButtonItem!
    @IBOutlet weak var uiImageViewer: UIImageView!
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelImageEditing: UIBarButtonItem!
    @IBOutlet weak var shareImage: UIBarButtonItem!
    
    var textFieldBeingEdited: String = "topText"
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraIcon.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        initializeTextFields(topText, "TOP")
        initializeTextFields(bottomText, "BOTTOM")
        shareImage.isEnabled = false
        print("-------------------")
        print("view did load function called")
        print("-------------------")
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = ""
        if textField == topText {
            textFieldBeingEdited = "topText"
            
        } else {
            textFieldBeingEdited = "bottomText"
        }
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("-------------------")
        print("view will appear function called")
        print("-------------------")
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("-------------------")
        print("view will disappear function called")
        print("-------------------")
        unSubscribeToKeyboardNotifications()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if textFieldBeingEdited == "bottomText" {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unSubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func cameraPress(_ sender: Any) {
        let uiImageViewer = UIImagePickerController()
        uiImageViewer.delegate = self
        uiImageViewer.sourceType = .camera
        present(uiImageViewer, animated: true, completion: nil)
    }
    
    @IBAction func galleryPress(_ sender: Any) {
        let uiImageViewer = UIImagePickerController()
        uiImageViewer.delegate = self
        present(uiImageViewer, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Image picker controller called")
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            uiImageViewer.image = image
            shareImage.isEnabled = true
            uiImageViewer.contentMode = .scaleAspectFill
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image picker controller cancel button called")
        uiImageViewer.image = nil
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("-------------------")
        print("My function called")
        print("-------------------")
    }
    
    
    
    func initializeTextFields(_ textField: UITextField, _ placeHolderText: String) {
        textField.placeholder = placeHolderText
        textField.textAlignment = .center
        textField.contentHorizontalAlignment = .center
        textField.contentVerticalAlignment = .center
        textField.borderStyle = .none
        textField.layer.borderWidth = 0
        
        let memeTextAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.white/* TODO: fill in appropriate UIColor */,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white/* TODO: fill in appropriate UIColor */,
            
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: 5.0/* TODO: fill in appropriate Float */]
        
        textField.defaultTextAttributes = memeTextAttributes
        
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderText,
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        
        textField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Text field Did begin editing called")
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Text field should return called")
        textField.resignFirstResponder()
        return true
    }
    
    func save() {
        // Create the meme
        
         meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: uiImageViewer.image!, memedImage: generateMemedImage())
        
    }
    
    @IBAction func shareActionMethod(_ sender: Any) {
        
        save()
        
        let activityView = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil);
        present(activityView, animated: true, completion: nil)
        activityView.completionWithItemsHandler = {
            (activity, success, items, error) in
            if(success && error == nil){
                //Do Work
                self.dismiss(animated: true, completion: nil);
            }
            else if (error != nil){
                //log the error
            }
        };
        
    }
    
    
    
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        navBar.isHidden = true
        topNav.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        navBar.isHidden = false
        topNav.isHidden = false
        
        return memedImage
    }
    
    @IBAction func cancelSharing(_ sender: Any) {
        topText.text = ""
        bottomText.text = ""
        initializeTextFields(topText, "TOP")
        initializeTextFields(bottomText, "BOTTOM")
        if uiImageViewer.image != nil {
            cancelImageEditing.isEnabled = true
        }else {
            cancelImageEditing.isEnabled = false
        }
    }
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
}

