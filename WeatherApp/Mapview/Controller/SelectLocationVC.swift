//
//  SelectLocationVC.swift
//  WeatherApp
//
//  Created by Padam on 23/05/23.
//

import UIKit
import MapKit
import CoreLocation
class SelectLocationVC: BaseVC,MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var location:CLLocation?
    var viewModel = SelectLocationVM()
    var objectAnnotation:MKPointAnnotation?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Select Location"
        self.mapView.delegate = self
       
       LocationManager.shared.getLocation(completionHandler: { location, error in
            DispatchQueue.main.async {
                if let location = location{
                    self.location = location
                   
                    self.addPin()
                }
            }
        })
       
    }
    
    func addPin() {
            let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
            objectAnnotation = MKPointAnnotation()
            objectAnnotation?.coordinate = pinLocation
            objectAnnotation?.title = "My Location"
            self.mapView.addAnnotation(objectAnnotation!)
            let center = CLLocationCoordinate2D(latitude: location?.coordinate.latitude ?? 0.0, longitude: location?.coordinate.longitude ?? 0.0)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
       }
    
    @IBAction func saveBtnTapped(sender: UIBarButtonItem) {
        if let coordinates = self.objectAnnotation?.coordinate{
            viewModel.saveLocation(coordinates: coordinates) { success in
                if success{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
   
   
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
      
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
                annotationView.image = UIImage(named: "pin")!
                annotationView.isDraggable = true
                return annotationView
          

    }
    

}
