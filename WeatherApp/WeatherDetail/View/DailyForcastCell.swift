//
//  DailyForcastCell.swift
//  WeatherApp
//
//  Created by Padam on 23/05/23.
//

import UIKit

class DailyForcastCell: UICollectionViewCell {
    @IBOutlet weak var dailyImage: UIImageView!
    @IBOutlet weak var dailyDate: UILabel!
    @IBOutlet weak var dailyMaxTemp: UILabel!
    @IBOutlet weak var dailyMinTemp: UILabel!
    
    func configure(daily: DailyWeather, indexPath: Int) {
        dailyImage.contentMode = .scaleAspectFit
        dailyImage.image = UIImage(named: "\(daily.weather.first!.icon)-1.png")
        dailyMinTemp.text = "\(daily.temp.min.doubleToString())°"
        dailyMaxTemp.text = "\(daily.temp.max.doubleToString())°"
    }
}

