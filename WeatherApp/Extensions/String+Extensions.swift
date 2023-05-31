//
//  String+Extensions.swift
//  WeatherApp
//
//  Created by Veerababu Mulugu on 29/05/23.
//

import Foundation

extension String {
    func escaped() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}
