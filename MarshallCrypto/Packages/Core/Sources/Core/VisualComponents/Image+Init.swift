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
    static let arrowUp = Icon.arrowUp.image
    static let arrowDown = Icon.arrowDown.image
    static let arrowLeftArrowRight = Icon.arrowLeftArrowRight.image
}

private enum Icon: String {
    case photoCircleFill = "photo.circle.fill"
    case star = "star"
    case starFill = "star.fill"
    case arrowUp = "arrow.up"
    case arrowDown = "arrow.down"
    case arrowLeftArrowRight = "arrow.left.arrow.right"

    var image: Image {
        Image(systemName: rawValue)
    }
}
