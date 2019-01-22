//
//  ImageBrowserAsset
//

import UIKit

public enum ImageDownloadType: Equatable {
    case success
    case wait
    case download(progress: Float)
    case error(error: Error?)
    
    public static func == (lhs: ImageDownloadType, rhs: ImageDownloadType) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.wait, .wait):
            return true
        case (.download, .download):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}

public struct ImageBrowserAsset {
    var type = ImageDownloadType.wait
    
    public var image: UIImage?
    public var thumbnailImage: UIImage?
    
    public var url: URL?
    
    public init(image: UIImage?, thumbnailImage: UIImage? = nil) {
        if let image = image {
            self.type = .success
            self.image = image
        } else {
            self.type = .error(error: NSError(domain: "Not found image", code: 503, userInfo: nil))
            self.image = nil
        }
        self.thumbnailImage = thumbnailImage
    }
    
    public init(url: URL?, thumbnailImage: UIImage? = nil) {
        self.type = .wait
        self.url = url
        self.thumbnailImage = thumbnailImage
    }
}
