//
//  SidebarFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 21.07.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SidebarFeature {
    
    enum SidebarItemType {
        case logout, share, contact, rate, messages, map, camera, countries, healthKit
    }
    
    @ObservableState
    struct State: Equatable, Hashable {
        var isVisible = false
        var isSharePresented = false
        @Presents var videoPlayer: VideoPlayerFeature.State?
    }
    
    enum Action: BindableAction, Equatable {
        enum ViewAction: Equatable {
            case onDismiss
            case onLogoutTap
            case onContactTap
            case onRateTap
            case onShareTap
            case onAppSettings
            case onMessagesTap
            case onDarkModeTap
            case onMapTap
            case onCountriesTap
            case onCameraTap
            case onHealthKitTap
            case onVideoPlayerTap
        }
        
        enum InternalAction: Equatable {
            case toggleVisibility
        }

        enum Delegate: Equatable {
            case didSidebarTapped(SidebarItemType)
        }

        case videoPlayer(PresentationAction<VideoPlayerFeature.Action>)
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(Delegate)
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        SidebarLogic()
        
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .onDismiss:
                    return .send(.internal(.toggleVisibility))
                    
                case .onLogoutTap:
                    return .concatenate(
                        .send(.internal(.toggleVisibility)),
                        .send(.delegate(.didSidebarTapped(.logout)))
                    )
                    
                case .onContactTap:
                    return .send(.internal(.toggleVisibility))
                    
                case .onRateTap:
                    return .send(.internal(.toggleVisibility))
                    
                case .onShareTap:
                    state.isSharePresented = true
                    return .none
                    
                case .onAppSettings:
                    return .none
                
                case .onMessagesTap:
                    return .concatenate(
                        .send(.internal(.toggleVisibility)),
                        .send(.delegate(.didSidebarTapped(.messages)))
                    )
                
                case .onDarkModeTap:
                    return .none
                    
                case .onMapTap:
                    return .concatenate(
                        .send(.internal(.toggleVisibility)),
                        .send(.delegate(.didSidebarTapped(.map)))
                    )
                    
                case .onCountriesTap:
                    return .concatenate(
                        .send(.internal(.toggleVisibility)),
                        .send(.delegate(.didSidebarTapped(.countries)))
                    )

                case .onCameraTap:
                    return .concatenate(
                        .send(.internal(.toggleVisibility)),
                        .send(.delegate(.didSidebarTapped(.camera)))
                    )
                    
                case .onHealthKitTap:
                    return .concatenate(
                        .send(.internal(.toggleVisibility)),
                        .send(.delegate(.didSidebarTapped(.healthKit)))
                    )
                    
                case .onVideoPlayerTap:
                    state.videoPlayer = VideoPlayerFeature.State(url: Constant.videoURL)
                    return .send(.internal(.toggleVisibility))
                }
                
            case .internal(.toggleVisibility):
                state.isVisible.toggle()
                return .none

            case .binding, .delegate, .videoPlayer:
                return .none
            }
        }
        .ifLet(\.$videoPlayer, action: /Action.videoPlayer) { VideoPlayerFeature() }
    }
}

