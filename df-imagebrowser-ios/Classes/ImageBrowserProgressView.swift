//
//  ImageBrowserProgressView
//  

import UIKit

class ImageBrowserProgressView: UIView {
    var textColor: UIColor? = UIColor.white {
        willSet {
            self.label.textColor = newValue
        }
    }
    
    var progressColor: UIColor? = UIColor(white: 206/255, alpha: 1) {
        willSet {
            self.setNeedsDisplay()
        }
    }
    
    var progressTintColor: UIColor? = UIColor(red: 15/255, green: 148/255, blue: 252/255, alpha: 1) {
        willSet {
            self.setNeedsDisplay()
        }
    }
    
    var progressBackgroundColor: UIColor? = UIColor.black {
        willSet {
            self.setNeedsDisplay()
        }
    }
    
    private var progress: Float = 0
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.label)
        self.label.textColor = self.textColor
        self.centerXConstraint(subView: self.label)
        self.centerYConstraint(subView: self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(_ progress: Float) {
        self.progress = progress
        self.label.text = String(format: "%.1f", progress*100).appending("%")
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        
        let bezierPath = UIBezierPath(rect: rect)
        self.progressBackgroundColor?.setFill()
        bezierPath.fill()
        bezierPath.close()
        
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        
        let backgroundBezierPath = UIBezierPath()
        backgroundBezierPath.addArc(withCenter: center, radius: rect.width/2-1.5, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        backgroundBezierPath.lineWidth = 3
        self.progressColor?.set()
        backgroundBezierPath.stroke()
        backgroundBezierPath.close()
        
        let foregroundBezierPath = UIBezierPath()
        let startAngle = CGFloat.pi * 3.5
        let endAngle = startAngle + (CGFloat.pi * 2 * CGFloat(self.progress))
        foregroundBezierPath.addArc(withCenter: center, radius: rect.width/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        foregroundBezierPath.lineWidth = 8
        foregroundBezierPath.lineJoinStyle = .miter
        self.progressTintColor?.set()
        foregroundBezierPath.stroke()
        foregroundBezierPath.close()
    }
}
