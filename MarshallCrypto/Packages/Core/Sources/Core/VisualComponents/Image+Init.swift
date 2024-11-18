//
//  Image+Init.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-18.
//

import SwiftUI

public extension Image {
    static let photoCircleFill = Icon.photoCircleFill.image
    static let star = Icon.star.image
    static let starFill = Icon.starFill.image
}

private enum Icon: String {
    case photoCircleFill = "photo.circle.fill"
    case star = "star"
    case starFill = "star.fill"

    var image: Image {
        Image(systemName: rawValue)
    }
}
