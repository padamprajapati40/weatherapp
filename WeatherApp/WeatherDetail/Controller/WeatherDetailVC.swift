//
//  WeatherDetailVC.swift
//  WeatherApp
//
//  Created by Padam on 23/05/23.
//

import UIKit

class WeatherDetailVC: BaseVC {
    let viewModel = WeatherVM()
    var selectedLocation:Location?
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblMaxTemprature: UILabel!
    @IBOutlet weak var lblMinTemprature: UILabel!
    @IBOutlet weak var lblCurrent: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let loc = self.selectedLocation{
            self.viewModel.retriveWeatherDetails(location:loc) { locations in
                DispatchQueue.main.async {
                    self.dailyCollectionView.reloadData()
                    self.lblCurrent.text = "\(self.viewModel.weatherResponse?.current.temp.doubleToString() ?? "0")°"
                    self.lblDescription.text = self.dateFormater(date: (self.viewModel.weatherResponse?.current.dt)!, dateFormat: "E d MMM")
                    self.lblLocationName.text = self.selectedLocation?.cityName ?? ""
                    self.lblMaxTemprature.text =  "Max: \(String(describing: self.viewModel.weatherResponse?.daily.first?.temp.max.doubleToString() ?? "0.0"))°"
                    self.lblMinTemprature.text =  "Min: \(String(describing: self.viewModel.weatherResponse?.daily.first?.temp.min.doubleToString() ?? "0.0"))°"
                }
            }
        }
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: - Extensions
//collection View
extension WeatherDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.weatherResponse?.daily.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyForcastCell", for: indexPath) as? DailyForcastCell
            else { return UICollectionViewCell()}
            if let dailyWeather = viewModel.weatherResponse?.daily[indexPath.row]{
                cell.configure(daily:dailyWeather , indexPath: indexPath.row);
                cell.dailyDate.text = dateFormater(date: (dailyWeather.dt), dateFormat: "E d MMM")
            }
            
            return cell
            
            
      
    }
    
    private func dateFormater(date: TimeInterval, dateFormat: String) -> String {
        let dateText = Date(timeIntervalSince1970: date )
        let formater = DateFormatter()
        formater.dateFormat = dateFormat
        return formater.string(from: dateText)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100, height: 150)
      
    }
}
