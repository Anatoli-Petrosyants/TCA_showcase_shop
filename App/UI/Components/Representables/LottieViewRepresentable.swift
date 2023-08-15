//
//  LottieViewRepresentable.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

// https://github.com/LukasHromadnik/Lottie-SwiftUI/tree/main/Sources/LottieSwiftUI

import SwiftUI
import Lottie

/// SwiftUI wrapper around `Lottie.AnimationView`
public struct LottieViewRepresentable: UIViewRepresentable {
    
    /// The animation
    let animation: LottieAnimation?
    
    /// Flag if the animation should be played
    @Binding var play: Bool
    
    /// Loop mode of the animation
    var loopMode: LottieLoopMode
    
    public init(animation: LottieAnimation, play: Binding<Bool>) {
        self.animation = animation
        self.loopMode = .loop
        self._play = play
    }
    
    public init(name: String, play: Binding<Bool>) {
        animation = .named(name)
        self.loopMode = .loop
        self._play = play
    }

    public init(filepath: String, play: Binding<Bool>) {
        animation = .filepath(filepath)
        self.loopMode = .loop
        _play = play
    }
    
    public init(name: String, loopMode: LottieLoopMode, play: Binding<Bool>) {
        animation = .named(name)
        _play = play
        self.loopMode = loopMode
    }
    
    // MARK: - UIViewRepresentable
    public func makeUIView(context: Context) -> LottieWrapperAnimationView {
        LottieWrapperAnimationView(animation: animation)
    }

    public func updateUIView(_ uiView: LottieWrapperAnimationView, context: Context) {
        uiView.loopMode = loopMode
        if play {
            uiView.play { completed in
                if play {
                    self.play = !completed
                } else {
                    uiView.stop()
                }
            }
        }
    }
}

// Needed to have proper size with `frame` modifier
public final class LottieWrapperAnimationView: UIView {

    let animationView: LottieAnimationView!

    init(animation: LottieAnimation?) {
        let animationView = LottieAnimationView(animation: animation)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.animationView = animationView

        super.init(frame: .zero)

        addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            animationView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            animationView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            animationView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LottieWrapperAnimationView {

    var loopMode: LottieLoopMode {
        get { animationView.loopMode }
        set { animationView.loopMode = newValue }
    }

    func play(completion: LottieCompletionBlock?) {
        animationView.play(completion: completion)
    }

    func stop() {
        animationView.stop()
    }
}
