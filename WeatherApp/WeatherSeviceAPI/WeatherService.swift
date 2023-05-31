//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Veerababu Mulugu on 30/05/23.
//

import CoreLocation
import Foundation

protocol WeatherService {
    ///  function to featchdata with location argument to featch location from coordinates

    func featchWeatherWithLocation
    (
        location: CLLocation,
        completion: @escaping (Result<WeatherResponseData, Error>) -> Void
    )

    /// function to featchdata with cityname argument to featch location from city

    func featchWeatherWithCity
    (
        city: String,
        completion: @escaping (Result<WeatherResponseData, Error>) -> Void
    )
}

protocol WebService {
    func ApiCall<T: Decodable>(
        path: String,
        param: [String: Any],
        completionHandler: @escaping (Result<T, Error>) -> Void
    )
}
