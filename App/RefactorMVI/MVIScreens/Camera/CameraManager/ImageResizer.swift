//
//  ImageResizer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 03.04.23.
//

import Foundation
import UIKit

public enum ImageResizingError: Error {
    case cannotRetrieveFromURL
    case cannotRetrieveFromData
}

public struct ImageResizer {
    public var targetWidth: CGFloat
    
    public init(targetWidth: CGFloat) {
        self.targetWidth = targetWidth
    }
    
    public func resize(at url: URL) -> UIImage? {
        guard let image = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        return self.resize(image: image)
    }
    
    public func resize(image: UIImage) -> UIImage {
        let originalSize = image.size
        let targetSize = CGSize(width: targetWidth, height: targetWidth*originalSize.height/originalSize.width)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    public func resize(data: Data) -> UIImage? {
        guard let image = UIImage(data: data) else {return nil}
        return resize(image: image )
    }
}
