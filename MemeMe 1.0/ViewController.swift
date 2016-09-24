//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Daniel Torres on 9/18/16.
//  Copyright © 2016 Danieltorres. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

        
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
    let doesDeviceHaveCamera = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    let doesDeviceHavePhotoLibrary = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    
    
    enum ButtonPicker : Int{
        case Camera = 1, Album
    }
    
    // MARK:- View Controller Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        topTF.delegate = customTFDelegate
        bottomTF.delegate = customTFDelegate
        shareButtom.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = doesDeviceHaveCamera
        libraryButton.enabled = doesDeviceHavePhotoLibrary
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK:- Button Actions
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        reset()
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        
        
        guard let memeImage = userMeme.memeImage else {
            return
        }
        let activityController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil )
        activityController.excludedActivityTypes = [UIActivityTypePostToWeibo,UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks]
        
        self.presentViewController(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            // Return if cancelled
            if (!completed) {
                return
            }
            self.reset()
            self.alert(activityType!)
            self.save()
        }
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        
        let button = sender as! UIBarButtonItem
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        switch button.tag {
        case ButtonPicker.Album.rawValue:
            pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(pickerController, animated: true, completion: nil)
        case ButtonPicker.Camera.rawValue:
            pickerController.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(pickerController, animated: true, completion: nil)
        default:
            break
        }
        
    }
    
    // MARK:- Notifications Methods
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow) , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide)    , name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK:- Helper Methods
    
    func keyboardWillShow(notification: NSNotification) {
        if !topTF.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
            self.view.needsUpdateConstraints()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func generateMemedImage() -> UIImage
    {
        // Render view to an image
        topNavBar.hidden = true
        bottomToolBar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topNavBar.hidden = false
        bottomToolBar.hidden = false
        return memedImage
    }
    
    func save() {
        //Create the meme
        guard let imageFromPicker = imageFromPicker.image else {
            return
        }
        userMeme = Meme(topText: topTF.text!, bottomText: bottomTF.text!, originalImage: imageFromPicker, memeImage: generateMemedImage())
    }
    
    func reset(){
        userMeme = Meme()
        imageFromPicker.image = userMeme.originalImage
        topTF.text = userMeme.topText
        bottomTF.text = userMeme.bottomText
        shareButtom.enabled = false
    }
    
    func alert(activityType : String) {
        
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        var alerController = UIAlertController()
        alerController = UIAlertController(title: "Success!", message: "Your meme has been shared", preferredStyle: .Alert)
        alerController.addAction(ok)
        self.presentViewController(alerController, animated: true, completion: nil)
    
    }
    
    // MARK:- Picker Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageFromPicker.image = image
            shareButtom.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil);
        self.view.layoutIfNeeded()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    
}

