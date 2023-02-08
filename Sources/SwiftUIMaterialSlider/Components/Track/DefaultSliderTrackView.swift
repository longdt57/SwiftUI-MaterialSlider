//
//  SliderTrackView.swift
//  app
//
//  Created by Long Do on 2023/02/01.
//

import SwiftUI

public struct DefaultSliderTrack: SliderTrack {
    
    public var height: CGFloat
    
    public init(height: CGFloat = 4.0) {
        self.height = height
    }
    
    public func makeTrack() -> some View {
        RoundedRectangle(cornerRadius: 4.0)
            .frame(height: self.height)
            .foregroundColor(.red.opacity(0.2))
    }
    
    public func makeFillTrack() -> some View {
        RoundedRectangle(cornerRadius: 4.0)
            .frame(height: self.height)
            .foregroundColor(.clear)
    }
}

