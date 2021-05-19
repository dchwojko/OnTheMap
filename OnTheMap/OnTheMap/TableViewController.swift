//
//  TableViewController.swift
//  OnTheMap
//
//  Created by DONALD CHWOJKO on 3/21/16.
//  Copyright © 2016 DONALD CHWOJKO. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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


    @IBAction func actionRefresh(sender: UIBarButtonItem) {
        ParseClient.sharedInstance().getStudentLocations() { (success, error) in
            if success {
                self.tableView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Error", message: "There was a problem refreshing the data", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(alertAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
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
            
            
        } else {
            let viewController = storyboard?.instantiateViewControllerWithIdentifier("InformationPostingNavigationController") as! UINavigationController
            self.presentViewController(viewController, animated: true, completion: nil)
        }

    }
    
    private func goToInformationPosting() {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("InformationPostingNavigationController") as! UINavigationController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = StudentList.sharedInstance().list.count
        return rowCount
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("rowIdentifier", forIndexPath: indexPath)

        let student = StudentList.sharedInstance().list[indexPath.row]
        let name = student.firstName! + " " + student.lastName!
        let mediaURL = student.mediaURL!
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = mediaURL

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let selectedStudent = StudentList.sharedInstance().list[indexPath.row]
        if let url = NSURL(string: selectedStudent.mediaURL!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

}
