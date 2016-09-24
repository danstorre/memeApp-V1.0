//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Daniel Torres on 9/18/16.
//  Copyright © 2016 Danieltorres. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

        
    @IBOutlet weak var imageFromPicker: UIImageView!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTF: UITextField!
    @IBOutlet weak var bottomTF: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var shareButtom: UIBarButtonItem!
    
    var userMeme : Meme = Meme()
    let customTFDelegate : MemeTextFieldDelegate = MemeTextFieldDelegate()
    let doesDeviceHaveCamera = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    let doesDeviceHavePhotoLibrary = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
    
    
    enum ButtonPicker : Int{
        case camera = 1, album
    }
    
    // MARK:- View Controller Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        topTF.delegate = customTFDelegate
        bottomTF.delegate = customTFDelegate
        shareButtom.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = doesDeviceHaveCamera
        libraryButton.isEnabled = doesDeviceHavePhotoLibrary
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK:- Button Actions
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        reset()
    }
    
    @IBAction func shareButton(_ sender: AnyObject) {
        
        
        guard let memeImage = generateMemedImage() else {
            return
        }
        let activityController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil )
        activityController.excludedActivityTypes = [UIActivityType.postToWeibo,UIActivityType.print, UIActivityType.copyToPasteboard, UIActivityType.assignToContact, UIActivityType.addToReadingList, UIActivityType.postToFlickr, UIActivityType.postToVimeo, UIActivityType.postToTencentWeibo, UIActivityType.airDrop, UIActivityType.openInIBooks]
        
        self.present(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = {
            (_, completed, returnedItems, error)
            in
            
            // Return if cancelled
            if (!completed) {
                return
            }
            
            self.alert()
            self.save(memeImage)
            self.reset()
        }
    }
    @IBAction func pickAnImage(_ sender: AnyObject) {
        let button = sender as! UIBarButtonItem
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        switch button.tag {
        case ButtonPicker.album.rawValue:
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        case ButtonPicker.camera.rawValue:
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickerController, animated: true, completion: nil)
        default:
            break
        }
    }

    
    // MARK:- Notifications Methods
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow) , name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide)    , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK:- Helper Methods
    
    func keyboardWillShow(_ notification: Notification) {
        if !topTF.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
            self.view.needsUpdateConstraints()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        self.view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage?
    {
        // Render view to an image
        topNavBar.isHidden = true
        bottomToolBar.isHidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topNavBar.isHidden = false
        bottomToolBar.isHidden = false
        return memedImage
    }
    
    func save(_ memeImage : UIImage) {
        //Create the meme
        guard let imageFromPicker = imageFromPicker.image else {
            return
        }
        userMeme = Meme(topText: topTF.text!, bottomText: bottomTF.text!, originalImage: imageFromPicker, memeImage: memeImage)
    }
    
    func reset(){
        userMeme = Meme()
        imageFromPicker.image = userMeme.originalImage
        topTF.text = userMeme.topText
        bottomTF.text = userMeme.bottomText
        shareButtom.isEnabled = false
    }
    
    func alert() {
        
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        var alerController = UIAlertController()
        alerController = UIAlertController(title: "Success!", message: "Your meme has been shared", preferredStyle: .alert)
        alerController.addAction(ok)
        self.present(alerController, animated: true, completion: nil)
    
    }
    
    // MARK:- Picker Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageFromPicker.image = image
            shareButtom.isEnabled = true
        }
        dismiss(animated: true, completion: nil);
        self.view.layoutIfNeeded()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil);
    }
    
    
}

