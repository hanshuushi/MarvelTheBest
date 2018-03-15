//
//  LatteTime.swift
//  Loading
//
//  Created by 范舟弛 on 2017/3/7.
//  Copyright © 2017年 范舟弛. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

protocol LatteTimeStyle {
    var animationDuration: CFTimeInterval {get set}
    
    var pointColor: UIColor {get set}
    
    var pointDiameter: CGFloat {get set}
    
    var pointJumpHeight: CGFloat {get set}
    
    var pointCurvature: CGFloat {get set}
    
    var pointPadding: CGFloat {get set}
    
    var curvatureDurationRate: CGFloat {get set}
}

fileprivate struct DefaultLatteTimeStyle: LatteTimeStyle {
    public var animationDuration: CFTimeInterval = 0.5
    
    public var pointColor: UIColor = UIColor.red
    
    public var pointDiameter: CGFloat = 10.0
    
    public var pointJumpHeight: CGFloat = 30.0
    
    public var pointCurvature: CGFloat = 0.4
    
    public var pointPadding: CGFloat = 0.5
    
    public var curvatureDurationRate: CGFloat = 0.5
}

class LatteTime: UIView, LatteTimeStyle {
    public static var defaultStyle: LatteTimeStyle = DefaultLatteTimeStyle()
    
    fileprivate static let defaultProgress: CGFloat = 0.707106781186548
    
    fileprivate let points:[PointLayer]
    
    public var animationDuration: CFTimeInterval {
        didSet {
            standReady()
        }
    }
    
    public var pointColor: UIColor {
        didSet {
            for point in points {
                point.backgroundColor = pointColor.cgColor
            }
        }
    }
    
    public var pointDiameter: CGFloat{
        didSet {
            setupFrameAtSamePosition()
        }
    }
    
    public var pointJumpHeight: CGFloat{
        didSet {
            setupFrameAtSamePosition()
        }
    }
    
    public var pointCurvature: CGFloat{
        didSet {
            setupFrameAtSamePosition()
        }
    }
    
    public var pointPadding: CGFloat{
        didSet {
            setupFrameAtSamePosition()
        }
    }
    
    public var curvatureDurationRate: CGFloat{
        didSet {
            setupFrameAtSamePosition()
        }
    }
    
    fileprivate var pointTranslationLength: CGFloat
    
    fileprivate var viewWidth: CGFloat
    
