//
//  helper.swift
//  OnTheMap
//
//  Created by shapeare on 7/10/15.
//  Copyright (c) 2015 BettyBearStudio. All rights reserved.
//

import Foundation
import UIKit

func displayAlertView(controller: UIViewController, message: String, title: String? = nil) {
    var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
    controller.presentViewController(alert, animated: true, completion: nil)
}

func launchSafari(controller: UIViewController, urlString: String?) {
    if let url = NSURL(string: urlString!) {
        UIApplication.sharedApplication().openURL(url)
    } else {
        displayAlertView(controller, "Not a valid URL")
    }
}