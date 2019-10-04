//
//  MemeEditorViewController.swift
//  Exper
//
//  Created by Brittany Mason on 8/21/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var share: UIBarButtonItem!
    
// MARK setup, disabling 'share' and 'camera' buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton?.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        share.isEnabled = false
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
    }
    
    func configureTextField(_ textField: UITextField) {
        textField.delegate = self
        textField.textAlignment = .center
        textField.defaultTextAttributes = [
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.black,
            .strokeWidth: -3.0
        ]
    }

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -3.0]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
     
    
    func getKeyboardHeight(_notification:Notification) -> CGFloat {
        let userInfo = _notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        //for if bottom of field is being edited
        if (bottomTextField.isEditing){
            //or bottomTextField.isFirstResponder
            view.frame.origin.y = -getKeyboardHeight(_notification: notification)
        }
      
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if self.view.frame.origin.y != 0 {
        self.view.frame.origin.y = 0
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
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image}
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(UIImagePickerController.SourceType.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(UIImagePickerController.SourceType.camera)
    }
    
    func pickAnImage(_ source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        share.isEnabled = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ topTextField: UITextField) {
        if topTextField.text!.isEmpty {
            topTextField.text = " "
        }
        
    }
    func textFieldBottomDidBeginEditing(_ bottomTextField: UITextField) {
        if bottomTextField.text!.isEmpty {
            bottomTextField.text = " "
        }
    }

    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    // MARK: Saving Image
    func save() -> FullMeme{
        let xpto = FullMeme(
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            originalImage: imagePickerView.image!,
            memedImage: generateMemedImage())
        
        
//        let object = UIApplication.shared.delegate
//        let appDelegate = object as! AppDelegate
//        appDelegate.memes.append(xpto)
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(xpto)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.memes.append(xpto)
        print("meme saved")
        
        return xpto
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Share(_ sender: Any) {
        
        let sharedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems:    [sharedImage], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = { activity, success, items, error in
            if (success) {
                let _ = self.save()
                // Logic to save meme, will not save if not successful
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        
        
        
    }
    
}

