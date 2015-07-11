//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by shapeare on 7/8/15.
//  Copyright (c) 2015 BettyBearStudio. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var location = StudentLocation(latitude: 0.0, longitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        self.view.addGestureRecognizer(tapRecognizer)
        
        locationTextView.delegate = self
        linkTextField.delegate = self
        mapView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTouch(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findButtonTouch(sender: UIButton) {
        let geoCoder = CLGeocoder()
        let addressString = locationTextView.text
        location.mapString = locationTextView.text
        activityIndicator.startAnimating()
        geoCoder.geocodeAddressString(addressString, completionHandler:
            {(placemarks: [AnyObject]!, error: NSError!) in
                self.activityIndicator.stopAnimating()
                if error != nil {
                    displayAlertView(self, "Geocode failed")
                } else if placemarks.count > 0 {
                    let placemark = placemarks[0] as! CLPlacemark
                    let location = placemark.location
                    self.location.latitude = location.coordinate.latitude
                    self.location.longitude = location.coordinate.longitude
                    self.showMap(location)
                    
                }
        })
        
    }
    
    @IBAction func submitButtonTouch(sender: UIButton) {
        if linkTextField.text == "Enter a Link to Share Here" || linkTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            displayAlertView(self, "Must enter a link")
        } else {
            location.mediaURL = linkTextField.text
            SLClient.sharedInstance().postLocation(location) { (success, error) in
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    displayAlertView(self, "Error submitting")
                }
            }
        }
    }
    
    // MARK: - Dismiss Keyboard
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return locationTextView.isFirstResponder() || linkTextField.isFirstResponder()
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        if locationTextView.text == "Enter Your Location Here" {
            locationTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if locationTextView.text == "" {
            locationTextView.text = "Enter Your Location Here"
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if linkTextField.text == "Enter a Link to Share Here" {
            linkTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - InformationPostingViewController
    
    func configureUI() {
        self.view.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1.0)
        var whereQuestion = NSMutableAttributedString(string: "Where are you\n studying\n today?")
        whereQuestion.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(23), range: NSMakeRange(15, 8))
        whereLabel.attributedText = whereQuestion
        
        linkTextField.hidden = true
        submitButton.hidden = true
        
        mapView.hidden = true
        mapView.zoomEnabled = false
        mapView.scrollEnabled = false
        mapView.pitchEnabled = false
        mapView.rotateEnabled = false
    }
    
    func showMap(location: CLLocation) {
        linkTextField.hidden = false
        cancelButton.tintColor = UIColor.whiteColor()
        mapView.hidden = false
        submitButton.hidden = false
        var studentLocation = StudentLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.setRegion(MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.02, 0.01)), animated: false)
        mapView.addAnnotation(studentLocation)
    }

}

extension InformationPostingViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if let location = annotation as? StudentLocation {
            var view = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as! MKPinAnnotationView!
            if view == nil {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                view.draggable = false
                view.canShowCallout = false
                view.animatesDrop = false
            } else {
                view.annotation = annotation
            }
            view.pinColor = MKPinAnnotationColor.Red
            return view
        }
        
        return nil
    }
}
