//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by shapeare on 7/10/15.
//  Copyright (c) 2015 BettyBearStudio. All rights reserved.
//

import UIKit

class LocationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        SLClient.sharedInstance().getLocations { locations, error in
            if let locations = locations {
                studentLocations = locations
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                displayAlertView(self, SLClient.Constants.DownloadError)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name:"Refresh", object: nil)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "Refresh", object: nil)
        
        super.viewWillDisappear(animated)
    }
    
    
    func refresh() {
        println("table data refreshed")
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath) as! UITableViewCell
        let location = studentLocations[indexPath.row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.imageView?.image = UIImage(named: "Pin")
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        launchSafari(self, studentLocations[indexPath.row].mediaURL)
    }

}
