//
//  ImageBrowserCollectionView
//  

import UIKit

class ImageBrowserCollectionView: UICollectionView {
    var currentIndex: Int = 0
    
    func setCurrentIndexListCount(_ count: Int) {
        let currentIndex =  count - Int(self.deltaOffsetX/self.frame.size.width) - 1
        if self.currentIndex != currentIndex {
            self.currentIndex = currentIndex
        }
    }
}
