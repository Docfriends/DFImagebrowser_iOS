//
//  ImageBrowserDownload
//  

import UIKit

class ImageBrowserDownload: NSObject {
    private var url: URL?
    
    private var progressCallback: ((Float) -> Void)? = nil
    private var callback: ((Error?, UIImage?) -> Void)? = nil
    
    @discardableResult
    static func load(_ url: URL?, progress: ((Float) -> Void)? = nil, callback: ((Error?, UIImage?) -> Void)? = nil) -> ImageBrowserDownload {
        let download = ImageBrowserDownload(url)
        download.task(progress, callback: callback)
        return download
    }
    
    init(_ url: URL?) {
        super.init()
        self.url = url
    }
    
    func task(_ progress: ((Float) -> Void)? = nil, callback: ((Error?, UIImage?) -> Void)? = nil) {
        guard let url = self.url else {
            callback?(NSError(domain: "Invalid URL", code: 404, userInfo: nil), nil)
            return
        }
        self.callback = callback
        self.progressCallback = progress
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        DispatchQueue.global().async {
            session.downloadTask(with: url).resume()
        }
    }
}

// MARK: URLSessionDelegate
extension ImageBrowserDownload: URLSessionDelegate {
    
}

// MAKR: URLSessionDownloadDelegate
extension ImageBrowserDownload: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.progressCallback?(progress)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.callback?(nil, image)
                    self.callback = nil
                    self.progressCallback = nil
                }
            } else {
                DispatchQueue.main.async {
                    self.callback?(NSError(domain: "Not found image", code: 304, userInfo: nil), nil)
                    self.callback = nil
                    self.progressCallback = nil
                }
            }
        } catch let error {
            DispatchQueue.main.async {
                self.callback?(error, nil)
                self.callback = nil
                self.progressCallback = nil
            }
        }
        
    }
    
}
