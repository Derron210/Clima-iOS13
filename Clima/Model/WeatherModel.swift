//
//  WeatherModel.swift
//  Clima
//
//  Created by Yuriy Kalugin on 01.04.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int;
    let cityName: String;
    let temperature: Double;

    var temperatureString: String {
        return String(format: "%.1f", temperature);
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain";
        case 300...321:
            return "cloud.drizzle";
        case 500...531:
            return "cloud.rain";
        case 600...622:
            return "cloud.snow";
        case 701...781:
            return "cloud.fog";
        case 801...804:
            return "cloud.bolt";
        default:
            return "cloud";
        }
    }
}
