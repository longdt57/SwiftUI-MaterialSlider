import SwiftUI

public protocol SliderBubble {
    associatedtype Bubble: View
    
    /**
     The width of the slider's Bubble.
     */
    var width: CGFloat { get }
    
    /**
     The height of the slider's Bubble.
     */
    var height: CGFloat { get }
    
    /**
     Function that creates a Bubble of the slider.
     
     Implement this method to represent
     the Bubble that will be used in your slider.
     
     - Returns:
        Configured Bubble view.
     */
    func makeBubble(_ text: String) -> Self.Bubble
}

extension SliderBubble {
    
    /**
     Function used to type-erase view
     that represents slider's Bubble.
     
     - Returns:
        Type-erased Bubble view.
     */
    public func makeBubbleErased(_ text: String) -> AnyView {
        return .init(self.makeBubble(text))
    }
    
}
