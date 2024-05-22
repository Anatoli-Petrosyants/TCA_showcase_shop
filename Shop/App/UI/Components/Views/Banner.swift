//
//  Banner.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 17.05.24.
//

import Foundation
import SwiftUI

/// Defines the possible edges where a banner can be presented.
public enum BannerEdge {
    case top, bottom
}

/// Defines options for automatically dismissing a banner.
public enum BannerAutoDismiss {
    /// Dismisses the banner after the specified time interval.
    case after(TimeInterval)
    /// Keeps the banner indefinitely until dismissed manually.
    case never
}

extension View {
    /// Presents a banner view over the current view.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that indicates whether the banner is presented.
    ///   - edge: The edge at which the banner appears. The default value is `.top`.
    ///   - autoDismiss: An option to automatically dismiss the banner after a specified time interval. The default value is `.never`.
    ///   - dragToDismiss: A Boolean value indicating whether the user can dismiss the banner by dragging it. The default value is `true`.
    ///   - animation: The animation to apply when presenting or dismissing the banner. The default value is `.default`.
    ///   - content: A closure returning the content of the banner.
    /// - Returns: A view modified to present a banner.
    public func banner<C: View>(
        isPresented: Binding<Bool>,
        edge: BannerEdge = .top,
        autoDismiss: BannerAutoDismiss = .never,
        dragToDismiss: Bool = true,
        animation: Animation = .default,
        @ViewBuilder content: @escaping () -> C
    ) -> some View {
        modifier(BannerModifier(
            isPresented: isPresented,
            edge: edge,
            autoDismiss: autoDismiss,
            dragToDismiss: dragToDismiss,
            animation: animation,
            banner: content
        ))
    }
}

private struct BannerModifier<C: View>: ViewModifier {
    @Binding var isPresented: Bool
    var id: AnyHashable = .init(UUID())
    var edge: BannerEdge
    var autoDismiss: BannerAutoDismiss
    var dragToDismiss: Bool
    var animation: Animation
    var banner: () -> C
    
    @GestureState(resetTransaction: Transaction(animation: .easeInOut(duration: 0.3)))
    private var dragOffset = CGSize.zero

    private var dragGesture: some Gesture {
        return DragGesture()
            .updating($dragOffset, body: { (value, state, transaction) in
                guard dragToDismiss else { return }
                
                let play: CGFloat = 80
                
                var movement = value.translation.height
                switch edge {
                case .top: movement = min(play, value.translation.height)
                case .bottom: movement = max(-play, value.translation.height)
                }
                
                state = CGSize(width: value.translation.width, height: movement)
            })
            .onEnded { value in
                guard dragToDismiss else { return }
                
                switch edge {
                case .top where value.translation.height <= -35:
                    isPresented = false
                case .bottom where value.translation.height >= 35:
                    isPresented = false
                default:
                    break
                }
            }
    }

    func body(content: Content) -> some View {
        let transistion: AnyTransition
        let alignment: Alignment

        switch edge {
        case .top:
            transistion = .move(edge: .top)
            alignment = .top
        case .bottom:
            transistion = .move(edge: .bottom)
            alignment = .bottom
        }

        return content
            .overlay(
                Group {
                    if isPresented {
                        banner()
                            .frame(alignment: alignment)
                            .offset(x: 0, y: dragOffset.height)
                            .simultaneousGesture(dragGesture)
                            .transition(transistion.combined(with: .opacity))
                            .task(id: id) {
                                switch autoDismiss {
                                case .after(let delay):
                                    do {
                                        try await Task.sleep(until: .now.advanced(by: .seconds(delay)), clock: .continuous)
                                        isPresented = false
                                    } catch { }

                                case .never:
                                    break
                                }
                            }
                    }
                },
                alignment: alignment
            )
            .animation(animation, value: isPresented)
    }
}
