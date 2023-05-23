//
//  WeatherVM.swift
//  WeatherApp
//
//  Created by Padam on 23/05/23.
//

import Foundation
class WeatherVM{
    var weatherResponse:WeatherResponse?
    var networkManager = NetworkManager()
    func retriveWeatherDetails(location:Location,_ completion: @escaping (_ success: Bool)-> Void){
        self.networkManager.getWeather(latitude: location.latitude, longitute: location.longitute, completion: { weatherResponse in
            guard let weatherResponse = weatherResponse else { return }
            self.weatherResponse = weatherResponse;
            completion(true)
            print(weatherResponse);
        })
    }
}
