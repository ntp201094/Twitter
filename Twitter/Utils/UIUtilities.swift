//
//  UIUtilities.swift
//  Twitter
//
//  Created by Phuc Nguyen on 5/13/19.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import UIKit

enum AppStoryboards : String {
    case main = "Main"
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

extension UIColor {
    
    static var primary: UIColor {
        return UIColor(red: 255 / 255, green: 102 / 255, blue: 0 / 255, alpha: 1)
    }
    
    static var incomingMessage: UIColor {
        return UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
    }
    
}

extension UIImage {
    
    var scaledToSafeUploadSize: UIImage? {
        let maxImageSideLength: CGFloat = 480
        
        let largerSide: CGFloat = max(size.width, size.height)
        let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
        let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
        
        return image(scaledTo: newImageSize)
    }
    
    func image(scaledTo size: CGSize) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

extension UIView {
    
    func smoothRoundCorners(to radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: radius
            ).cgPath
        
        layer.mask = maskLayer
    }
    
}

extension String {
    func chunks(maxLength: Int = 50) -> [String]? {
        guard self.count > maxLength else { return [self] }
        
        let words = self.components(separatedBy: .whitespacesAndNewlines).filter { $0 != "" }
        guard words.count != 0 else { return nil }
        let trimmedString = words.joined(separator: " ")
        
        var isNeedMoreChunks = true
        var result: [String] = []
        var numberOfChunks = (trimmedString.count / maxLength) + ((trimmedString.count % maxLength)  == 0 ? 0 : 1)
        
        repeat {
            guard let chunks = trimmedString.chunking(words, into: numberOfChunks, maxLength: maxLength) else { return nil }
            
            // if the last chunk's length is longer than maxLength, re-chunking with new numberOfChunks
            if let last = chunks.last, last.count > maxLength {
                isNeedMoreChunks = true
            } else {
                isNeedMoreChunks = false
                result = chunks
            }
            numberOfChunks += 1
        } while isNeedMoreChunks == true
        
        return result
    }
    
    private func chunking(_ words: [String], into numberOfChunks: Int, maxLength: Int) -> [String]? {
        var chunks: [String] = []
        var current = "1/\(numberOfChunks)"
        guard current.count < maxLength else { return nil }
        
        for (index, word) in words.enumerated() {
            guard word.count <= maxLength else { return nil }
            // plus 1 for a blank
            let count = current.count + word.count + 1
            
            // if the numberOfChunks is not enough, appending all word to string for the last chunk.
            if count > maxLength && chunks.count < (numberOfChunks - 1) {
                // current string has enough length
                chunks.append(current)
                current = "\(chunks.count + 1)/\(numberOfChunks) " + String(word)
            } else {
                // append word to current string
                current += " " + String(word)
            }
            
            // add last word as last string
            if index == (words.count - 1) {
                chunks.append(current)
            }
        }
        
        return chunks
    }
}
