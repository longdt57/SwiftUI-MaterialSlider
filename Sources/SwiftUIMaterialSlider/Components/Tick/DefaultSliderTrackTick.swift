//
//  SliderTrackView.swift
//  app
//
//  Created by Long Do on 2023/02/01.
//

import SwiftUI

public struct DefaultSliderTick: SliderTick {
    
    public var width:  CGFloat = 2.0
    public var height: CGFloat = 2.0
    
    public init(width: CGFloat = 2.0, height: CGFloat = 2.0) {
        self.width = width
        self.height = height
    }
    
    public func makeTick() -> some View {
        Circle()
            .frame(width: self.width, height: self.height)
            .foregroundColor(.red.opacity(0.5))
    }
    
}
