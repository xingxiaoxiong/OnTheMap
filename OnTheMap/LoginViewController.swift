//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by shapeare on 7/4/15.
//  Copyright (c) 2015 BettyBearStudio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        session = NSURLSession.sharedSession()
        
        self.configureUI()
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonTouch(sender: BorderedButton) {
        if IJReachability.isConnectedToNetwork() {
            if emailTextField.text.isEmpty {
                displayAlertView(self, "Email cannot be empty")
            } else if passwordTextField.text.isEmpty {
                displayAlertView(self, "Password cannot be empty")
            } else {
                SLClient.sharedInstance().authenticateWithViewController(emailTextField.text, password: passwordTextField.text) { (success, errorString) in
                    if success {
                        self.completeLogin()
                    } else {
                        if let errorString = errorString{
                            dispatch_async(dispatch_get_main_queue(), {
                                displayAlertView(self, errorString)
                            })
                        }
                    }
                }
            }
        } else {
            displayAlertView(self, "No network connection")
        }
        
    }
    
    @IBAction func signUp(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
    }
    
    // MARK: - TextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - LoginViewController
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }

    func configureUI() {
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 1.0, green: 0.584, blue: 0.208, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 1.0, green: 0.431, blue: 0.157, alpha: 1.0).CGColor
        var backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        emailTextField.backgroundColor = UIColor(red: 1.0, green: 0.773, blue: 0.6, alpha:1.0)
        emailTextField.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        passwordTextField.backgroundColor = UIColor(red: 1.0, green: 0.773, blue: 0.6, alpha:1.0)
        passwordTextField.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        loginButton.highlightedBackingColor = UIColor(red: 1.0, green: 0.3, blue: 0.1, alpha:1.0)
        loginButton.backingColor = UIColor(red: 0.976, green:0.325, blue:0.125, alpha: 1.0)
        loginButton.backgroundColor = UIColor(red: 1.0, green:0.300, blue:0.1, alpha: 1.0)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    
}

