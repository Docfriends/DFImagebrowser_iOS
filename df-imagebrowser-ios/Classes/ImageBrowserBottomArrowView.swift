//
//  ImageBrowserBottomArrowView
//  

import UIKit

class ImageBrowserBottomArrowView: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        UIColor.clear.setFill()
        path.fill()
        path.close()
        
        let trianglePath = UIBezierPath()
        let y = rect.height - sqrt(pow(rect.width, 2) - pow(rect.width/2, 2))
        trianglePath.move(to: CGPoint(x: 0, y: y/2))
        trianglePath.addLine(to: CGPoint(x: rect.width, y: y/2))
        trianglePath.addLine(to: CGPoint(x: rect.width/2, y: rect.height - y/2))
        trianglePath.addLine(to: CGPoint(x: 0, y: y/2))
        
        self.tintColor.set()
        trianglePath.stroke()
        trianglePath.fill()
        
        trianglePath.close()
        
        
    }
    
    static func imageView(_ tintColor: UIColor) -> UIImage? {
        let view = ImageBrowserBottomArrowView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        view.tintColor = tintColor
        view.setNeedsDisplay()
        view.isOpaque = false
        let image = view.imageWithView?.withRenderingMode(.alwaysOriginal)
        return image
    }
}
