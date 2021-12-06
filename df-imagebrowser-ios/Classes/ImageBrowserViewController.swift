//
//  ImageBrowserViewController
//

import UIKit

public protocol ImageBrowserDelegate: AnyObject {
    func imageBrowserImageCache(_ viewController: ImageBrowserViewController, url: URL?) -> UIImage?
    func imageBrowserImageDownloadCache(_ viewController: ImageBrowserViewController, url: URL?, image: UIImage)
    func imageBrowserDismiss(_ viewController: ImageBrowserViewController)
    func imageBrowserShareError(_ viewController: ImageBrowserViewController, error: Error?, asset: ImageBrowserAsset)
    func imageBrowserError(_ viewController: ImageBrowserViewController, error: Error?, asset: ImageBrowserAsset)
    func imageBrowserItemWillScroll(_ viewController: ImageBrowserViewController)
    func imageBrowserItemDidScroll(_ viewController: ImageBrowserViewController)
    func imageBrowserItemTitle(_ viewController: ImageBrowserViewController, title: String) -> String?
}

public extension ImageBrowserDelegate {
    func imageBrowserImageCache(_ viewController: ImageBrowserViewController, url: URL?) -> UIImage? { return nil }
    func imageBrowserImageDownloadCache(_ viewController: ImageBrowserViewController, url: URL?, image: UIImage) { }
    func imageBrowserDismiss(_ viewController: ImageBrowserViewController) {
        if let viewController = viewController.navigationController?.viewControllers.first as? ImageBrowserViewController {
            viewController.dismiss(animated: true, completion: nil)
        } else {
            viewController.navigationController?.popViewController(animated: true)
        }
    }
    func imageBrowserShareError(_ viewController: ImageBrowserViewController, error: Error?, asset: ImageBrowserAsset) { }
    func imageBrowserError(_ viewController: ImageBrowserViewController, error: Error?, asset: ImageBrowserAsset) { }
    func imageBrowserItemWillScroll(_ viewController: ImageBrowserViewController) { }
    func imageBrowserItemDidScroll(_ viewController: ImageBrowserViewController) { }
    func imageBrowserItemTitle(_ viewController: ImageBrowserViewController, title: String) -> String? {
        return title
    }
}

open class ImageBrowserViewController: UIViewController {
    public weak var delegate: ImageBrowserDelegate?
    
    public var barTintColor = UIColor.white {
        willSet {
            self.navigationController?.navigationBar.barTintColor = newValue
            self.navigationController?.navigationBar.backgroundColor = newValue
        }
    }
    
