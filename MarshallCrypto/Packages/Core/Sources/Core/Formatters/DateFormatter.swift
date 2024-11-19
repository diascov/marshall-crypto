//
//  DateFormatter.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-19.
//

import Foundation

public extension DateFormatter {

    static func isoDate(from string: String) -> Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return dateFormatter.date(from: string) ?? Date()
    }

    static func isoString(from date: Date) -> String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy 'at' h:mm a"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current

        return dateFormatter.string(from: date)
    }
}
