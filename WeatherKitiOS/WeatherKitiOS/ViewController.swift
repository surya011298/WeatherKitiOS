//
//  ViewController.swift
//  WeatherKitiOS
//
//  Created by Surya Koneru on 21/11/23.
//

import WeatherKit
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    
    let service = WeatherService()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getUserLocation()
    }

    func getUserLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
       
       
    }
    
    func getWeatherInfo(location: CLLocation) {
        Task {
            do {
                let result = try await service.weather(for: location)
                print("result",result.currentWeather)
                self.tempLbl.text = "\(result.currentWeather.temperature.value)"
                self.conditionLbl.text = "\(result.currentWeather.condition.description)"
            } catch {
                print(String(describing: error))
            }
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else {
                return
            }
            print("Location", location)
            locationManager.stopUpdatingLocation()
            getWeatherInfo(location: location)
        }
}

