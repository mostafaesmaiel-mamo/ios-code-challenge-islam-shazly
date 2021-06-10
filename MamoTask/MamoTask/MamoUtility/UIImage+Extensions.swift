//
//  UIImage+Extensions.swift
//  
//

//

// swiftlint:disable all

import UIKit

// MARK: Initializer

public extension UIImage {

    convenience init(color: UIColor?) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color?.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }

}

// MARK: - Colors

public extension UIImage {

    func filled(with color: UIColor?) -> UIImage {
        guard let color = color else { return self }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return self }

        color.setFill()
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage)
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }

}

// MARK: - Transform

public extension UIImage {

    func combined(with image: UIImage) -> UIImage? {
        let finalSize = CGSize(width: max(size.width, image.size.width),
                               height: max(size.height, image.size.height))
        var finalImage: UIImage?

        UIGraphicsBeginImageContextWithOptions(finalSize, false, UIScreen.main.scale)
        draw(at: CGPoint(x: (finalSize.width - size.width) / 2, y: (finalSize.height - size.height) / 2))
        image.draw(at: CGPoint(x: (finalSize.width - image.size.width) / 2,
                               y: (finalSize.height - image.size.height) / 2))
        finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    func resizeImage(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func coloredImage(color: UIColor) -> UIImage {
        
        let backgroundSize = size
        UIGraphicsBeginImageContextWithOptions(backgroundSize, false, UIScreen.main.scale)
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        var backgroundRect=CGRect()
        backgroundRect.size = backgroundSize
        backgroundRect.origin.x = 0
        backgroundRect.origin.y = 0
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        ctx.setFillColor(red: r, green: g, blue: b, alpha: a)
        ctx.fill(backgroundRect)
        
        var imageRect = CGRect()
        imageRect.size = size
        imageRect.origin.x = (backgroundSize.width - size.width) / 2
        imageRect.origin.y = (backgroundSize.height - size.height) / 2
        
        // Unflip the image
        ctx.translateBy(x: 0, y: backgroundSize.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        ctx.setBlendMode(.destinationIn)
        ctx.draw(cgImage!, in: imageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func setAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}

// MARK: - RenderingMode

public extension UIImage {

    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }

    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }

    var base64: String {
        return jpegData(compressionQuality: 1.0)!.base64EncodedString()
    }
    
    func compressImage(rate: CGFloat) -> Data? {
        return jpegData(compressionQuality: rate)
    }
}
