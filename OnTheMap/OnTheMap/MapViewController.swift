//
//  MapViewController.swift
//  OnTheMap
//
//  Created by DONALD CHWOJKO on 3/21/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    let regionRadius: CLLocationDistance = 1000000


    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        // Center map on middle of USA
        let initialLocation = CLLocation(latitude: 37.0902, longitude: -95.7129)
        centerMapOnLocation(initialLocation)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Reset student list */
        StudentList.sharedInstance().list.removeAll()
        
        /* Get list of students */
        ParseClient.sharedInstance().getStudentLocations() {(success, error) in
            if success {
                
                /* reset the map annotations, if they exist */
                if (self.mapView.annotations.count > 0) {
                    let existingAnnotations = self.mapView.annotations
                    performUIUpdatesOnMain() {
                        self.mapView.removeAnnotations(existingAnnotations)
                    }
                }
                
                /* create annotation for each student and add it to the annotation list */
                var annotationList = [MKPointAnnotation]()

                for student in StudentList.sharedInstance().list {
                    let latitude = CLLocationDegrees(student.latitude!)
                    let longitude = CLLocationDegrees(student.longitude!)
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(student.firstName!) \(student.lastName!)"
                    annotation.subtitle = "\(student.mediaURL!)"
                    annotationList.append(annotation)
                }
                
                /* update map with student annotations */
                performUIUpdatesOnMain() {
                    self.mapView.addAnnotations(annotationList)
                }
            } else {
                let alertController = UIAlertController(title: "Error", message: "There was a problem retrieving the student information", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 10.0, regionRadius * 10.0)
        performUIUpdatesOnMain() {
            self.mapView.setRegion(coordinateRegion, animated: true)
        }
    }

    @IBAction func actionLogout(sender: UIBarButtonItem) {
        
        UdacityClient.sharedInstance().deleteSession() { (success, error) in
            
            /* Complete logout on successful delete session */
            if success {
                self.completeLogout()
            } else {
                // present UIAlertController which calls completeLogout
                let alertController = UIAlertController(title: "Error", message: "There was an error logging out", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(alertAction)
                let alertCompletion = {self.completeLogout()}
                self.presentViewController(alertController, animated: true, completion: alertCompletion)
            }
        }
    }
    
    private func completeLogout() {
        performUIUpdatesOnMain() {
            /* reset user id */
            UdacityClient.sharedInstance().userId = nil
            
            /* return to initial login view */
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("udacityViewController") as! UdacityViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }

    @IBAction func actionPin(sender: UIBarButtonItem) {
        // TO DO:
        // If current student already exists, prompt user to either cancel or overwrite
        if ParseClient.sharedInstance().isCurrentStudentInStudentList() {
            let alertController = UIAlertController(title: nil, message: "You already have a pin for your location. Do you want to overwite or add a new pin?", preferredStyle: .ActionSheet)
            
            let overwriteAction = UIAlertAction(title: "Overwrite", style: .Default) { (action) in
                // TO DO: PUT (update) location
            }
            alertController.addAction(overwriteAction)
            
            let addNewPinAction = UIAlertAction(title: "Add New Pin", style: .Default) { (action) in
                self.goToInformationPosting()

            }
            alertController.addAction(addNewPinAction)
            
            let destroyAction = UIAlertAction(title: "Destroy", style: .Destructive) { (action) in
            }
            alertController.addAction(destroyAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            // Get object Id
            // Get user data
            // 
            
        } else {
            let viewController = storyboard?.instantiateViewControllerWithIdentifier("InformationPostingNavigationController") as! UINavigationController
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    private func goToInformationPosting() {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("InformationPostingNavigationController") as! UINavigationController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func actionRefresh(sender: UIBarButtonItem) {
        self.viewWillAppear(true)
    }

    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        // TO DO:
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
