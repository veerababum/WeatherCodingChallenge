//
//  CityWeatherDataTableViewCell.swift
//  WeatherApp
//
//  Created by Veerababu Mulugu on 30/05/23.
//

import SDWebImage
import UIKit

class CityWeatherDataTableViewCell: UITableViewCell {
    
    @IBOutlet var lblCityName: UILabel!
    @IBOutlet var lblAtmosphere: UILabel!
    @IBOutlet var lblTemprature: UILabel!
    @IBOutlet var imgAtmosphere: UIImageView!
    @IBOutlet var lblDateTime: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CityWeatherDataTableViewCell", bundle: nil)
    }
    
    func updateCityWeatherData(weatherData: WeatherResponseData) {
        imgAtmosphere.image = nil
        if let weather = weatherData.weather {
            if weather.count > 0 {
                let wetherInfo = weather[0]
                if let data = wetherInfo.main {
                    lblAtmosphere.text = data
                }
                if let img = wetherInfo.icon {
                    DispatchQueue.main.async {
                        let imgUrl = URL(string: Constants.imageBaseUrl + img + Constants.imageBaseUrlEndPoint)
                        self.imgAtmosphere.sd_setImage(with: imgUrl)
                    }
                }
            }
        }
        if let temprature = weatherData.main?.temp {
            let temp = (temprature - 273.15) * 1.8 + 32
            lblTemprature.text = String(format: "%.2f", temp) + " °F"
        }
        
        if let date = weatherData.dt {
            let timeinterval = TimeInterval(date)
            let timeStamp = Date(timeIntervalSince1970: timeinterval)
            let dateFormatter = DateFormatter()
            dateFormatter.doesRelativeDateFormatting = true
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            let string = dateFormatter.string(from: timeStamp)
            lblDateTime.text = String(describing: string)
        }
    }
}
