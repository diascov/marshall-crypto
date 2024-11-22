//
//  Numeric+Delay.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-22.
//

public protocol DelayConstants {
    static var delay: Self { get }
}

public extension DelayConstants where Self: BinaryInteger {
    static var delay: Self { 500_000_000 } // 0.5 sec
}

public extension DelayConstants where Self: FloatingPoint {
    static var delay: Self { 500_000_000 } // 0.5 sec
}

extension UInt64: DelayConstants {}
extension Double: DelayConstants {}