    public var tintColor = UIColor(red: 53/255, green: 123/255, blue: 246/255, alpha: 1) {
        willSet {
            let squareButtonItem = UIBarButtonItem(image: ImageBrowserSquareView.imageView(newValue), style: .plain, target: self, action: #selector(self.moreTap(_:)))
            self.navigationItem.setRightBarButton(squareButtonItem, animated: true)
            self.navigationItem.leftBarButtonItem?.tintColor = newValue
            self.navigationItem.rightBarButtonItem?.tintColor = newValue
            self.navigationItem.backBarButtonItem?.tintColor = newValue
            self.navigationController?.navigationBar.tintColor = newValue
            self.titleButton.tintColor = newValue
            self.titleButton.setImage(ImageBrowserBottomArrowView.imageView(newValue), for: .normal)
        }
    }
    
    // more
    
    public var moreCellColor = UIColor(white: 210/255, alpha: 1) {
        willSet {
            ImageBrowserZoomCell.moreCellColor = newValue
        }
    }
    
    public var moreErrorColor = UIColor.black {
        willSet {
            ImageBrowserZoomCell.moreErrorColor = newValue
        }
    }
    
    public var moreProgressTextColor = UIColor.black {
        willSet {
            ImageBrowserZoomCell.moreProgressTextColor = newValue
        }
    }
    
    public var moreProgressColor = UIColor.black {
        willSet {
            ImageBrowserZoomCell.moreProgressColor = newValue
        }
    }
    
    public var moreProgressTintColor = UIColor(red: 15/255, green: 148/255, blue: 252/255, alpha: 1) {
        willSet {
            ImageBrowserZoomCell.moreProgressTintColor = newValue
        }
    }
    
    public var moreProgressBackgroundColor = UIColor(white: 210/255, alpha: 1) {
        willSet {
            ImageBrowserZoomCell.moreProgressBackgroundColor = newValue
        }
    }
    
    // zoom
    
    public var zoomCellColor = UIColor.black {
        willSet {
            ImageBrowserZoomCell.zoomCellColor = newValue
        }
    }
    
    public var zoomErrorColor = UIColor.white {
        willSet {
            ImageBrowserZoomCell.zoomErrorColor = newValue
        }
    }
    
    public var zoomProgressTextColor = UIColor.white {
        willSet {
            ImageBrowserZoomCell.zoomProgressTextColor = newValue
        }
    }
    
    public var zoomProgressColor = UIColor(white: 206/255, alpha: 1) {
        willSet {
            ImageBrowserZoomCell.zoomProgressColor = newValue
        }
    }
    
    public var zoomProgressTintColor = UIColor(red: 15/255, green: 148/255, blue: 252/255, alpha: 1) {
        willSet {
            ImageBrowserZoomCell.zoomProgressTintColor = newValue
        }
    }
    
    public var zoomProgressBackgroundColor = UIColor.black {
        willSet {
            ImageBrowserZoomCell.zoomProgressBackgroundColor = newValue
        }
    }
    
    
    public var isMoreButtonHidden: Bool = false {
        willSet {
            if newValue {
                self.navigationItem.rightBarButtonItem = nil
                self.titleButton.sizeToFit()
            } else {
                let squareButtonItem = UIBarButtonItem(image: ImageBrowserSquareView.imageView(self.tintColor), style: .plain, target: self, action: #selector(self.moreTap(_:)))
                self.navigationItem.rightBarButtonItem = squareButtonItem
            }
        }
    }
    
    public var zoomBackgroundColor: UIColor = .black {
        willSet {
            self.view.backgroundColor = newValue
        }
    }
    
    public var moreBackgroundColor: UIColor = .black
    
    public var visibleIndex: Int? {
        if self.isMore { return nil }
        return self.imageBrowserCollectionView.currentIndex
    }
    
    public var collectionView: UICollectionView {
        return self.imageBrowserCollectionView
    }
    
    public var visibleCell: UICollectionViewCell? {
        guard let visibleIndex = self.visibleIndex else { return nil }
        return self.imageBrowserCollectionView.cellForItem(at: IndexPath(item: visibleIndex, section: 0))
    }
    
    public var visibleScrollView: UIScrollView? {
        guard let visibleCell = self.visibleCell as? ImageBrowserZoomCell else { return nil }
        return visibleCell.scrollView
    }
    
    public var visibleImageView: UIImageView? {
        guard let visibleCell = self.visibleCell as? ImageBrowserZoomCell else { return nil }
        return visibleCell.imageView
    }
    
    public var visibleAsset: ImageBrowserAsset? {
        guard let visibleIndex = self.visibleIndex else { return nil }
        return self.imageAssets[visibleIndex]
    }
    
    private var imageAssets = [ImageBrowserAsset]()
    
    private lazy var imageBrowserCollectionView: ImageBrowserCollectionView = {
        let topConstant: CGFloat = (self.navigationController?.navigationBar.frame.height ?? 0) + (view.window?.windowScene?.statusBarManager?.statusBarFrame.height)!
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: topConstant, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - topConstant)
        let collectionView = ImageBrowserCollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var isInteractivePopGestureRecognizerEnabled: Bool?
    
    private let titleButton: UIButton = {
        let button = UIButton(type: .system)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets.right -= 10
        button.contentEdgeInsets.right += 10
        return button
    }()
    
    public var isMore: Bool {
        return self._isMore
    }
    private var _isMore = false
    private var index = 0
    
    public init(_ imageAssets: [ImageBrowserAsset], index: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        
        self.imageAssets = imageAssets
        self.index = index
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.imageBrowserCollectionView)
        self.view.edgesConstraint(subView: self.imageBrowserCollectionView)
        
        self.titleButton.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.navigationController?.navigationBar.frame.height ?? 44)
        self.titleButton.setImage(ImageBrowserBottomArrowView.imageView(self.tintColor), for: .normal)
        self.titleButton.tintColor = self.tintColor
        
        
        self.view.backgroundColor = self.zoomBackgroundColor
        
        self.navigationController?.navigationBar.barTintColor = self.barTintColor
        self.navigationController?.navigationBar.backgroundColor = self.barTintColor
        
        self.navigationItem.backBarButtonItem?.tintColor = self.tintColor
        self.navigationItem.leftBarButtonItem?.tintColor = self.tintColor
        self.navigationItem.rightBarButtonItem?.tintColor = self.tintColor
        self.navigationController?.navigationBar.tintColor = self.tintColor
        
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.tintColor = self.tintColor
            
            if !self.isMoreButtonHidden {
                let squareButtonItem = UIBarButtonItem(image: ImageBrowserSquareView.imageView(self.tintColor), style: .plain, target: self, action: #selector(self.moreTap(_:)))
                self.navigationItem.rightBarButtonItem = squareButtonItem
            } else {
                self.titleButton.sizeToFit()
            }
        }
        
        ImageBrowserZoomCell.zoomCellColor = self.zoomCellColor
        ImageBrowserZoomCell.zoomErrorColor = self.zoomErrorColor
        ImageBrowserZoomCell.zoomProgressTextColor = self.zoomProgressTextColor
        ImageBrowserZoomCell.zoomProgressColor = self.zoomProgressColor
        ImageBrowserZoomCell.zoomProgressTintColor = self.zoomProgressTintColor
        ImageBrowserZoomCell.zoomProgressBackgroundColor = self.zoomProgressBackgroundColor
        
        ImageBrowserZoomCell.moreCellColor = self.moreCellColor
        ImageBrowserZoomCell.moreErrorColor = self.moreErrorColor
        ImageBrowserZoomCell.moreProgressTextColor = self.moreProgressTextColor
        ImageBrowserZoomCell.moreProgressColor = self.moreProgressColor
        ImageBrowserZoomCell.moreProgressTintColor = self.moreProgressTintColor
        ImageBrowserZoomCell.moreProgressBackgroundColor = self.moreProgressBackgroundColor
        
        self.imageBrowserCollectionView.register(ImageBrowserZoomCell.self, forCellWithReuseIdentifier: ImageBrowserZoomCell.identifier)
        self.imageBrowserCollectionView.contentInsetAdjustmentBehavior = .never
        self.imageBrowserCollectionView.backgroundColor = .clear
        self.imageBrowserCollectionView.contentInset = .zero
        self.imageBrowserCollectionView.isPagingEnabled = true
        self.imageBrowserCollectionView.delegate = self
        self.imageBrowserCollectionView.dataSource = self
        self.imageBrowserCollectionView.reloadData()
        self.imageBrowserCollectionView.layoutIfNeeded()
        
        self.navigationItem.titleView = self.titleButton
        self.titleButton.addTarget(self, action: #selector(self.shareTap(_:)), for: .touchUpInside)
        let originTitle = "\(self.imageBrowserCollectionView.currentIndex+1) / \(self.imageAssets.count)"
        let title = self.delegate?.imageBrowserItemTitle(self, title: originTitle) ?? originTitle
        self.titleButton.setTitle(title, for: .normal)
        self.titleButton.sizeToFit()
        
        self.imageBrowserCollectionView.scrollToItem(at: IndexPath(row: self.index, section: 0), at: .centeredHorizontally, animated: false)
        self.delegate?.imageBrowserItemWillScroll(self)
        self.delegate?.imageBrowserItemDidScroll(self)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.imageAssets.count > 1 {
            self.isInteractivePopGestureRecognizerEnabled = self.navigationController?.interactivePopGestureRecognizer?.isEnabled
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.imageAssets.count > 1 {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = self.isInteractivePopGestureRecognizerEnabled ?? true
        }
    }
    
    @objc func shareTap(_ sender: UIButton) {
        let index = self.imageBrowserCollectionView.currentIndex
        if index >= self.imageAssets.count { return }
        guard let image = self.imageAssets[index].image else {
            self.delegate?.imageBrowserShareError(self, error: NSError(domain: "Share No Image", code: 404, userInfo: nil) as Error, asset: self.imageAssets[index])
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func moreTap(_ sender: UIBarButtonItem) {
        self._isMore = true
        self.imageBrowserCollectionView.contentInsetAdjustmentBehavior = .always
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = self.isInteractivePopGestureRecognizerEnabled ?? true
        self.titleButton.setTitle("", for: .normal)
        self.titleButton.setImage(nil, for: .normal)
        self.titleButton.sizeToFit()
        self.navigationItem.rightBarButtonItem = nil
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.imageBrowserCollectionView.collectionViewLayout = layout
        self.imageBrowserCollectionView.isPagingEnabled = false
        self.imageBrowserCollectionView.reloadData()
        self.view.backgroundColor = self.moreBackgroundColor
    }
    
    @objc public func backTap(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.imageBrowserDismiss(self)
        } else {
            if let viewController = self.navigationController?.viewControllers.first as? ImageBrowserViewController {
                viewController.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: UICollectionViewDelegate
extension ImageBrowserViewController: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !self.isMore else { return }
        if let collectionView = scrollView as? ImageBrowserCollectionView {
            let originIndex = collectionView.currentIndex
            collectionView.setCurrentIndexListCount(self.imageAssets.count)
            let originTitle = "\(collectionView.currentIndex+1) / \(self.imageAssets.count)"
            let title = self.delegate?.imageBrowserItemTitle(self, title: originTitle) ?? originTitle
            self.titleButton.setTitle(title, for: .normal)
            self.titleButton.sizeToFit()
            if originIndex != collectionView.currentIndex {
                self.delegate?.imageBrowserItemWillScroll(self)
            }
            if CGFloat(collectionView.currentIndex) == collectionView.currentIndexValue {
                DispatchQueue.main.async {
                    self.delegate?.imageBrowserItemDidScroll(self)
                }
            }
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.isMore else { return }
        self._isMore = false
        self.imageBrowserCollectionView.contentInsetAdjustmentBehavior = .never
        self.isInteractivePopGestureRecognizerEnabled = self.navigationController?.interactivePopGestureRecognizer?.isEnabled
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let squareButtonItem = UIBarButtonItem(image: ImageBrowserSquareView.imageView(self.tintColor), style: .plain, target: self, action: #selector(self.moreTap(_:)))
        self.navigationItem.rightBarButtonItem = squareButtonItem
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.imageBrowserCollectionView.collectionViewLayout = layout
        self.imageBrowserCollectionView.isPagingEnabled = true
        self.imageBrowserCollectionView.reloadData()
        self.imageBrowserCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        self.imageBrowserCollectionView.setCurrentIndexListCount(self.imageAssets.count)
        let originTitle = "\(indexPath.row+1) / \(self.imageAssets.count)"
        let title = self.delegate?.imageBrowserItemTitle(self, title: originTitle) ?? originTitle
        self.titleButton.setTitle(title, for: .normal)
        self.titleButton.sizeToFit()
        self.view.backgroundColor = self.zoomBackgroundColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            self.titleButton.setImage(ImageBrowserBottomArrowView.imageView(self.tintColor), for: .normal)
            self.titleButton.sizeToFit()
        }
    }
}

// MARK: UICollectionViewDataSource
extension ImageBrowserViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageAssets.count
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell  as? ImageBrowserZoomCell else { return }
        let indexPath = indexPath
        let index = indexPath.row
        let item = self.imageAssets[index]
        if item.type == .wait {
            if let image = self.delegate?.imageBrowserImageCache(self, url: item.url) {
                self.imageAssets[index].image = image
                self.imageAssets[index].type = .success
                cell.imageAsset = self.imageAssets[index]
            } else {
                self.imageAssets[index].type = .download(progress: 0)
                cell.imageAsset = self.imageAssets[index]
                let url = item.url
                ImageBrowserDownload.load(url, progress: { [weak self] (progress) in
                    self?.imageAssets[index].type = .download(progress: progress)
                    if let cell = self?.imageBrowserCollectionView.cellForItem(at: indexPath) as? ImageBrowserZoomCell {
                        cell.imageAsset = self?.imageAssets[index]
                    }
                }) { [weak self] (error, image) in
                    if error == nil, let image = image {
                        self?.imageAssets[index].image = image
                        self?.imageAssets[index].type = .success
                        if let self = self {
                            self.delegate?.imageBrowserImageDownloadCache(self, url: url, image: image)
                        }
                    } else {
                        self?.imageAssets[index].type = .error(error: error)
                    }
                    if let cell = self?.imageBrowserCollectionView.cellForItem(at: indexPath) as? ImageBrowserZoomCell {
                        cell.imageAsset = self?.imageAssets[index]
                    }
                }
            }
        }
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageBrowserZoomCell.identifier, for: indexPath) as? ImageBrowserZoomCell else {
            return UICollectionViewCell()
        }
        let indexPath = indexPath
        let index = indexPath.row
        let item = self.imageAssets[index]
        cell.isMore = self.isMore
        if item.type == .success {
            cell.imageAsset = item
        } else if item.type == .error(error: nil) {
            self.delegate?.imageBrowserError(self, error: NSError(domain: "No Image", code: 404, userInfo: nil) as Error, asset: item)
            cell.imageAsset = item
        } else if case let .download(progress) = item.type {
            self.imageAssets[index].type = .download(progress: progress)
            cell.imageAsset = self.imageAssets[index]
        }
        return cell
    }
}


// MARK: UICollectionViewDelegateFlowLayout
extension ImageBrowserViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.isMore {
            return CGSize(width: UIScreen.main.bounds.size.width/3 - 4, height: UIScreen.main.bounds.size.width/3 - 4)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if self.isMore {
            return 6
        } else {
            return 0
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if self.isMore {
            return 2
        } else {
            return 0
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.isMore {
            var bottomConstant: CGFloat = 0
            bottomConstant = (UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom)!
            return UIEdgeInsets(top: 0, left: 0, bottom: bottomConstant, right: 0)
        } else {
            return UIEdgeInsets.zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}
