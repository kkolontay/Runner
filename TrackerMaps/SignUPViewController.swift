//
//  SignUPViewController.swift
//  TrackerMaps
//
//  Created by Konstantin Kolontay on 12/12/15.
//  Copyright © 2015 Konstantin Kolontay. All rights reserved.
//

import UIKit
import Parse

class SignUPViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldEMail: UITextField!

    @IBOutlet weak var textFieldNameOfGroup: UITextField!
    @IBAction func pressedSignUp(sender: AnyObject) {
        let user = PFUser()
        user.username = textFieldName.text
        user.password = textFieldPassword.text
        user.setValue(textFieldNameOfGroup.text, forKey: "nameOfGroup")
        if isValidEmail(textFieldEMail.text!) {
        user.email = textFieldEMail.text
        user.signUpInBackgroundWithBlock({succeeded, error in
            if(succeeded) {
                self.performSegueWithIdentifier("mainWindow", sender: nil)
            } else {
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = "Wrong login or password"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        })
        } else {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Wrong e-mail"
            alert.addButtonWithTitle("OK")
            alert.show()
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }

    }
