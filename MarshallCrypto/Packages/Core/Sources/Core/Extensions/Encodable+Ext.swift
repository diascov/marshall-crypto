//
//  Encodable+Ext.swift
//  Core
//
//  Created by Dmitrii Iascov on 2024-11-21.
//

import Foundation

public extension Encodable {

    var asDictionary: [String: Any] {
      (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
