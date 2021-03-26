//
//  LCAutoScrollLabel.swift
//  LCUI
//
//  Created by 李灿 on 2021/3/25.
//

import UIKit

class LCAutoScrollLabel: UILabel {
        
    private var textLayer : CATextLayer = CATextLayer()
    
    private var shouldScroll : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var text: String? {
        didSet {
            shouldScroll = shouldAutoScroll()
            setTextLayerScroll()
        }
    }
    
    override var font: UIFont! {
        didSet {
            shouldScroll = shouldAutoScroll()
            setTextLayerScroll()
        }
    }
    
    override var frame: CGRect {
        didSet {
            shouldScroll = shouldAutoScroll()
            setTextLayerScroll()
        }
    }
    
    override var textColor: UIColor! {
        didSet {
            textLayer.foregroundColor = textColor.cgColor
        }
    }
    
    func setTextLayerScroll() {
        if shouldScroll
        {
            setTextLayer()
            textLayer.add(getLayerAnimation(), forKey: nil)
            layer.addSublayer(textLayer)
        }
        else
        {
            textLayer.removeAllAnimations()
            textLayer.removeFromSuperlayer()
        }
    }
    
    func shouldAutoScroll() -> Bool {
        var shouldScroll = false
        let textString : NSString = NSString(string: self.text ?? "")
        let size = textString.size(withAttributes: [NSAttributedString.Key.font : self.font!])
        let stringWidth = size.width
        let labelWidth = frame.size.width
        if labelWidth < stringWidth {
            shouldScroll = true
        }
        return shouldScroll
    }
    
    func setTextLayer() {
        let textString : NSString = self.text as NSString? ?? ""
        let size = textString.size(withAttributes: [NSAttributedString.Key.font : self.font!])
        let stringWidth = size.width
        let stringHeight = size.height
        textLayer.frame = CGRect(x: 0, y: (frame.height - stringHeight)/2, width: stringWidth, height: stringHeight)
        textLayer.string = text
        textLayer.alignmentMode = .center
        textLayer.font = font
        textLayer.fontSize = font.pointSize
        textLayer.foregroundColor = self.textColor.cgColor
    }
    
    func getLayerAnimation() -> CABasicAnimation {
        let ani = CABasicAnimation(keyPath: "position.x")
        ani.toValue = -textLayer.frame.width
        ani.fromValue = textLayer.frame.width
        ani.duration = 4
        ani.fillMode = .backwards
        ani.repeatCount = 1000000000.0
        ani.isRemovedOnCompletion = false
        return ani
    }
    
    override func drawText(in rect: CGRect) {
        if !shouldScroll
        {
            super.drawText(in: rect)
        }
    }
}
