//
//  Double+Extensions.swift
//  WeatherApp
//
//  Created by Veerababu Mulugu on 29/05/23.
//

import Foundation

extension Double {
    func formatAsDegree() -> String {
        return String(format: "%.0f°", self)
    }
}
