//
//  MapViewController.swift
//  w3MapKit
//
//  Created by Jawaad Sheikh on 2016-06-16.
//  Copyright © 2016 Jawaad Sheikh. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    // Walk in clinic brampton
    let initialLocation = CLLocation(latitude: 43.772028, longitude: -79.661807)
    @IBOutlet var myMapView : MKMapView!
    @IBOutlet var tbLocEntered: UITextField!
    @IBOutlet var myTableView: UITableView!
   
    var routeSteps  = ["Enter your location to see the steps"] as NSMutableArray

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // this code is for getting current location.
        // still crashes on requestLocation()
        // don't forget to add plist entry asking for 
        // permission.
      /*  // 2
        //locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // 3
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
         }
 
        */
        
        // step 1 - center map on Clinic
        
        
        centerMapOnLocation(location: initialLocation)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = initialLocation.coordinate
        dropPin.title = "Walk in Clinic at 4515 Ebenezer"
        self.myMapView.addAnnotation(dropPin)
        self.myMapView.selectAnnotation( dropPin, animated: true)

      }
   
    
    // Step 2 - create an event handler to handle
    // user input for where to go
    @IBAction func findNewLocation(sender : UIButton)
    {
        // Step 2.1 get location text
        let locEnteredText = tbLocEntered.text
        
        
       // Step 2.2 convert text input to lat-lng 
        // using CLGeocoder object
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(locEnteredText!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                
                let alert = UIAlertController(title: "Error", message: "You Must Enter a Location. Cannot Be empty", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
            if let placemark = placemarks?.first {
                
                // Step 2.3 - convert location into lat-lng
                // and then center map there and drop a pin.
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                self.centerMapOnLocation(location: newLocation)
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = placemark.name
                self.myMapView.addAnnotation(dropPin)
                self.myMapView.selectAnnotation( dropPin, animated: true)
                
                // Step 3 - Calculate directions
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate:
                    coordinates,  addressDictionary: nil))
                
                
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.initialLocation.coordinate, addressDictionary: nil))
                
                
                request.requestsAlternateRoutes = false
                request.transportType = .automobile
                
                let directions = MKDirections(request: request)
                directions.calculate (completionHandler: { [unowned self] response, error in
                   // guard let unwrappedResponse = response else { return }
                    
                    for route in (response?.routes)! {
                        self.myMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                        self.myMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                        self.routeSteps.removeAllObjects()
                        for step in route.steps {
                            self.routeSteps.add(step.instructions)
                            
                            self.myTableView.reloadData();
                        }
                     
                    }
                })
                
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0;
        return renderer
    }
    
    
    // Step 0 - create a generic method to center
    // map at the desired location
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        myMapView.setRegion(coordinateRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeSteps.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()

        tableCell.textLabel?.text = routeSteps[indexPath.row] as? String
        
        return tableCell
        
    }
    

    
    
    
     /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
