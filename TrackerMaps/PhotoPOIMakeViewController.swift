//
//  PhotoPOIMakeViewController.swift
//  TrackerMaps
//
//  Created by Konstantin Kolontay on 12/7/15.
//  Copyright © 2015 Konstantin Kolontay. All rights reserved.
//

import UIKit
import Photos
import CoreData

class PhotoPOIMakeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var locations: [Location]?
    var placePIOs = [PlacePOI]()
    var delegate: StartTimerFromPause?
    var placePOI: PlacePOI?
    @IBOutlet weak var textFieldComment: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldComment.delegate = self
        if( UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            let picker: UIImagePickerController = UIImagePickerController()
            picker.sourceType = .Camera
            picker.delegate = self
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(alertAction)in
            alert.dismissViewControllerAnimated(true, completion: nil)
            }))
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object:  nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        adjustInsetForKeyboardShow(true, notification: notification)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let adjusmentHeight = (CGRectGetHeight(keyboardFrame) + 60) * (show ? 1 : -1)
        scrollView.contentInset.bottom += adjusmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjusmentHeight
    }
    
    @IBAction func pressedSave(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        if placePOI == nil {
         placePOI = NSEntityDescription.insertNewObjectForEntityForName("PlacePOI", inManagedObjectContext: (appDelegate?.managedObjectContext)!) as? PlacePOI
        }
        placePOI!.comment = textFieldComment.text
        
        placePIOs.append(placePOI!)
        let item = locations?.last
        item?.havePOI = true
        item?.placePOI = NSSet(array: placePIOs)
        //let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedObjectContext = appDelegate?.managedObjectContext
        if managedObjectContext!.hasChanges {
            do {
                try managedObjectContext!.save()
                placePOI = nil
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate!.startTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPhoto() {
        if( UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            let picker: UIImagePickerController = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
    }
    }
    @IBAction func makePhoto(sender: AnyObject) {
        self.addPhoto()
    }
    
    func randomString () -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let randomString : NSMutableString = NSMutableString(capacity: 10)
        for (var i=0; i < 10; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
       let image = (info as NSDictionary).objectForKey("UIImagePickerControllerOriginalImaga") as! UIImage
        self.imageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent((self.randomString() as String) + ".png")
        UIImagePNGRepresentation(image)!.writeToFile(fileURL.path!, atomically: true)
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        if placePOI == nil {
            placePOI = NSEntityDescription.insertNewObjectForEntityForName("PlacePOI", inManagedObjectContext: (appDelegate?.managedObjectContext)!) as? PlacePOI
        }
        placePOI!.pathPicture = fileURL.path
        
        }
}

extension PhotoPOIMakeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

