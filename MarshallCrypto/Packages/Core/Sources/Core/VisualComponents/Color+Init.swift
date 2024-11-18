//
//  Color+Init.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-18.
//

import SwiftUI

public extension Color {
    static let backgroundPrimary = Palette.backgroundPrimary.color
    static let backgroundSecondary = Palette.backgroundSecondary.color
    static let gold = Palette.gold.color
}

private enum Palette: String {
    case backgroundPrimary = "BackgroundPrimary"
    case backgroundSecondary = "BackgroundSecondary"
    case gold = "Gold"

    var color: Color {
        Color(rawValue, bundle: .module)
    }
}