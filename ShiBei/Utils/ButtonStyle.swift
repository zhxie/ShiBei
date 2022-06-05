//
//  ButtonStyle.swift
//  ShiBei
//
//  Created by Xie Zhihao on 2022/6/5.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.linear(duration: 0.2), value: configuration.isPressed)
    }
}
