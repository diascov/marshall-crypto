//
//  View+Task.swift
//  Marshall Crypto
//
//  Created by Dmitrii Iascov on 2024-11-17.
//

import SwiftUI

public extension View {

    func taskOnAppear(_ action: @escaping @Sendable () async -> Void) -> some View {
        modifier(TaskOnAppear(action: action))
    }
}

private struct TaskOnAppear: ViewModifier {
    let action: @Sendable () async -> Void

    @State private var didFinishTaskOnAppear = false

    func body(content: Content) -> some View {
        content.task {
            guard !didFinishTaskOnAppear else { return }
            didFinishTaskOnAppear = true
            await action()
        }
    }
}
