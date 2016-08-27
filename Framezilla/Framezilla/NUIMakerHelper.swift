//
//  NUIMakerHelper.swift
//  Framezilla
//
//  Created by Nikita on 26/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

extension NUIMaker {

    func convertedValue(relationType: NUIRelationType, forView view: UIView) -> CGFloat {
    
        let convertedRect = self.view.superview!.convert(view.frame, from: view.superview)
        
        switch relationType {
            case .Top:        return convertedRect.minY
            case .Bottom:     return convertedRect.maxY
            case .CenterY:    return convertedRect.midY
            case .CenterX:    return convertedRect.midX
            case .Right:      return convertedRect.maxX
            case .Left:       return convertedRect.minX
            default: return 0
        }
    }
}

extension CGRect {
    
    mutating func setValue(_ value: CGFloat, forRelation type: NUIRelationType) {
        
        var frame = self
        switch type {
            case .Width:   frame.size.width = value
            case .Height:  frame.size.height = value
            case .Left:    frame.origin.x = value
            case .Top:     frame.origin.y = value
            case .CenterX: frame.origin.x = value - self.width/2;
            case .CenterY: frame.origin.y = value - self.height/2;
            default: break
        }
        self = frame
    }
}
