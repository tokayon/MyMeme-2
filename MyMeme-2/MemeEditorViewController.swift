//
//  ViewController.swift
//  MyMeme-2
//
//  Created by SergeSinkevych on 30.03.16.
//  Copyright © 2016 Sergii Sinkevych. All rights reserved.
//

import UIKit
import AVFoundation

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var topTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var fontButton: UIBarButtonItem!
    
    var inputMeme : Meme? = nil
    var fontIterator = 0
    var imageRect = CGRectZero
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor .blackColor(),
        NSForegroundColorAttributeName : UIColor .whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 35)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0)
    ]
    
    let barButtonTextAttributes = [
        NSFontAttributeName: UIFont(name: "IowanOldStyle-BoldItalic", size: 26.0)!,
        NSForegroundColorAttributeName: UIColor.darkGrayColor()
    ]
    
    let fontArray = ["Copperplate-Bold", "GillSans-UltraBold", "Optima-Regular", "Cochin-Bold", "Impact"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitials()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        if let inputMeme = inputMeme {
            imageView.image = inputMeme.image
            topTextField.text = inputMeme.topText
            bottomTextField.text = inputMeme.bottomText
        }
        
        if imageView.image != nil {
            shareButtonItem.enabled = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateTextfieldConstraintsWithRect()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeToKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: Initials
    
    func setInitials() {
        setTextAttributes(topTextField, text: "TOP")
        setTextAttributes(bottomTextField, text: "BOTTOM")
        fontButton.setTitleTextAttributes(barButtonTextAttributes, forState: UIControlState.Normal)
        imageView.image = nil
        shareButtonItem.enabled = false
    }
    
    func setTextAttributes(textField: UITextField, text: String) {
        textField.delegate = self
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.resignFirstResponder()
    }
    
    //MARK: Notifications
    
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func unSubscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    //MARK: Notification's handling
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func orientationDidChange() {
        updateTextfieldConstraintsWithRect()
    }
    
    //MARK: Common methods
    
    func getImage(sourcetype: UIImagePickerControllerSourceType  ) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourcetype
        pickerController.allowsEditing = true
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {

        //Crop image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let inputImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let cropRect = CGRectMake(self.view.frame.size.width/2 - imageRect.width/2,
                                    self.view.frame.size.height/2 - imageRect.height/2,
                                    imageRect.width, imageRect.height)
        let imageRef : CGImageRef = CGImageCreateWithImageInRect(inputImage.CGImage, cropRect)!
        let memedImage = UIImage(CGImage: imageRef)
        
        return memedImage
    }
    
    func save() {
        let memedImage = generateMemedImage()
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memedImage: memedImage)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func getRectOfImage(image: UIImage, imageView: UIImageView) -> CGRect {
        let rect = AVMakeRectWithAspectRatioInsideRect(image.size, imageView.bounds)
        imageRect = rect
        return rect
    }
    
    func updateTextfieldConstraintsWithRect() {
        if imageView.image != nil {
            let rect = getRectOfImage(imageView.image!, imageView: imageView)
            if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
                topTextFieldConstraint.constant = 54
                bottomTextFieldConstraint.constant = -54
            } else {
                topTextFieldConstraint.constant =
                    rect.origin.y + 10
                bottomTextFieldConstraint.constant =
                    rect.origin.y + rect.size.height - imageView.frame.height - 10
            }
        }
    }
    
    func fontChanger() {
        fontIterator++ > 3 ? (fontIterator = 0) : (fontIterator = fontIterator)
        let font = UIFont(name: fontArray[fontIterator], size: 35)!
        topTextField.font = font
        bottomTextField.font = font
    }
    
    //MARK: Actions
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        self.setInitials()
    }
    
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        getImage(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        getImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    @IBAction func changeFont(sender: UIBarButtonItem) {
        fontChanger()
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        updateTextfieldConstraintsWithRect()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
}

