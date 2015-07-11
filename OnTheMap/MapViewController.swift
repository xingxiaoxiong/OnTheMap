//
//  MapViewController.swift
//  OnTheMap
//
//  Created by shapeare on 7/8/15.
//  Copyright (c) 2015 BettyBearStudio. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        SLClient.sharedInstance().getLocations { locations, error in
            if let locations = locations {
                studentLocations = locations
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(studentLocations)
                }
            } else {
                displayAlertView(self, SLClient.Constants.DownloadError)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name:"Refresh", object: nil)
        
        mapView.addAnnotations(studentLocations)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "Refresh", object: nil)
        
        super.viewWillDisappear(animated)
    }
    
    func refresh() {
        mapView.addAnnotations(studentLocations)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if let location = annotation as? StudentLocation {
            var view = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as! MKPinAnnotationView!
            if view == nil {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                view.canShowCallout = true
                view.animatesDrop = false
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView =
                    UIButton.buttonWithType(.DetailDisclosure) as! UIView
            } else {
                view.annotation = annotation
            }
            view.pinColor = MKPinAnnotationColor.Red
            return view
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if let location = view.annotation as? StudentLocation {
            launchSafari(self, location.mediaURL)
        }
    }
    
}

