
import SwiftUI

public struct AnySliderBubble: SliderBubble {
    
    public let width: CGFloat
    public let height: CGFloat
    
    private let _makeBubble: (String) -> AnyView
    
    public init<Bubble: SliderBubble>(bubble: Bubble) {
        self.width = bubble.width
        self.height = bubble.height
        
        self._makeBubble = bubble.makeBubbleErased
    }
    
    public func makeBubble(_ text: String) -> some View {
        return self._makeBubble(text)
    }
    
}
