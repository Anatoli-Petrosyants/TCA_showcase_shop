//
//  TapAndLongPressModifier.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.03.23.
//

import SwiftUI

struct TapAndLongPressModifier: ViewModifier {

    @State private var canTap = true
    @State private var pressId = 0

    let tapAction: () -> Void
    let longPressAction: () -> Void

    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    @State var tick: Bool = false
    @State var timerStarted: Bool = false

    func body(content: Content) -> some View {
        let tap = DragGesture(minimumDistance: 0)
            .onChanged { _ in
                if !timerStarted {
                    tapAction()
                }
                timerStarted = true

                tick.toggle()
            }
            .onEnded { _ in
                timerStarted = false
            }

        content
            .gesture(tap)
            .onReceive(timer) { _ in
                if timerStarted {
                    longPressAction()
                }
            }
    }
}
