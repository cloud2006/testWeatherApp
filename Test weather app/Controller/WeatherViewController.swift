//
//  WeatherViewController.swift
//  Test weather app
//
//  Created by Pavel Antoniuk on 10/11/18.
//  Copyright © 2018 Pavel Antoniuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public let controllerInstantiate = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:)

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var defaults = UserDefaults.standard
    var citiesWeather = [Weather]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var citiesArray: [String]? {
        set {
            defaults.set(newValue, forKey: "savedCities")
            defaults.synchronize()
        }
        get {
            return defaults.stringArray(forKey: "savedCities")
        }
    }

    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "b4ab3a77ceada9a31e75ec33557194c1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (citiesArray == nil) { citiesArray = ["London", "Dubai", "Stockholm"] }
        if citiesWeather.count == 0 { citiesArray?.forEach{
            citiesWeather.append(Weather($0))
            }
        }
        self.getAllCitiesWeather(citiesArray!)
    }
    
    //MARK: - Network
    
    func getWetherData(url: String, parameters: [String: String], completion: @escaping (Weather) -> ()) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let weather = Weather(JSON(value))
                completion(weather)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAllCitiesWeather(_ citiesArray: [String]) {
        DispatchQueue.global(qos: .userInitiated).sync {
            citiesArray.map {
                let params = ["q": $0, "appid": APP_ID]
                getWetherData(url: WEATHER_URL, parameters: params, completion: {
                    guard let cityIndex = self.citiesArray?.firstIndex(of: $0.city) else { return }
                    self.citiesWeather[cityIndex] = $0
                })
            }
        }
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray!.count > 0 ? citiesArray!.count + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameCell") as? CityNameCell else { return UITableViewCell() }
        switch indexPath.row {
        case citiesArray!.count:
            cell.cityNameLabel.text = "Add City Name"
        default:
            cell.cityNameLabel.text = citiesArray![indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case citiesArray!.count:
            guard let vc = controllerInstantiate("AddCityViewController") as? AddCityViewController else { return }
            vc.addCity = { [weak self] in
                self?.citiesArray = self!.citiesArray! + [$0]
                guard let id = self?.APP_ID, let url = self?.WEATHER_URL else { return }
                let params = ["q": $0, "appid": id]
                self?.getWetherData(url: url, parameters: params, completion: {
                    self?.citiesWeather.append($0)
                })
            }
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            guard let vc = controllerInstantiate("CityViewController") as? CityViewController else { return }
            vc.weather = self.citiesWeather[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
