//
//  Float+Format.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

public extension Float {

    var tenDigitsPrecision: String {
        let formattedValue = formatted(.number.precision(.fractionLength(10)))

        if let range = formattedValue.range(of: "\\.?0+$", options: .regularExpression) {
            return formattedValue.replacingCharacters(in: range, with: "")
        }

        return formattedValue
    }
}
