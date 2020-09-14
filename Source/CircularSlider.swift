//
//  PercentageView.swift
//  SPMDemo
//
//  Created by IFTS06 on 04/09/2020.
//

import Foundation
import UIKit

// PRCENTAGE VIEW
@available(iOS 9.1, *)
@IBDesignable
public class CircularSlider: UIView {
    // CONSTANTS FOR DRAWING
    private struct Constants {
        static let max : CGFloat = 1.0
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 30
        static var halfOfLineWidth: CGFloat { return lineWidth / 2 }
    }
    // PROGRESS: Indicates the percentage with a number between 0 and 1
    @IBInspectable public var progress: CGFloat = 0.65 {
      didSet {
        if !(0...1).contains(progress) {
            // clamp: if progress is over 1 or less than 0 give it a value between them
            progress = max(0, min(1, progress))
        }
        setNeedsDisplay()
      }
    }
    // INSPECTABLE VARIABLES TO COLOR EACH ITEM FROM STORYBOARD
    @IBInspectable public var firstFillColor: UIColor = UIColor.red { didSet { setNeedsDisplay() } }
    @IBInspectable public var secondFillColor: UIColor = UIColor.yellow { didSet { setNeedsDisplay() } }
    @IBInspectable public var counterColor: UIColor = UIColor.orange { didSet { setNeedsDisplay() } }
    @IBInspectable public var knobColor: UIColor = .gray  { didSet { setNeedsDisplay() } }
    // Label init
    let percentageLabel = UILabel(frame: CGRect(x: 150, y: 150, width: 200, height: 40))
    // position to be set everytime the progress is updated
    public fileprivate(set) var pointerPosition: CGPoint = CGPoint()
    // boolean which chooses if the knob can be dragged or not
    var canDrag = false
    // variable that stores the lenght of the arc based on the last touch
    var oldLength : CGFloat = 300
    
    // TOUCHES BEGAN: if the touch is near thw pointer let it be possible to be dragged
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.hitTest(firstTouch.location(in: self), with: event)
            if hitView === self {
                // distance of touch from pointer
                let xDist = CGFloat(firstTouch.preciseLocation(in: hitView).x - pointerPosition.x)
                let yDist = CGFloat(firstTouch.preciseLocation(in: hitView).y - pointerPosition.y)
                let distance = CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
                canDrag = true
                guard distance < 30 else { return canDrag = false }
            }
        }
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
                    if 480.0 ... 550.0 ~= newArcLength { newArcLength = 480 }
                    else if 550.0 ... 630.0 ~= newArcLength { newArcLength = 0 }
                    if oldLength == 480 && 0 ... 465 ~= newArcLength  { newArcLength = 480 }
                    else if oldLength == 0 && 15 ... 480 ~= newArcLength { newArcLength = 0 }
                    oldLength = newArcLength
                    
                    // PERCENTAGE TO BE ASSIGNED TO THE PROGRES VAR
                    let newPercentage = newArcLength/arcLength
                    progress = CGFloat(newPercentage)
                }
            }
        }
    }
    // LABEL
    public func label() {
        // DRAW THE PERCENTAGE LABEL
        percentageLabel.translatesAutoresizingMaskIntoConstraints = true
        percentageLabel.font = percentageLabel.font.withSize(28)
        percentageLabel.center = CGPoint(x: 115, y: 115)
        percentageLabel.textAlignment = .center
        self.addSubview(percentageLabel)
        let percentage = Int(Double(progress * 100))
        percentageLabel.text = "\(percentage)%"
    }
    // DRAW
    public override func draw(_ rect: CGRect) {
        // call label function
        label()
        
        //DRAW THE OUTLINE
        // 1 Define the center point you’ll rotate the arc around.
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        // 2 Calculate the radius based on the maximum dimension of the view.
        let radius = max(bounds.width, bounds.height)
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
        radius: radius/2 - Constants.arcWidth/2,
        startAngle: startAngle,
        endAngle: outlineEndAngle,
        clockwise: true)
        //outlineColor.setStroke()
        insidePath.lineCapStyle = .round
        insidePath.lineWidth = CGFloat(30.0)
        insidePath.stroke()
        
        // GRADIENT: create a context to clip to the insidePath
        // graphicContext
        let c = UIGraphicsGetCurrentContext()!
        let clipPath: CGPath = insidePath.cgPath
        c.saveGState()
        c.setLineWidth(30.0)
        c.addPath(clipPath)
        c.setLineCap(.round)
        c.replacePathWithStrokedPath()
        c.clip()
        // Draw gradient
        let colors = [firstFillColor.cgColor, secondFillColor.cgColor]
        let offsets = [ CGFloat(0.0), CGFloat(1.0) ]
        let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: offsets)
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 230, y: 230)
        c.drawLinearGradient(grad!, start: start, end: end, options: [])
        c.restoreGState()
        // result
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // DRAW THE POINTER
        let pointerRect = CGRect(x: insidePath.currentPoint.x - Constants.arcWidth / 2, y: insidePath.currentPoint.y - Constants.arcWidth / 2, width: Constants.arcWidth, height: Constants.arcWidth)
        let pointer = UIBezierPath(ovalIn: pointerRect)
        knobColor.setFill()
        pointer.fill()
        insidePath.append(pointer)
        
        // SET THE POSITION
        pointerPosition = CGPoint(x: insidePath.currentPoint.x - Constants.arcWidth / 2, y: insidePath.currentPoint.y - Constants.arcWidth / 2)
    }
}

