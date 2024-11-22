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
    static let arrowUpArrowDown = Icon.arrowUpArrowDown.image
    static let personCropCircle = Icon.personCropCircle.image
    static let xmarkCircle = Icon.xmarkCircle.image
}

public extension Image {
    static let signInWithGoogle = CoreImage.signInWithGoogle.image
}

private enum Icon: String {
    case photoCircleFill = "photo.circle.fill"
    case star = "star"
    case starFill = "star.fill"
    case arrowUp = "arrow.up"
    case arrowDown = "arrow.down"
    case arrowLeftArrowRight = "arrow.left.arrow.right"
    case arrowUpArrowDown = "arrow.up.arrow.down"
    case personCropCircle = "person.crop.circle"
    case xmarkCircle = "xmark.circle"

    var image: Image {
        Image(systemName: rawValue)
    }
}

private enum CoreImage: String {
    case signInWithGoogle = "sign_in_with_google"

    var image: Image {
        Image(rawValue, bundle: .module)
    }
}
