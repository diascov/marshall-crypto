//
//  String+DateFormatter.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import Foundation

extension String {

    var asIsoDate: Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return dateFormatter.date(from: self) ?? Date()
    }
}
