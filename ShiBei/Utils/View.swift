//
//  View.swift
//  ShiBei
//
//  Created by Xie Zhihao on 2022/6/5.
//

import SwiftUI

extension View {
    func onTouchDownUpGesture(callback: @escaping (Bool) -> Void) -> some View {
        modifier(OnTouchDownUpGestureModifier(callback: callback))
    }
}

private struct OnTouchDownUpGestureModifier: ViewModifier {
    @State var tapped = false
    let callback: (Bool) -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !tapped {
                        tapped = true
                        callback(tapped)
                    }
                }
                .onEnded { _ in
                    tapped = false
                    callback(tapped)
                })
    }
}
