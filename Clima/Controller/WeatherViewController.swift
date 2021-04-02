//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabelView: UIStackView!
    
    var weatherManager = WeatherManager();
    let locationManager = CLLocationManager();
    
    @IBAction func getLocationClick(_ sender: UIButton) {
        locationManager.requestLocation();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        cityLabel.isHidden = true;
        temperatureLabelView.isHidden = true;
        conditionImageView.isHidden = true;
            
        locationManager.delegate = self;
        searchTextField.delegate = self;
        weatherManager.delegate = self;
        
        locationManager.requestWhenInUseAuthorization();
        locationManager.requestLocation();
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == searchTextField) {
            searchTextField.endEditing(true);
        }
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if  (textField.text != "") {
            return true;
        } else {
            textField.placeholder = "Type something...";
            return false;
        }
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true);
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(city);
        }
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ manager: WeatherManager, _ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString;
            self.cityLabel.text = weather.cityName;
            self.conditionImageView.image = UIImage(systemName: weather.conditionName);
            self.cityLabel.isHidden = false;
            self.temperatureLabelView.isHidden = false;
            self.conditionImageView.isHidden = false;
        }
    }
    
    func didFailWithError(_ error: Error) -> Void {
        print(error);
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation();
        if let location = locations.last {
            let lat = location.coordinate.latitude;
            let lon = location.coordinate.longitude;
            weatherManager.fetchWeather(longitude: lon, latitude: lat);
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error);
    }
}