    init() {
        animationDuration       = LatteTime.defaultStyle.animationDuration
        pointColor              = LatteTime.defaultStyle.pointColor
        pointDiameter           = LatteTime.defaultStyle.pointDiameter
        pointJumpHeight         = LatteTime.defaultStyle.pointJumpHeight
        pointCurvature          = LatteTime.defaultStyle.pointCurvature
        pointPadding            = LatteTime.defaultStyle.pointPadding
        curvatureDurationRate   = LatteTime.defaultStyle.curvatureDurationRate
        pointTranslationLength  = pointJumpHeight - pointDiameter * (1.0 + pointCurvature)
        viewWidth               = pointDiameter * (1.0 + pointCurvature) * 3.0 + pointPadding * 2.0
        
        let frame = CGRect(x: 0,
                           y: 0,
                           width: viewWidth,
                           height: pointJumpHeight)
        
        var points = [PointLayer]()
        
        for _ in 0..<3 {
            let pointLayer = PointLayer()
            
            pointLayer.backgroundColor = pointColor.cgColor
            
            points.append(pointLayer)
        }
        
        self.points = points
        
        super.init(frame: frame)
        
        for pointLayer in points {
            self.layer.addSublayer(pointLayer)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var isPlaying: Bool = false
    
    func play() {
        isPlaying = true
        
        standReady()
    }
    
    func pause() {
        isPlaying = false
        
        for pointLayer in points {
            pointLayer.timer?.isPaused = true
        }
    }
    
    func setupFrameAtSamePosition() {
        let center = self.center
        
        let size = self.intrinsicContentSize
        
        self.frame = CGRect(x: center.x - size.width / 2.0,
                            y: center.y - size.height / 2.0,
                            width: size.width,
                            height: size.height)
        
        self.standReady()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.viewWidth,
                      height: self.pointJumpHeight)
    }
    
    fileprivate func standReady() {
        for pointLayer in points {
            pointLayer.timer?.isPaused = true
        }
        
        pointTranslationLength  = pointJumpHeight - pointDiameter * (1.0 + pointCurvature)
        viewWidth               = pointDiameter * (1.0 + pointCurvature) * 3.0 + pointPadding * 2.0
        
        for (index, pointLayer) in points.enumerated() {
            pointLayer.latteTime = self
            
            pointLayer.transform = CATransform3DIdentity
            pointLayer.frame = CGRect(x: 0,
                                      y: 0,
                                      width: pointDiameter,
                                      height: pointDiameter)
            
            switch index {
            case 0:
                pointLayer.position = CGPoint(x: pointDiameter * (1.0 + pointCurvature) / 2.0,
                                              y: pointJumpHeight)
                pointLayer.animationProgress = LatteTime.defaultProgress * curvatureDurationRate
                pointLayer.sign = 1
            case 1:
                pointLayer.position = CGPoint(x: viewWidth / 2.0,
                                              y: pointJumpHeight)
                pointLayer.animationProgress = 0.0
                pointLayer.sign = 1
            case 2:
                pointLayer.position = CGPoint(x: viewWidth - pointDiameter * (1.0 + pointCurvature) / 2.0,
                                              y: pointJumpHeight)
                pointLayer.sign = -1
                pointLayer.animationProgress = LatteTime.defaultProgress * curvatureDurationRate
            default:
                break
            }
        }
        
        if isPlaying {
            for pointLayer in points {
                pointLayer.timer?.isPaused = false
            }
        }
    }
    
    deinit {
        for pointLayer in points {
            pointLayer.timer?.isPaused = true
            pointLayer.timer?.invalidate()
            pointLayer.timer = nil
            pointLayer.removeFromSuperlayer()
        }
    }
}

extension LatteTime {
    fileprivate class PointLayer: CALayer {
        
        var timer:CADisplayLink?
        
        var sign:Int = 1
        
        weak var latteTime: LatteTime? = nil
        
        override init() {
            super.init()
            
            timer = CADisplayLink(target: self,
                                  selector: #selector(PointLayer.animationTrack(displayLink:)))
            
            timer!.isPaused = true
            
            timer!.add(to: .main,
                      forMode: .commonModes)
            
            self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        override func layoutSublayers() {
            super.layoutSublayers()
            
            self.cornerRadius = min(self.bounds.width,
                                    self.bounds.height) / 2.0
        }
        
        deinit {
            timer?.invalidate()
        }
        
        @objc func animationTrack(displayLink:CADisplayLink) {
            if displayLink != timer {
                return
            }
            
            guard let `latteTime` = self.latteTime else {
                return
            }
            
            let timeRate = displayLink.duration / latteTime.animationDuration
            
            let targetProgress = self.animationProgress + CGFloat(sign) * CGFloat(timeRate)
            
            if targetProgress > 1.0 {
                sign = -1
                
                let offset = targetProgress - 1.0
                
                self.animationProgress = 1.0 - offset
            } else if targetProgress < 0.0 {
                sign = 1
                
                self.animationProgress = -targetProgress
            } else {
                self.animationProgress = targetProgress
            }
        }
        
        override init(layer: Any) {
            super.init(layer: layer)
            
            self.backgroundColor = UIColor.blue.cgColor
            
            self.cornerRadius = LatteTime.defaultStyle.pointDiameter / 2.0
            
            self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var animationProgress:CGFloat {
            set {
                _animationProgress = max(0.0, min(1.0, newValue))
                
                guard let `latteTime` = self.latteTime else {
                    return
                }
                
                if _animationProgress >= LatteTime.defaultStyle.curvatureDurationRate {
                    var rate = (_animationProgress - latteTime.curvatureDurationRate) / (1.0 - latteTime.curvatureDurationRate)
                    
                    rate = PointLayer.mgEaseOutQuad(t: rate)
                    
                    let length = latteTime.pointTranslationLength * rate
                    
                    let transform = CATransform3DMakeTranslation(0, -length, 0)
                    
                    CATransaction.begin()
                    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                    
                    
                    self.transform = CATransform3DScale(transform, 1.0 - latteTime.pointCurvature, 1.0 + latteTime.pointCurvature, 1.0)
                    
                    CATransaction.commit()
                } else {
                    var rate = _animationProgress / latteTime.curvatureDurationRate
                    
                    rate = PointLayer.mgEaseInQuad(t: rate)
                    
                    let scaleX = 1.0 + latteTime.pointCurvature - latteTime.pointCurvature * 2.0 * rate
                    
                    let scaleY = 1.0 - latteTime.pointCurvature + latteTime.pointCurvature * 2.0 * rate
                    
                    CATransaction.begin()
                    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                    
                    self.transform = CATransform3DMakeScale(scaleX, scaleY, 1.0)
                    
                    CATransaction.commit()
                }
            }
            get {
                return _animationProgress
            }
        }
        
        static fileprivate func mgEaseInQuad(t:CGFloat , b:CGFloat = 0, c:CGFloat = 1.0) -> CGFloat {
            return c*t*t + b;
        }
        
        static fileprivate func mgEaseOutQuad(t:CGFloat , b:CGFloat = 0, c:CGFloat = 1.0) -> CGFloat {
            return -c*t*(t-2) + b;
        }
        
        var _animationProgress:CGFloat = 0
    }
}
