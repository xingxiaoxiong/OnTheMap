//
//  TabBarController.swift
//  OnTheMap
//
//  Created by shapeare on 7/10/15.
//  Copyright (c) 2015 BettyBearStudio. All rights reserved.
//

import UIKit

var studentLocations: [StudentLocation] = [StudentLocation]()

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        let addLocationButton = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "addLocation")
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refresh")
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.setRightBarButtonItems([refreshButton, addLocationButton], animated: false)
        
    }
        
    func addLocation() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func refresh() {
        SLClient.sharedInstance().getLocations { locations, error in
            if let locations = locations {
                studentLocations = locations
                NSNotificationCenter.defaultCenter().postNotificationName("Refresh", object: nil)
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    displayAlertView(self, SLClient.Constants.DownloadError)
                })
            }
        }
        
    }
    
    func logout() {
        SLClient.sharedInstance().logout{ (success, error) in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                displayAlertView(self, error!)
            }
        }
        
    }
    

}
