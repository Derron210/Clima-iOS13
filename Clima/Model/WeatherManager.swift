//
//  WeatherManager.swift
//  Clima
//
//  Created by Yuriy Kalugin on 30.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=3a917f0cc9c3d18e60f018234c0e887b&units=metric";
    
    func fetchWeather(_ cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)";
        performRequest(urlString);
    }
    
    func performRequest(_ urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default);
            let task = session.dataTask(with: url) {(data, response, error) in
                if (error != nil) {
                    print(error!);
                    return;
                }
                if let safeData = data {
                    parseJSON(weatherData: safeData);
                }
            }
            task.resume();
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder();
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData);
            print(decodedData.main.temp);
        } catch {
            print(error);
        }
    }
    
    func getConditionName(weatherId: Int) -> String {
        switch weatherId {
        case 200...231:
            return "cloud.bolt.rain";
        default:
            return "Unknown";
        }
    }
}
