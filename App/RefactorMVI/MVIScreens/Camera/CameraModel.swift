//
//  CameraModel.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 03.04.23.
//

import SwiftUI
import AVFoundation

// MARK: - Intent Actions

protocol CameraModelActionsProtocol: AnyObject {
    typealias Action = CameraModel.Action
    func mutate(action: Action)
}

// MARK: - View State

protocol CameraModelStatePotocol {
    var navigationTitle: String { get }
    var session: AVCaptureSession { get }
}

final class CameraModel: ObservableObject, CameraModelStatePotocol {
    
    @Published
    var navigationTitle = "Camera"
    
    var session = AVCaptureSession()
}

// MARK: - Actions

extension CameraModel {
    enum Action {
        
    }
}

extension CameraModel: CameraModelActionsProtocol {
    
    func mutate(action: Action) {
        
    }
}
