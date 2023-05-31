//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Veerababu Mulugu on 29/05/23.
//

import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let main: WeatherTemp
}

struct WeatherTemp: Decodable {
    let temp: Double
    let humidity: Double
}
