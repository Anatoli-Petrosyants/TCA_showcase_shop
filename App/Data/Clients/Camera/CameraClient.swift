//
//  CameraClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.07.23.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct CameraClient {
    public let start: () async -> Void
    public let stop: () -> Void
    public let switchCaptureDevice: () async -> Void
    public let takePhoto: () async -> Image
    public let previewStream: () -> AsyncStream<CIImage>
}

extension CameraClient: DependencyKey {
    
    static let liveValue: CameraClient = {
        
        var camera = Camera()
        
        return Self {
            camera = Camera()
            await camera.start()
        } stop : {
            camera.stop()
        } switchCaptureDevice: {
            await camera.switchCaptureDevice()
        } takePhoto: {
            await camera.takePhoto()
        } previewStream : {
            camera.previewStream
        }

    }()
}

extension DependencyValues {
    var cameraClient: CameraClient {
        get { self[CameraClient.self] }
        set { self[CameraClient.self] = newValue }
    }
}
