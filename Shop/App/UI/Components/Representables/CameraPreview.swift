//
//  CameraPreview.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 03.04.23.
//

// https://github.com/rorodriguez116/Camera-SwiftUI

import UIKit
import AVFoundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {

    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    public let session: AVCaptureSession
    
    public init(session: AVCaptureSession) {
        self.session = session
    }
    
    public func makeUIView(context: Context) -> VideoPreviewView {
        let viewFinder = VideoPreviewView()
        viewFinder.backgroundColor = .black
        viewFinder.videoPreviewLayer.cornerRadius = 0
        viewFinder.videoPreviewLayer.session = session
        viewFinder.videoPreviewLayer.connection?.videoOrientation = .portrait
        return viewFinder
    }
    
    public func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        
    }
}

struct CameraPreview_Previews: PreviewProvider {
    static var previews: some View {
        CameraPreview(session: AVCaptureSession())
            .frame(height: 300)
    }
}
