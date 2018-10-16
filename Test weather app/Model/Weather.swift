//
//  WeatherDataModel.swift
//  Test weather app
//
//  Created by Pavel Antoniuk on 10/11/18.
//  Copyright © 2018 Pavel Antoniuk. All rights reserved.
//

import UIKit
import SwiftyJSON

class Weather {
    
    var temperature: Int = 0
    var city: String = ""
    var weather: String = ""
    
    init(_ city: String) {
        self.temperature = 0
        self.city = city
        self.weather = ""
    }
    init(_ json: JSON) {
        guard let tempRow = json["main"]["temp"].double else { return }
        self.temperature = Int(tempRow - 273.15)
        self.city = json["name"].stringValue
        self.weather = json["weather"].compactMap{ $0.1["main"].stringValue }.joined(separator: ", ")
    }
}

