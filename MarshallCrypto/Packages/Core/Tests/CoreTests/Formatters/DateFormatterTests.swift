//
//  DateFormatterTests.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-24.
//

import Testing
import Foundation
@testable import Core

struct DateFormatterTests {

    @Test("When given an ISO8601 string, it returns a Date")
    func isoDate() {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        #expect(DateFormatter.isoDate(from: "2024-11-13T16:15:35.520Z") == formatter.date(from: "2024-11-13T16:15:35.520Z"))
        #expect(DateFormatter.isoDate(from: "2024-11-24T14:23:45.123Z") == formatter.date(from: "2024-11-24T14:23:45.123Z"))
    }

    @Test("When given a Date, it should return formatted string")
    func isoString() {
        if Locale.current.language.languageCode == "en" {
            #expect(DateFormatter.isoString(from: Date(timeIntervalSince1970: 1732451256)) == "Sunday, November 24, 2024 at 1:27 PM")
            #expect(DateFormatter.isoString(from: Date(timeIntervalSince1970: 1732480279)) == "Sunday, November 24, 2024 at 9:31 PM")
            #expect(DateFormatter.isoString(from: Date(timeIntervalSince1970: 0)) == "Thursday, January 1, 1970 at 1:00 AM")
        }
        if Locale.current.language.languageCode == "sv" {
            #expect(DateFormatter.isoString(from: Date(timeIntervalSince1970: 1732451256)) == "söndag, november 24, 2024 at 1:27 em")
            #expect(DateFormatter.isoString(from: Date(timeIntervalSince1970: 1732480279)) == "söndag, november 24, 2024 at 9:31 em")
            #expect(DateFormatter.isoString(from: Date(timeIntervalSince1970: 0)) == "torsdag, januari 1, 1970 at 1:00 fm")
        }
    }
}
