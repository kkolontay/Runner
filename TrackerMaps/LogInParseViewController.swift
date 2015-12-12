//
//  LogInParseViewController.swift
//  TrackerMaps
//
//  Created by Konstantin Kolontay on 12/12/15.
//  Copyright © 2015 Konstantin Kolontay. All rights reserved.
//

import UIKit
import Parse

class LogInParseViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func pressLogIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(nameTextField.text!, password: passwordTextField.text! ){ user, error in
            if user != nil {
                self.performSegueWithIdentifier("toTable", sender: nil)
            }
            else if error != nil {
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = "Wrong login or password, please check it"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
    }
    @IBAction func pressSignUp(sender: AnyObject) {
        self.performSegueWithIdentifier("toSignUP", sender: nil)
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

}
