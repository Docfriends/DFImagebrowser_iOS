//
//  ImageBrowserCollectionView
//  

import UIKit

class ImageBrowserCollectionView: UICollectionView {
    var currentIndex: Int = 0
    
    func setCurrentIndexListCount(_ count: Int) {
        let index =  CGFloat(count) - self.deltaOffsetX/self.frame.size.width - 1
        let currentIndex = Int(round(index))
        if self.currentIndex != currentIndex && currentIndex >= 0 && currentIndex < count {
            self.currentIndex = currentIndex
        }
    }
}
