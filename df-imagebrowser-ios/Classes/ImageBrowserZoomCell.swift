//
//  ImageBrowserZoomCell
//

import UIKit

class ImageBrowserZoomCell: UICollectionViewCell {
    static let identifier = "ImageBrowserZoomCell"
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let progressView: ImageBrowserProgressView = {
        let view = ImageBrowserProgressView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sizeConstraint(constant: 50)
        return view
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var doubleTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imageDoubleTap(_:)))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()
    
    static var moreCellColor: UIColor?
    static var moreErrorColor: UIColor?
    static var moreProgressTextColor: UIColor?
    static var moreProgressColor: UIColor?
    static var moreProgressTintColor: UIColor?
    static var moreProgressBackgroundColor: UIColor?
    
    static var zoomCellColor: UIColor?
    static var zoomErrorColor: UIColor?
    static var zoomProgressTextColor: UIColor?
    static var zoomProgressColor: UIColor?
    static var zoomProgressTintColor: UIColor?
    static var zoomProgressBackgroundColor: UIColor?
    
    var imageAsset: ImageBrowserAsset? {
        didSet {
            self.imageView.image = nil
            self.progressView.isHidden = true
            self.errorLabel.isHidden = true
            
            guard let imageAsset = self.imageAsset else { return }
            if imageAsset.type == .success {
                if !self.isMore {
                    self.scrollView.isUserInteractionEnabled = true
                }
                self.imageView.image = imageAsset.image
                if imageAsset.thumbnailImage == nil  {
                    self.scrollView.setZoomScale(1, animated: false)
                }
                self.scrollView.setZoomScale(1, animated: false)
            } else if case let .error(error) = imageAsset.type {
                self.scrollView.isUserInteractionEnabled = false
                self.errorLabel.isHidden = false
                self.errorLabel.text = (error as NSError?)?.domain
            } else if case let .download(progress) = imageAsset.type {
                self.scrollView.isUserInteractionEnabled = false
                if let thumbnailImage = imageAsset.thumbnailImage {
                    self.imageView.image = thumbnailImage
                    self.scrollView.setZoomScale(1, animated: false)
                } else {
                    self.progressView.isHidden = false
                    self.progressView.setProgress(progress)
                }
            }
        }
    }
    
    var isMore: Bool = false {
        willSet {
            self.scrollView.removeGestureRecognizer(self.doubleTapGesture)
            if newValue {
                self.scrollView.zoomScale = 1
                self.scrollView.isUserInteractionEnabled = false
                self.imageView.contentMode = .scaleAspectFill
                self.errorLabel.font = UIFont.systemFont(ofSize: 10)
                
                self.contentView.backgroundColor = ImageBrowserZoomCell.moreCellColor
                self.errorLabel.textColor = ImageBrowserZoomCell.moreErrorColor
                self.progressView.textColor = ImageBrowserZoomCell.moreProgressTextColor
                self.progressView.progressColor = ImageBrowserZoomCell.moreProgressColor
                self.progressView.progressTintColor = ImageBrowserZoomCell.moreProgressTintColor
                self.progressView.progressBackgroundColor = ImageBrowserZoomCell.moreProgressBackgroundColor
            } else {
                self.scrollView.addGestureRecognizer(self.doubleTapGesture)
                self.errorLabel.font = UIFont.systemFont(ofSize: 15)
                self.scrollView.isUserInteractionEnabled = true
                self.imageView.contentMode = .scaleAspectFit
                
                self.contentView.backgroundColor = ImageBrowserZoomCell.zoomCellColor
                self.errorLabel.textColor = ImageBrowserZoomCell.zoomErrorColor
                self.progressView.textColor = ImageBrowserZoomCell.zoomProgressTextColor
                self.progressView.progressColor = ImageBrowserZoomCell.zoomProgressColor
                self.progressView.progressTintColor = ImageBrowserZoomCell.zoomProgressTintColor
                self.progressView.progressBackgroundColor = ImageBrowserZoomCell.zoomProgressBackgroundColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.scrollView)
        self.contentView.edgesConstraint(subView: self.scrollView)
        
        self.scrollView.addSubview(self.imageView)
        self.scrollView.edgesConstraint(subView: self.imageView)
        self.scrollView.sizeConstraint(subView: self.imageView)
        
        self.contentView.addSubview(self.progressView)
        self.contentView.centerXConstraint(subView: self.progressView)
        self.contentView.centerYConstraint(subView: self.progressView)
        
        self.contentView.addSubview(self.errorLabel)
        self.contentView.leadingConstraint(subView: self.errorLabel)
        self.contentView.trailingConstraint(subView: self.errorLabel)
        self.contentView.centerYConstraint(subView: self.errorLabel)
        
        
        self.backgroundColor = .clear
        
        self.scrollView.backgroundColor = .clear
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 0.5
        self.scrollView.maximumZoomScale = 5.0
        self.scrollView.clipsToBounds = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFit
        
        self.progressView.isHidden = true
        
        self.errorLabel.font = UIFont.systemFont(ofSize: 15)
        self.errorLabel.numberOfLines = 0
        self.errorLabel.textAlignment = .center
        self.errorLabel.adjustsFontSizeToFitWidth = true
        self.errorLabel.minimumScaleFactor = 0.3
        
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
        self.progressView.isHidden = true
        self.errorLabel.isHidden = true
    }
    
    @objc private func imageDoubleTap(_ sender: UITapGestureRecognizer) {
        if self.scrollView.zoomScale == 1 {
            if self.imageView.image == nil { return }
            self.scrollView.setZoomScale(1, animated: false)
            
            let imageSize = self.imageView.frameForImageInImageViewAspectFit
            let widthRate =  self.bounds.width / imageSize.width
            let heightRate = self.bounds.height / imageSize.height
            if widthRate < heightRate {
                self.scrollView.setZoomScale(heightRate, animated: true)
            } else {
                self.scrollView.setZoomScale(widthRate, animated: true)
            }
            let x = self.scrollView.contentSize.width/2 - self.scrollView.bounds.size.width/2
            let y = self.scrollView.contentSize.height/2 - self.scrollView.bounds.size.height/2
            self.scrollView.contentOffset = CGPoint(x: x, y: y)
        } else {
            self.scrollView.setZoomScale(1, animated: true)
        }
    }
}

// MARK: UIScrollViewDelegate
extension ImageBrowserZoomCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale <= 1 {
            let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
            let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
            scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
        } else {
            let imageSize = self.imageView.frameForImageInImageViewAspectFit
            
            let widthRate =  self.bounds.width / imageSize.width
            let heightRate = self.bounds.height / imageSize.height
            
            if widthRate < heightRate {
                let imageOffset = -imageSize.origin.y
                let scrollOffset = (scrollView.bounds.height - scrollView.contentSize.height) * 0.5
                if imageOffset > scrollOffset {
                    scrollView.contentInset = UIEdgeInsets(top: imageOffset, left: 0, bottom: imageOffset, right: 0)
                } else {
                    scrollView.contentInset = UIEdgeInsets(top: scrollOffset, left: 0, bottom: scrollOffset, right: 0)
                }
            } else {
                let imageOffset = -imageSize.origin.x
                let scrollOffset = (scrollView.bounds.width - scrollView.contentSize.width) * 0.5
                if imageOffset > scrollOffset {
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: imageOffset, bottom: 0, right: imageOffset)
                } else {
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: scrollOffset, bottom: 0, right: scrollOffset)
                }
            }
        }
    }
}
