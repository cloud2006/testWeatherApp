//
//  CityViewController.swift
//  Test weather app
//
//  Created by Pavel Antoniuk on 10/11/18.
//  Copyright © 2018 Pavel Antoniuk. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    var weather: Weather?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempLabel.text = String(describing: weather!.temperature) + "°"
        cityNameLabel.text = weather?.city
        weatherLabel.text = weather?.weather
    }
}
