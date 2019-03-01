//
//  WeatherService.swift
//  Weather
//
//  Created by Administrator on 25/02/2019.
//  Copyright © 2019 Amplitudo. All rights reserved.
//

import Foundation
import Moya


enum Vrijeme {
    case vrijeme
}

var latitude: Double = 0
var longtitude: Double = 0

extension Vrijeme: TargetType {
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var baseURL: URL { return URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longtitude)&appid=dcde1b8dfd63fc5d53dd245e3e5b5ca1&units=metric")! }
    
    var path: String {
        switch self {
        case .vrijeme:
            return ""
            
        }
    }
    var method: Moya.Method {
        switch self {
        case .vrijeme:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .vrijeme:
            return .requestPlain
        }
    }
    var sampleData: Data {
        return Data()
        
    }
}
struct Welcome: Codable {
    let cod: String?
    let message: Double?
    let cnt: Int?
    let list: [List]?
    let city: City?
}

struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population: Int?
}

struct Coord: Codable {
    let lat, lon: Double?
}

struct List: Codable {
    let dt: Int?
    let main: Main?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let sys: Sys?
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, sys
        case dtTxt = "dt_txt"
    }
    
    let dateFormatter = DateFormatter()
    
    func getDate() -> Date{
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: dtTxt)
        return date!
        
    }
}

struct Clouds: Codable {
    let all: Int?
}

struct Main: Codable {
    let temp, tempMin, tempMax, pressure: Double?
    let seaLevel, grndLevel: Double?
    let humidity: Int?
    let tempKf: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct Sys: Codable {
    let pod: String?
}

struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

struct Wind: Codable {
    let speed, deg: Double?
}
