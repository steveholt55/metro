//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class VehiclesViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var route: Route!
    var vehicles = [VehicleLocation]()
    static let segue = "showVehicles"
    
    let locationManager = CLLocationManager()
    var userPin: UserAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = route.name!
        showVehicles()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func showVehicles() {
        var annotations = [VehicleAnnotation]()
        for v in vehicles {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(v.vehicleLatitude!), longitude:  CLLocationDegrees(v.vehicleLongitude!))
            let annotation = VehicleAnnotation(direction: Direction.routeDirectionForInt(Int(v.direction!)), coordinate: location)
            self.mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
        self.mapView.showAnnotations(annotations, animated: true)
    }
    
    func refreshVehicleLocations() {
        VehicleLocation.getVehicles(route, success: { (vehicles) -> Void in
            
            self.vehicles = vehicles
            for v in vehicles {
                let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(v.vehicleLatitude!), longitude:  CLLocationDegrees(v.vehicleLongitude!))
                let annotation = VehicleAnnotation(direction: Direction.routeDirectionForInt(Int(v.direction!)), coordinate: location)
                self.mapView.addAnnotation(annotation)
            }
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
            }) { (routes, error) -> Void in
                
        }
    }
    
    // MARK : - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            //view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIView
        }
        return view
    }
    
    // MARK : - CLLocationManager delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        if let userPin = self.userPin {
            userPin.coordinate = coordinate
        } else {
            self.userPin = UserAnnotation(title: "You", coordinate: coordinate)
            mapView.addAnnotation(self.userPin!)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
}