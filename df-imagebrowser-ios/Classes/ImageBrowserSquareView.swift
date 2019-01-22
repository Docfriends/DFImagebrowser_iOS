//
//  ImageBrowserSquareView
//  

import UIKit

class ImageBrowserSquareView: UIView {
    private let space: CGFloat = 6
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        UIColor.clear.setFill()
        path.fill()
        path.close()
        
        let rect = CGRect(x: 1, y: 1, width: rect.width - 2, height: rect.height - 2)
        
        let squarePath = UIBezierPath()
        squarePath.move(to: CGPoint(x: (rect.origin.x + 1), y: (rect.origin.y + 1)))
        squarePath.addLine(to: CGPoint(x: (rect.origin.x + 1) + (rect.width - self.space)/2, y: (rect.origin.y + 1)))
        squarePath.addLine(to: CGPoint(x: (rect.origin.x + 1) + (rect.width - self.space)/2, y: (rect.origin.y + 1) + (rect.height - self.space)/2))
        squarePath.addLine(to: CGPoint(x: (rect.origin.x + 1), y: (rect.origin.y + 1) + (rect.height - self.space)/2))
        squarePath.addLine(to: CGPoint(x: (rect.origin.x + 1), y: (rect.origin.y + 1)))
        
        squarePath.move(to: CGPoint(x: rect.width - 1, y: (rect.origin.y + 1)))
        squarePath.addLine(to: CGPoint(x: rect.width - 1, y: (rect.origin.y + 1) + (rect.height - self.space)/2))
        squarePath.addLine(to: CGPoint(x: (rect.width - 1) - ((rect.width - self.space)/2), y: (rect.origin.y + 1) + (rect.height - self.space)/2))
        squarePath.addLine(to: CGPoint(x: (rect.width - 1) - ((rect.width - self.space)/2), y: (rect.origin.y + 1)))
        squarePath.addLine(to: CGPoint(x: rect.width - 1, y: (rect.origin.y + 1)))
        
        squarePath.move(to: CGPoint(x: (rect.origin.x + 1), y: rect.height - 1))
        squarePath.addLine(to: CGPoint(x: (rect.origin.x + 1), y: (rect.height - 1) - ((rect.height - self.space)/2)))
        squarePath.addLine(to: CGPoint(x: (rect.origin.x + 1) + (rect.width - self.space)/2, y: (rect.height - 1) - ((rect.height - self.space)/2)))
        squarePath.addLine(to: CGPoint(x: (rect.origin.x + 1) + (rect.width - self.space)/2, y: rect.height - 1))
        squarePath.addLine(to: CGPoint(x: (rect.origin.x + 1), y: rect.height - 1))
        
        squarePath.move(to: CGPoint(x: rect.width - 1, y: rect.height - 1))
        squarePath.addLine(to: CGPoint(x: (rect.width - 1) - ((rect.width - self.space)/2), y: rect.height - 1))
        squarePath.addLine(to: CGPoint(x: (rect.width - 1) - ((rect.width - self.space)/2), y: (rect.height - 1) - ((rect.height - self.space)/2)))
        squarePath.addLine(to: CGPoint(x: rect.width - 1, y: (rect.height - 1) - ((rect.height - self.space)/2)))
        squarePath.addLine(to: CGPoint(x: rect.width - 1, y: rect.height - 1))
        
        self.tintColor.set()
        squarePath.stroke()
        
        squarePath.close()
        
        
    }
    
    static func imageView(_ tintColor: UIColor) -> UIImage? {
        let view = ImageBrowserSquareView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        view.tintColor = tintColor
        view.setNeedsDisplay()
        view.isOpaque = false
        let image = view.imageWithView?.withRenderingMode(.alwaysOriginal)
        return image
    }
}
