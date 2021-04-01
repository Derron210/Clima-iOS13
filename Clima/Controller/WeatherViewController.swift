//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        searchTextField.delegate = self;
        weatherManager.delegate = self;
    }
    
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
            cityLabel.text = city;
        }
    }
    
    func didUpdateWeather(_ manager: WeatherManager, _ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString;
            self.cityLabel.text = weather.cityName;
            self.conditionImageView.image = UIImage(systemName: weather.conditionName);
        }
    }
    
    func didFailWithError(_ error: Error) -> Void {
        print(error);
    }
}

