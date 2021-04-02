//
//  WeatherManager.swift
//  Clima
//
//  Created by Yuriy Kalugin on 30.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) -> Void;
    func didFailWithError(_ error: Error) -> Void;
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=3a917f0cc9c3d18e60f018234c0e887b&units=metric";
    
    func fetchWeather(_ cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)";
        performRequest(urlString);
    }
    
    func fetchWeather(longitude: Double, latitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)";
        performRequest(urlString);
    }
    
    var delegate: WeatherManagerDelegate?;
    
    private func performRequest(_ urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default);
            let task = session.dataTask(with: url) {(data, response, error) in
                if (error != nil) {
                    delegate?.didFailWithError(error!);
                    return;
                }
                if let safeData = data {
                    if let weather = parseJSON(weatherData: safeData) {
                        if (delegate != nil) {
                            delegate!.didUpdateWeather(self, weather);
                        }
                    }
                }
            }
            task.resume();
        }
    }
    
    private func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder();
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData);
            let id = decodedData.weather[0].id;
            let temp = decodedData.main.temp;
            let name = decodedData.name;
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp);
            return weather;
            
        } catch {
            delegate?.didFailWithError(error);
            return nil;
        }
    }
}
