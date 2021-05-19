//
//  UdacityViewController.swift
//  OnTheMap
//
//  Created by DONALD CHWOJKO on 3/13/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import UIKit

class UdacityViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func viewWillAppear(animated: Bool) {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        
        
    }

    @IBAction func loginAction(sender: UIButton) {
        
        // Check for null entries in email/password text fields.
        if (emailTextField.text == "" || passwordTextField.text == "") {
            let alertController = UIAlertController(title: "Error", message: "Username and/or password is empty", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            performUIUpdatesOnMain( {
                self.activityIndicator.startAnimating()
            })
            UdacityClient.sharedInstance().authenticateUser(emailTextField.text!, password: passwordTextField.text!) { (success, errorString) in
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    if success {
                        self.loginSuccess()
                    } else {
                        self.loginFailed(errorString!)
                    }
                }   
            }
        }
    }
    
    private func loginSuccess() {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    private func loginFailed(errorString: String) {
        let alertController = UIAlertController(title: "Login Error", message: "There was a problem logging in: \(errorString)", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    @IBAction func signupAction(sender: UIButton) {
        let url = NSURL(string: "http://www.udacity.com")
        UIApplication.sharedApplication().openURL(url!)
    }
}
