//
//  SelectLocationVM.swift
//  WeatherApp
//
//  Created by Padam on 23/05/23.
//

import Foundation
import CoreData
import CoreLocation
import UIKit
class SelectLocationVM{
    func saveLocation(coordinates:CLLocationCoordinate2D,_ completion: @escaping (_ success: Bool)-> Void){
        LocationManager.shared.getReverseGeoCodedLocation(location: CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)) { location, placemark, error in
            if let pm = placemark{
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                if pm.locality != nil {
                    addressString =  pm.locality ?? ""
                }
                DispatchQueue.main.async {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let userEntity = NSEntityDescription.entity(forEntityName: "City", in: managedContext)!
                    let city = NSManagedObject(entity: userEntity, insertInto: managedContext)
                    city.setValue(addressString, forKeyPath: "cityName")
                    city.setValue(location?.coordinate.latitude ?? 0.0, forKey: "latitude")
                    city.setValue(location?.coordinate.longitude ?? 0.0, forKey: "longitute")
                    do {
                        try managedContext.save()
                        completion(true)
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                        completion(false)
                    }
                }
            }
        }
    }
}
