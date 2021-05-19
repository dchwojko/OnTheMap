//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by DONALD CHWOJKO on 4/2/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    var longitude: Double!
    var latitude: Double!
    var currentStudent: StudentInformation!
    
    let regionRadius: CLLocationDistance = 1000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        label.hidden = false
        locationTextField.hidden = false
        findOnTheMapButton.hidden = false
        urlTextField.hidden = true
        submitButton.hidden = true
        mapView.hidden = true
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        
        urlTextField.delegate = self
        locationTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    
    @IBAction func actionCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func actionFind(sender: UIButton) {
        performUIUpdatesOnMain() {
            self.activityIndicator.startAnimating()
        }
        
        forwardGeocoding(locationTextField.text!)
        
    }
    
    func forwardGeocoding(address: String) {
        
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                // NOTE: too many requests in a short period of time might cause an error per Apple's documentation
                // This is the error that might be thrown 'Error Domain=kCLErrorDomain Code=2 "(null)"'

                performUIUpdatesOnMain() {
                    self.activityIndicator.stopAnimating()
                }
                if let error = error {
                    
                    let alertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            } else {
                
                if placemarks?.count > 0 {
                    let placemark = placemarks?[0]
                    let location = placemark?.location
                    let coordinate = location?.coordinate
                    
                    self.latitude = coordinate?.latitude
                    self.longitude = coordinate?.longitude
                    
                    let yourLocation = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
                    performUIUpdatesOnMain() {
                        self.centerMapOnLocation(yourLocation)
                    }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate!
                    annotation.title = nil
                    annotation.subtitle = nil
                    performUIUpdatesOnMain() {
                        self.activityIndicator.stopAnimating()
                        self.mapView.addAnnotation(annotation)
                        self.activityIndicator.stopAnimating()
                        self.label.hidden = true
                        self.locationTextField.hidden = true
                        self.findOnTheMapButton.hidden = true
                        self.urlTextField.hidden = false
                        self.submitButton.hidden = false
                        self.mapView.hidden = false
                    }
                } else {
                    // Could not find any place marks
                    performUIUpdatesOnMain() {
                        self.activityIndicator.stopAnimating()
                    }
                    let alertController = UIAlertController(title: "Error", message: "Unable to find any placemarks for: \(address)", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        })
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        performUIUpdatesOnMain() {
            self.mapView.setRegion(coordinateRegion, animated: true)
        }
    }

    @IBAction func submitAction(sender: UIButton) {
        /* GUARD: urlTextField is empty */
        guard urlTextField.text != "" else {
            let alertController = UIAlertController(title: "Error", message: "URL text field is empty. Please enter a URL", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        
        let dictionary: [String:AnyObject] = [
            "uniqueKey":UdacityClient.sharedInstance().userId!,
            "firstName":UdacityClient.sharedInstance().firstName!,
            "lastName":UdacityClient.sharedInstance().lastName!,
            "mapString":locationTextField.text!,
            "mediaURL":urlTextField.text!,
            "latitude":latitude,
            "longitude":longitude
            ]
        let currentUser = StudentInformation(dictionary: dictionary)
        ParseClient.sharedInstance().postStudentLocation(currentUser) { (success, errorString) in
            if success {
                let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
                performUIUpdatesOnMain() {
                    self.presentViewController(viewController, animated: true, completion: nil)
                }
            } else {
                let alertController = UIAlertController(title: "Error", message: "There was an error posting your information.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pinView!.canShowCallout = true
        pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            var url: NSURL
            url = NSURL(string: view.annotation!.subtitle!!)!
            UIApplication.sharedApplication().openURL(url)
        }
    }

}
