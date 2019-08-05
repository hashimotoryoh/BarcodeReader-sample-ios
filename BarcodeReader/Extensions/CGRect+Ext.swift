//
//  CGRect+Ext.swift
//  BarcodeReader
//
//  Created by 橋本 龍 on 2019/08/05.
//  Copyright © 2019 Ryoh Hashimoto. All rights reserved.
//

import CoreGraphics

extension CGRect {

    var topLeft: CGPoint {
        return CGPoint(x: minX, y: minY)
    }

    var topRight: CGPoint {
        return CGPoint(x: maxX, y: minY)
    }

    var bottomLeft: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }

    var bottomRight: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }

}
