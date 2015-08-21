//
//  ViewController.swift
//  MapLocator
//
//  Created by Malek T. on 4/24/15.
//  Copyright (c) 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBOutlet var mapView: MKMapView!
    @IBAction func showSearchBar(sender: AnyObject) {
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        // Present the view controller
        presentViewController(searchController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0] as! MKAnnotation
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude:     localSearchResponse.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation)
        }
    }
}

