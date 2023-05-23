//
//  HomeVM.swift
//  WeatherApp
//
//  Created by Padam on 23/05/23.
//

import Foundation
import CoreData
import UIKit
class HomeVM{
    var arrLocation:[Location] = []
    func retriveFavoriteLocation(searchText:String = "",_ completion: @escaping (_ locations: [Location])-> Void){
        self.arrLocation.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let cityName = data.value(forKey: "cityName") as? String ?? ""
                let latitude =  data.value(forKey: "latitude") as? Double ?? 0.0
                let longitute =  data.value(forKey: "longitute") as? Double ?? 0.0
                if cityName.starts(with: searchText){
                    let location = Location(cityName: cityName, latitude: latitude, longitute: longitute)
                    self.arrLocation.append(location);
                    completion(self.arrLocation)
                }
               
            }
        } catch {
            print("Failed")
            completion([])
        }
    }
    
    
    
    
    func removeLocation(location:Location,_ completion: @escaping (_ success: Bool)-> Void){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        fetchRequest.predicate = NSPredicate(format: "cityName = %@", location.cityName)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do{
                try managedContext.save()
                self.retriveFavoriteLocation { locations in
                    completion(true)
                }
            }
            catch
            {
                print(error)
                completion(false)
            }
            
        }
        catch
        {
            print(error)
        }
    }
}
