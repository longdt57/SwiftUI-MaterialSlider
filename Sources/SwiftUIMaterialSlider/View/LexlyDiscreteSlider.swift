//
//  MIT License
//
//  Copyright (c) 2021 Tamerlan Satualdypov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI

public struct LexlyDiscreteSlider<Option: Equatable>: View {
    
    @State private var handleOffset: CGFloat = 0.0
    
    @Binding private var selectedItem: Option
    
    private var track:  AnySliderTrack
    private var tick:   AnySliderTick?
    private var handle: AnySliderHandle
    private var bubble: AnySliderBubble?
    
    private var options: [Option]
    
    private var step: CGFloat = 0.0
    
    private var sliderHeight: CGFloat {
        if let tick = self.tick {
            return max(self.handle.height, self.track.height, tick.height) + (self.bubble?.height ?? 0.0)
        }
        
        return max(self.handle.height, self.track.height) + (self.bubble?.height ?? 0.0)
    }
    
    private var horizontalPadding: CGFloat { handle.width/2 }
    
    /**
     Creates discrete slider with given track, tick and handle.
     
     Use this initializer to fully customize your discrete slider.
     
     - Parameters:
         - options: Options that is used as a data source for the slider.
         - track: Customized slider's track.
         - tick: Customized slider's tick.
         - handle: Customized slider's handle.
         - selectedItem: Binding to the property that will store the selected item.
     */
    public init<Track: SliderTrack, Tick: SliderTick, Handle: SliderHandle>(
        options: [Option],
        track:   Track,
        tick:    Tick,
        handle:  Handle,
        selectedItem: Binding<Option>
    ) {
        self.track  = .init(track: track)
        self.tick   = .init(tick: tick)
        self.handle = .init(handle: handle)
        
        self.options = options
        
        self._selectedItem = selectedItem
        
        if options.count > 1 {
            self.step = 1.0 / CGFloat(options.count - 1)
        }
    }
    
    public init<Track: SliderTrack, Tick: SliderTick, Handle: SliderHandle, Bubble: SliderBubble>(
        options: [Option],
        track:   Track,
        tick:    Tick,
        handle:  Handle,
        bubble: Bubble,
        selectedItem: Binding<Option>
    ) {
        self.track  = .init(track: track)
        self.tick   = .init(tick: tick)
        self.handle = .init(handle: handle)
        self.bubble = .init(bubble: bubble)
        
        self.options = options
        
        self._selectedItem = selectedItem
        
        if options.count > 1 {
            self.step = 1.0 / CGFloat(options.count - 1)
        }
    }
    
    /**
     Creates discrete slider with given track and handle.
     
     Use this initializer if you want only to have a track and handle
     in your discrete slider.
     
     - Parameters:
         - options: Options that is used as a data source for the slider.
         - track: Customized slider's track.
         - handle: Customized slider's handle.
         - selectedItem: Binding to the property that will store the selected item.
     */
    public init<Track: SliderTrack, Handle: SliderHandle>(
        options: [Option],
        track:   Track,
        handle:  Handle,
        selectedItem: Binding<Option>
    ) {
        self.track  = .init(track: track)
        self.handle = .init(handle: handle)
        
        self.tick = nil
        
        self.options = options
        
        self._selectedItem = selectedItem
        
        if options.count > 1 {
            self.step = 1.0 / CGFloat(options.count - 1)
        }
    }
    
    /**
     Creates discrete slider with default configuration.
     
     Use this initializer if you want to use default
     style of the discrete slider.
     
     - Parameters:
         - options: Options that is used as a data source for the slider.
         - selectedItem: Binding to the property that will store the selected item.
     */
    public init(options: [Option], selectedItem: Binding<Option>) {
        self.init(
            options: options,
            track:  DefaultSliderTrack(),
            tick:   DefaultSliderTick(),
            handle: DefaultSliderHandle(),
            selectedItem: selectedItem
        )
    }
    
    public init<Bubble: SliderBubble>(options: [Option], selectedItem: Binding<Option>, bubble: Bubble) {
        self.init(
            options: options,
            track:  DefaultSliderTrack(),
            tick:   DefaultSliderTick(),
            handle: DefaultSliderHandle(),
            bubble: bubble,
            selectedItem: selectedItem
        )
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                if let bubble = self.bubble {
                    bubble.makeBubble("\(selectedItem)")
                        .offset(x: self.handleOffset + (self.handle.width - bubble.width)/2)
                }
                
                ZStack(alignment: .init(horizontal: .leading, vertical: .center)) {
                    let lineWidth = geometry.size.width - self.handle.width
                    
                    self.track.makeTrack()
                        .frame(width: lineWidth + 4)
                        .offset(x: horizontalPadding - 1)
                    
                    self.track.makeFillTrack()
                        .frame(width: self.handleOffset + self.handle.width / 2)
                        .offset(x: horizontalPadding)
                    
                    if let tick = self.tick, self.step != 0.0 {
                        self.create(tick: tick, lineWidth: lineWidth)
                    }
                    
                    self.handle.makeHandle()
                        .offset(x: self.handleOffset)
                        .onAppear { initFirstHandlOffset(lineWidth: lineWidth) }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.dragChanged(on: value.location.x, lineWidth: lineWidth)
                                }
                                .onEnded { value in
                                    self.dragEnded(on: value.location.x, lineWidth: lineWidth)
                                }
                        )
                }
            }
        }
        .frame(height: self.sliderHeight)
    }
    
    private func create(tick: AnySliderTick, lineWidth lineWidth: CGFloat) -> some View {
        return ForEach(0 ..< self.options.count) { element in
            tick.makeTick()
                .offset(x: CGFloat(element) * self.step * lineWidth + horizontalPadding)
        }
    }
    
    private func dragChanged(on location: CGFloat, lineWidth: CGFloat) -> () {
        let percentage = max(0, min(location / lineWidth, 1.0))
        
        if self.step != 0.0 {
            let page = round(percentage / self.step)
            self.selectedItem = self.options[Int(page)]
        }
        
        self.handleOffset = lineWidth * percentage
    }
    
    private func dragEnded(on location: CGFloat, lineWidth: CGFloat) -> () {
        if self.step == 0.0, let item = self.options.first {
            self.selectedItem = item
            
            return withAnimation {
                self.handleOffset = 0.0
            }
        }
        
        let percentage = max(0, min(location / lineWidth, 1.0))
        let page = round(percentage / self.step)
        
        self.selectedItem = self.options[Int(page)]
        
        withAnimation { self.handleOffset = lineWidth * page * self.step }
    }
    
    private func initFirstHandlOffset(lineWidth: CGFloat) {
        let index: Int = self.options.firstIndex(where: { $0 == selectedItem }) ?? 0
        let percentage = CGFloat(index) / CGFloat(self.options.count - 1)
        self.handleOffset = lineWidth * percentage
    }
}
