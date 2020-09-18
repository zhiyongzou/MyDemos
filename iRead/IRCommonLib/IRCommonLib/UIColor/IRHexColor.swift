//
//  IRHexColor.swift
//  IRCommonLib
//
//  Created by zzyong on 2020/9/17.
//  Copyright © 2020 zzyong. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit
  public typealias IRColor = UIColor
#else
  import Cocoa
  public typealias IRColor = NSColor
#endif

public extension IRColor {
    
    private class func hexToUInt32(_ hexString: String) -> UInt32 {
        var result: UInt32 = 0
        guard Scanner(string: hexString).scanHexInt32(&result) else {
            return 0
        }
        return result
    }
    
    private static var IRHexColorCache: NSCache<NSString, IRColor> = {
        let cache = NSCache<NSString, IRColor>()
        cache.countLimit = 100;
        return cache
    }()
    
    class func updateCache(countLimit: Int) {
        IRHexColorCache.countLimit = countLimit
    }
    
    class func hexColor(_ hexString: String) -> IRColor {
        return self.hexColor(hexString: hexString, alpha: 1.0)
    }
    
    /// Creat real color by hex string
    /// - Parameters:
    ///   - hexString: Hex string like "FFFFFF". Support RGB and ARGB hex string
    ///   - alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0.
    /// - Returns: IRColor. (Return clear color when hex format is error)
    class func hexColor(hexString: String, alpha: CGFloat) -> IRColor {
        
        var resultHex = hexString
        
        if hexString.hasPrefix("#") {
            resultHex.removeFirst(1)
        }
        
        var resultAlpha: CGFloat = alpha
        if resultHex.count == 8 {
            resultAlpha = CGFloat(self.hexToUInt32("0x\(resultHex.prefix(2))")) / 255.0
            resultHex.removeFirst(2)
        }
        
        if resultHex.count != 6 {
#if DEBUG
            assert(false, "Hex: [\(hexString)] format is error!")
#endif
            return self.clear
        }
        
        // hex color from cache
        if let cacheColor = self.IRHexColorCache.object(forKey: hexString as NSString) {
#if DEBUG
            print("Cache Color: " ,cacheColor.withAlphaComponent(resultAlpha))
#endif
            return cacheColor.withAlphaComponent(resultAlpha)
        }
        
        // get green hex index
        let greenBegin = resultHex.index(resultHex.startIndex, offsetBy: 2)
        let greenEnd = resultHex.index(resultHex.startIndex, offsetBy: 3)
        
        let red = CGFloat(self.hexToUInt32("0x\(resultHex.prefix(2))")) / 255.0
        let green = CGFloat(self.hexToUInt32("0x\(resultHex[greenBegin...greenEnd])")) / 255.0
        let blue = CGFloat(self.hexToUInt32("0x\(resultHex.suffix(2))")) / 255.0
        
        var resultColor: IRColor
        
        #if os(iOS) || os(watchOS) || os(tvOS)
          resultColor = self.init(red:red, green:green, blue:blue, alpha:resultAlpha)
        #else
          resultColor = self.init(calibratedRed:red, green:green, blue:blue, alpha:resultAlpha)
        #endif
        
        self.IRHexColorCache.setObject(resultColor, forKey: hexString as NSString)
        
#if DEBUG
        print("Color: \(resultColor) Hex string: \(resultHex) alpha: \(resultAlpha)")
#endif
        
        return resultColor
    }
}


