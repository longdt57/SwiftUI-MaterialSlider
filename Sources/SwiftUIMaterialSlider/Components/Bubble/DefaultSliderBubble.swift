import SwiftUI

public struct DefaultSliderBubble: SliderBubble {
    
    public var width:  CGFloat
    public var height: CGFloat
    
    public init(width: CGFloat = 28.0, height: CGFloat = 34.0) {
        self.width = width
        self.height = height
    }
    
    public func makeBubble(_ text: String) -> some View {
        ZStack(alignment: .center) {
            Image("ImageSliderBubble").resizable().scaledToFit()
            Text(text).foregroundColor(.white).font(.caption).fontWeight(.medium)
        }
        .frame(width: self.width, height: self.height)
    }
    
}
