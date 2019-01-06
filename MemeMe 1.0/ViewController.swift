//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by FarouK on 26/10/2018.
//  Copyright © 2018 FarouK. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageEditing: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var buttomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var upperToolBar: UIToolbar!
    @IBOutlet weak var lowerToolBar: UIToolbar!
    
    //Creating the delegate so we can assign it to the textFields
    let textFieldCustomDelegate = TextFieldCustomDelegate()
    
    //Here we define the textFields default attributes
    let  memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor : UIColor.black ,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.strokeWidth : -5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the custom delegates for the textFields
        topTextField.delegate = textFieldCustomDelegate
        buttomTextField.delegate = textFieldCustomDelegate
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        changetextFieldProperties()
        subscribeToKeyboardNotifications()
        enableOrDisableSharing()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func changetextFieldProperties() {
        //Here we edit the textFeilds from code to match what we want
        topTextField.defaultTextAttributes = memeTextAttributes
        buttomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        buttomTextField.text = "BUTTOM"
        topTextField.textAlignment = .center
        buttomTextField.textAlignment = .center
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageEditing.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pickImageButtonDidPressed(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func cameraButtonDidPressed(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if buttomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        if buttomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    
    
    func generateMemedImage() -> UIImage {
        
        changeToolBarsState(State: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        changeToolBarsState(State: false)
        
        return memedImage
    }
    
    func changeToolBarsState(State: Bool){
        // if we want to hide the toolbars we pass true to the argument, passing false will bring them back
        if State {
            upperToolBar.isHidden = true
            lowerToolBar.isHidden = true
        }
            
        else {
            upperToolBar.isHidden = false
            lowerToolBar.isHidden = false
        }
        
    }
    
    //This faunctions ensures where the Share Button should be enabled or disabled
    func enableOrDisableSharing(){
        
        if imageEditing.image == nil {
            shareButton.isEnabled = false
        }
        else {
            shareButton.isEnabled = true
        }
    }
    
    // this function will be implemented in version 2.0, so I won't delete it now from the code
    
    func save(){
        // Create the meme
        let meme = Meme(topText: topTextField.text!, buttomText: buttomTextField.text!, image: imageEditing.image!, memedImage: generateMemedImage())
    }
    
    @IBAction func shareActionDidPressed(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }
            self.save()
        }
        
        
    }
    
    //Hiding the status bar using code
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //Resetting the editor to default state
    @IBAction func cancelButtonDidPressed(_ sender: Any) {
        
        imageEditing.image = nil
        topTextField.text = "TOP"
        buttomTextField.text = "BUTTOM"
        enableOrDisableSharing()
        
    }
    
}

