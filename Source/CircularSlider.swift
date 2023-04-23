//
//  PercentageView.swift
//  SPMDemo
//
//  Created by IFTS06 on 04/09/2020.
//

import Foundation
import UIKit

// PRCENTAGE VIEW
open class CircularSlider: UIView {
    // CONSTANTS FOR DRAWING
    private struct Constants {
        static let max : CGFloat = 1.0
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 10
        static var halfOfLineWidth: CGFloat { return lineWidth / 2 }
        static let arcPadding: CGFloat = 15
    }
    
    // PROGRESS: Indicates the percentage with a number between 0 and 1
    @IBInspectable public var progress: CGFloat = 0.5 {
        didSet {
            if !(0...1).contains(progress) {
                // clamp: if progress is over 1 or less than 0 give it a value between them
                progress = max(0, min(1, progress))
            }
            setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect) {
        percentageLabel = UILabel()
        titleLabel = UILabel()
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // INSPECTABLE VARIABLES TO COLOR EACH ITEM FROM STORYBOARD
    @IBInspectable public var progressColors: [UIColor] = [.blue.withAlphaComponent(0.5),
                                                           .white.withAlphaComponent(0.6),
                                                           .blue.withAlphaComponent(0.9)] { didSet { setNeedsDisplay() } }
    
    @IBInspectable public var counterColor: UIColor = UIColor.orange { didSet { setNeedsDisplay() } }
    @IBInspectable public var knobColor: UIColor = .gray  { didSet { setNeedsDisplay() } }
    @IBInspectable public var knobBorderColor: UIColor = .gray  { didSet { setNeedsDisplay() } }
    @IBInspectable public var diskColor: UIColor = .white  { didSet { setNeedsDisplay() } }
    @IBInspectable public var knobBorderWidth: CGFloat = 0  { didSet { setNeedsDisplay() } }
    @IBInspectable public var sliderTitle: String = ""  { didSet { setNeedsDisplay() } }
    @IBInspectable public var titleFont: UIFont = .systemFont(ofSize: 12)  { didSet { setNeedsDisplay() } }
    @IBInspectable public var progressFont: UIFont = .systemFont(ofSize: 12)  { didSet { setNeedsDisplay() } }
    @IBInspectable public var progressColor: UIColor = .black { didSet { setNeedsDisplay() } }
    @IBInspectable public var titleColor: UIColor = .black { didSet { setNeedsDisplay() } }
    
    // Label init
    public let percentageLabel: UILabel
    let titleLabel: UILabel
    // position to be set everytime the progress is updated
    public fileprivate(set) var pointerPosition: CGPoint = CGPoint()
    // boolean which chooses if the knob can be dragged or not
    var canDrag = false
    // variable that stores the lenght of the arc based on the last touch
    var oldLength : CGFloat = 300
    
    public var onProgressChanged: (_ progress: CGFloat) -> Void = { progress in}
    public var onTouchesBegan: () -> Void = { }
    public var onToucEnd: () -> Void = { }
    
    // TOUCHES BEGAN: if the touch is near thw pointer let it be possible to be dragged
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.hitTest(firstTouch.location(in: self), with: event)
            if hitView === self {
                // distance of touch from pointer
                let xDist = CGFloat(firstTouch.preciseLocation(in: hitView).x - pointerPosition.x)
                let yDist = CGFloat(firstTouch.preciseLocation(in: hitView).y - pointerPosition.y)
                let distance = CGFloat(sqrt((xDist * xDist) + (yDist * yDist))) - 20
                canDrag = true
                guard distance < Constants.arcWidth else {
                    return canDrag = false
                }
                
                self.onTouchesBegan()
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.onToucEnd()
    }
    
    // TOUCHES MOVED: If touchesBegan says that the pointer can be dragged let it be dregged by the touch of the user
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.hitTest(firstTouch.location(in: self), with: event)
            if hitView === self {
                if canDrag == true {
                    
                    // CONSTANTS TO BE USED
                    let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
                    let radiusBounds = max(bounds.width, bounds.height)
                    let radius = radiusBounds/2 - Constants.arcWidth/2
                    let touchX = firstTouch.preciseLocation(in: hitView).x
                    let touchY = firstTouch.preciseLocation(in: hitView).y
                    
                    // FIND THE NEAREST POINT TO THE CIRCLE FROM THE TOUCH POSITION
                    let dividendx = pow(touchX, 2) + pow(center.x, 2) - (2 * touchX * center.x)
                    let dividendy = pow(touchY, 2) + pow(center.y, 2) - (2 * touchY * center.y)
                    let dividend = sqrt(abs(dividendx) + abs(dividendy))
                    
                    // POINT(x, y) FOUND
                    let pointX = center.x + ((radius * (touchX - center.x)) / dividend)
                    let pointY = center.y + ((radius * (touchY - center.y)) / dividend)
                    
                    // ARC LENGTH
                    let arcAngle: CGFloat = (2 * .pi) + (.pi / 4) - (3 * .pi / 4)
                    let arcLength =  arcAngle * radius
                    
                    // NEW ARC LENGTH
                    let xForTheta = Double(pointX) - Double(center.x)
                    let yForTheta = Double(pointY) - Double(center.y)
                    var theta : Double = atan2(yForTheta, xForTheta) - (3 * .pi / 4)
                    if theta < 0 {
                        theta += 2 * .pi
                    }
                    var newArcLength =  CGFloat(theta) * radius
                
                    // CHECK CONDITIONS OF THE POINTER'S POSITION
                    if 480.0 ... 550.0 ~= newArcLength {
                        newArcLength = 480
                        
                    }
                    else if 550.0 ... 630.0 ~= newArcLength {
                        newArcLength = 0
                        
                    }
                    if oldLength == 480 && 0 ... 465 ~= newArcLength  {
                        newArcLength = 480
                        
                    }
                    else if oldLength == 0 && 15 ... 480 ~= newArcLength {
                        newArcLength = 0
                    }
                    
                   
                    oldLength = newArcLength
                    
                    // PERCENTAGE TO BE ASSIGNED TO THE PROGRES VAR
                    let newPercentage = newArcLength/arcLength
                    if (CGFloat(newPercentage) - 1) >= 0.15 {
                        oldLength = 300
                        return
                    }
                    
                    progress = CGFloat(newPercentage)
                    
                }
            }
        }
    }
    // LABEL
    public func label() {
        // DRAW THE PERCENTAGE LABEL
//        percentageLabel.translatesAutoresizingMaskIntoConstraints = true
        if percentageLabel.superview == nil {
            self.addSubview(percentageLabel)
            self.percentageLabel.textColor = progressColor
            self.percentageLabel.font = progressFont
            percentageLabel.translatesAutoresizingMaskIntoConstraints = false
            percentageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            percentageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        if titleLabel.superview == nil {
            self.addSubview(titleLabel)
            
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
            self.titleLabel.text = sliderTitle
            self.titleLabel.textColor = titleColor
            self.titleLabel.font = titleFont
        }
        
        let percentage = Int(Double(progress * 100))
        percentageLabel.text = "\(percentage)%"
    }
    // DRAW
    public override func draw(_ rect: CGRect) {
        // call label function
        label()
        
        // notify the delegate
        self.onProgressChanged(progress)
        
        //DRAW THE OUTLINE
        // 1 Define the center point you’ll rotate the arc around.
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        // 2 Calculate the radius based on the maximum dimension of the view.
        let radius = max(bounds.width, bounds.height) - 10
        // 3 Define the start and end angles for the arc.
        let startAngle: CGFloat = 3 * .pi / 4
        let endAngle: CGFloat = .pi / 4
        // 4 Create a path based on the center point, radius and angles you defined
        let path = UIBezierPath(
          arcCenter: center,
          radius: radius/2 - Constants.arcWidth/2,
          startAngle: startAngle,
          endAngle: endAngle,
          clockwise: true)
        // 5 Set the line width and color before finally stroking the path.
        path.lineCapStyle = .round
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        
        //DRAW THE INLINE
        //1 - first calculate the difference between the two angles
        //ensuring it is positive
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
        //then calculate the arc for each single glass
        let arcLengthPerGlass = angleDifference / CGFloat(Constants.max)
        //then multiply out by the actual glasses drunk
        let outlineEndAngle = arcLengthPerGlass * CGFloat(progress) + startAngle
        // try to create an inside arc
        // radius is the same as main path
        let insidePath = UIBezierPath(
        arcCenter: center,
        radius: radius/2 - Constants.arcWidth / 2,
        startAngle: startAngle,
        endAngle: outlineEndAngle,
        clockwise: true)
        
        let insidePath2 = UIBezierPath(
        arcCenter: center,
        radius: radius/2 - Constants.arcWidth/2,
        startAngle: startAngle,
        endAngle: outlineEndAngle,
        clockwise: true)
        
        //outlineColor.setStroke()
        insidePath.lineCapStyle = .round
        insidePath.lineWidth = CGFloat(Constants.arcWidth)
        insidePath.stroke()
        
        diskColor.setFill()
        insidePath2.addLine(to: center)
        insidePath2.fill()
        
        // GRADIENT: create a context to clip to the insidePath
        // graphicContext
        let c = UIGraphicsGetCurrentContext()!
        let clipPath: CGPath = insidePath.cgPath
        c.saveGState()
        c.setLineWidth(Constants.arcWidth)
        c.addPath(clipPath)
        c.setLineCap(.round)
        c.replacePathWithStrokedPath()
        c.clip()
        // Draw gradient
        
        let colors = progressColors.map { $0.cgColor }

        let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: nil)
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: self.frame.maxX, y:  self.frame.maxY)
        c.drawLinearGradient(grad!, start: start, end: end, options: [])
        c.restoreGState()
        // result
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        // DRAW THE POINTER
        let pointerRect = CGRect(x: insidePath.currentPoint.x - 16 / 2, y: insidePath.currentPoint.y - 16 / 2, width: 16, height: 16)
        let pointer = UIBezierPath(ovalIn: pointerRect)
        knobColor.setFill()
        pointer.fill()
        insidePath.append(pointer)
        
        let pointerRectBorder = CGRect(x: insidePath.currentPoint.x - 16 / 2, y: insidePath.currentPoint.y - 16 / 2, width: 16, height: 16)
        let pointerBorder = UIBezierPath(ovalIn: pointerRectBorder)
        
        knobBorderColor.setStroke()
//        pointerBorder.lineWidth = 10

        pointer.lineWidth = knobBorderWidth
        pointer.stroke()
        insidePath.append(pointerBorder)
        
        // SET THE POSITION
        pointerPosition = CGPoint(x: insidePath.currentPoint.x - Constants.arcWidth / 2, y: insidePath.currentPoint.y - Constants.arcWidth / 2)
    }
}

