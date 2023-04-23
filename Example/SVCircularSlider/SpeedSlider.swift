//
//  SpeedSlider.swift
//  SVCircularSlider_Example
//
//  Created by ali  on 23/04/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import SVCircularSlider

class SpeedSlider: CircularSlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        progressColors = [
            .blue,
            .green,
            .red,
        ]
        
        counterColor = .gray
        diskColor = .blue.withAlphaComponent(0.1)
        titleFont = .systemFont(ofSize: 14)
        progressFont = .systemFont(ofSize: 12)
        titleColor = .black
        progressColor = .black
        knobColor = .white
        backgroundColor = .clear
        knobBorderColor = .blue
        knobBorderWidth = 3
        sliderTitle = "Speed"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
