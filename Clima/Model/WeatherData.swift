//
//  WeatherData.swift
//  Clima
//
//  Created by Yuriy Kalugin on 31.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct Main: Decodable {
    let temp: Double;
}

struct WeatherData : Decodable {
    let name: String;
    let main: Main;
    let weather: [Weather];
}

struct Weather: Decodable {
    let description: String;
    let id: Int;
}
