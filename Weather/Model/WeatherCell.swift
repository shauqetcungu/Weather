//
//  WeatherCell.swift
//  Weather
//
//  Created by Administrator on 27/02/2019.
//  Copyright © 2019 Amplitudo. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherCell: UITableViewCell {
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherTime: UILabel!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var weatherTemp: UILabel!
    func updateVrijeme(vrijeme : List){
        let url = URL(string:"http://openweathermap.org/img/w/\( vrijeme.weather?.first?.icon ?? "01d" ).png")
        weatherIcon.kf.setImage(with: url)
        weatherTime.text = String(vrijeme.dtTxt.dropFirst(11).dropLast(3))
        weatherDesc.text = vrijeme.weather?.first?.description
        weatherTemp.text = "\(String(Int(vrijeme.main?.temp ?? 0)))°"
    }
}
