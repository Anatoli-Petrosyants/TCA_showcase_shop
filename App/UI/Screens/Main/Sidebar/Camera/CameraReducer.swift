//
//  CameraReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.07.23.
//

import UIKit
import Foundation
import SwiftUI
import ComposableArchitecture
import Dependencies

struct CameraReducer: ReducerProtocol {
    
    struct State: Equatable {
        var image: Image?
        var result: Image?
    }
    
    enum Action: Equatable {
        case onViewAppear
        case onFlipTap
        case onTakePhotoTap
        
        case update(Image?)
        case updateResult(Image?)
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.cameraClient) var cameraClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onViewAppear:
                return .run { send in                    
                    await cameraClient.start()
                    
                    let imageStream = cameraClient.previewStream()
                        .map { $0.image }
                    
                    for await image in imageStream {
                        Task { @MainActor in
                            send(.update(image))
                        }
                    }
                }
                
            case .onFlipTap:
                return .run { _ in
                    await cameraClient.switchCaptureDevice()
                }
                
            case .onTakePhotoTap:
                return .run { send in
                    let resultImage = await cameraClient.takePhoto()
                    await send(.updateResult(resultImage))
                }
                
            case let .update(image):
                state.image = image
                return .none
                
            case let .updateResult(image):
                state.result = image
                return .none
            }
        }
    }
}

extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
