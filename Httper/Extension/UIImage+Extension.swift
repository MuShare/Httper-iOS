//
//  UIImage+Extension.swift
//  athene
//
//  Created by Meng Li on 2018/08/20.
//  Copyright © 2018 XFLAG. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func image(with color: UIColor) -> UIImage {
        let rect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(1.0), height: CGFloat(1.0))
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func gradientImage(colors: [UIColor], locations: [CGFloat], size: CGSize, horizontal: Bool = false) -> UIImage? {
        let endPoint = horizontal ? CGPoint(x: 1.0, y: 0.0) : CGPoint(x: 0.0, y: 1.0)
        return gradientImage(colors: colors, locations: locations, startPoint: .zero, endPoint: endPoint, size: size)
    }
    
    static func gradientImage(colors: [UIColor], locations: [CGFloat], startPoint: CGPoint, endPoint: CGPoint, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsPushContext(context!);
        
        let components = colors.reduce([]) { (currentResult: [CGFloat], currentColor: UIColor) -> [CGFloat] in
            var result = currentResult
            
            let numberOfComponents = currentColor.cgColor.numberOfComponents
            guard let components = currentColor.cgColor.components else {
                return []
            }
            if numberOfComponents == 2 {
                result.append(contentsOf: [components[0], components[0], components[0], components[1]])
            } else {
                result.append(contentsOf: [components[0], components[1], components[2], components[3]])
            }
            
            return result
        }
        
        let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: components, locations: locations, count: colors.count);
        
        let transformedStartPoint = CGPoint(x: startPoint.x * size.width, y: startPoint.y * size.height)
        let transformedEndPoint = CGPoint(x: endPoint.x * size.width, y: endPoint.y * size.height)
        context!.drawLinearGradient(gradient!, start: transformedStartPoint, end: transformedEndPoint, options: []);
        UIGraphicsPopContext();
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return gradientImage
    }
}
