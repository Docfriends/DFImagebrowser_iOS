//
//  ViewController.swift
//  df-imagebrowser-ios
//
//  Created by pikachu987 on 01/21/2019.
//  Copyright (c) 2019 pikachu987. All rights reserved.
//

import UIKit
import df_imagebrowser_ios

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button1 = UIButton(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 100))
        button1.setTitle("싱글", for: .normal)
        button1.setTitleColor(.black, for: .normal)
        button1.addTarget(self, action: #selector(self.button1Tap(_:)), for: .touchUpInside)
        self.view.addSubview(button1)
        
        let button2 = UIButton(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 100))
        button2.setTitle("멀티", for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button2.addTarget(self, action: #selector(self.button2Tap(_:)), for: .touchUpInside)
        self.view.addSubview(button2)
        
        let button3 = UIButton(frame: CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 100))
        button3.setTitle("멀티 index", for: .normal)
        button3.setTitleColor(.black, for: .normal)
        button3.addTarget(self, action: #selector(self.button3Tap(_:)), for: .touchUpInside)
        self.view.addSubview(button3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func button1Tap(_ sender: UIButton) {
        let assets = [ImageBrowserAsset(url: URL(string: "http://ww2.sjkoreancatholic.org/files/testing_image.jpg"))]
        let viewController = ImageBrowserViewController.instance(assets)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func button2Tap(_ sender: UIButton) {
        let assets = [
            ImageBrowserAsset(url: URL(string: "http://ww2.sjkoreancatholic.org/files/testing_image.jpg")),
            ImageBrowserAsset(url: URL(string: "http://cfs7.tistory.com/upload_control/download.blog?fhandle=YmxvZzgyMzM1QGZzNy50aXN0b3J5LmNvbTovYXR0YWNoLzAvMDYwMDAwMDAwMDAwLmpwZw%3D%3D")),
            ImageBrowserAsset(url: URL(string: "https://cdn.pixabay.com/photo/2015/03/01/11/17/arrangement-654573_960_720.jpg")),
            ImageBrowserAsset(url: URL(string: "https://t1.daumcdn.net/cfile/tistory/2019F9354D9D2A000D")),
            ImageBrowserAsset(url: URL(string: "http://cfs11.tistory.com/image/33/tistory/2009/02/26/22/41/49a69bf854e7c")),
            ImageBrowserAsset(url: URL(string: "https://cdn.pixabay.com/photo/2014/12/17/14/20/summer-anemone-571531_960_720.jpg")),
            ImageBrowserAsset(url: URL(string: "https://byline.network/wp-content/uploads/2018/05/cat.png")),
        ]
        let viewController = ImageBrowserViewController.instance(assets)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func button3Tap(_ sender: UIButton) {
        let assets = [
            ImageBrowserAsset(url: URL(string: "http://ww2.sjkoreancatholic.org/files/testing_image.jpg")),
            ImageBrowserAsset(url: URL(string: "http://cfs7.tistory.com/upload_control/download.blog?fhandle=YmxvZzgyMzM1QGZzNy50aXN0b3J5LmNvbTovYXR0YWNoLzAvMDYwMDAwMDAwMDAwLmpwZw%3D%3D")),
            ImageBrowserAsset(url: URL(string: "https://cdn.pixabay.com/photo/2015/03/01/11/17/arrangement-654573_960_720.jpg")),
            ImageBrowserAsset(url: URL(string: "https://t1.daumcdn.net/cfile/tistory/2019F9354D9D2A000D")),
            ImageBrowserAsset(url: URL(string: "http://cfs11.tistory.com/image/33/tistory/2009/02/26/22/41/49a69bf854e7c")),
            ImageBrowserAsset(url: URL(string: "https://cdn.pixabay.com/photo/2014/12/17/14/20/summer-anemone-571531_960_720.jpg")),
            ImageBrowserAsset(url: URL(string: "https://byline.network/wp-content/uploads/2018/05/cat.png")),
            ImageBrowserAsset(url: URL(string: "https://t1.daumcdn.net/cfile/tistory/24283C3858F778CA2E")),
            ImageBrowserAsset(url: URL(string: "https://pbs.twimg.com/media/DW-E70PV4AAl86E.jpg")),
            ImageBrowserAsset(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhdqiz_pFt79gczCCzODGYGS-iqqDSi1JvYToBXpUQ5SBQiZ5pEg")),
            ImageBrowserAsset(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJu7L6VPKSLfcTtCOp1QdcJuxM0z5rU2-jykh2XgGjUHMEX5Au4Q")),
            ImageBrowserAsset(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO-ILfVDrkaJicjFftxV3l9MREpN0wWO0Mdme2nrzReeFfcdbzEg")),
            ImageBrowserAsset(url: URL(string: "http://ww2.sjkoreancatholic.org/files/testing_image.jpg")),
            ImageBrowserAsset(url: URL(string: "http://cfs7.tistory.com/upload_control/download.blog?fhandle=YmxvZzgyMzM1QGZzNy50aXN0b3J5LmNvbTovYXR0YWNoLzAvMDYwMDAwMDAwMDAwLmpwZw%3D%3D")),
            ImageBrowserAsset(url: URL(string: "https://cdn.pixabay.com/photo/2015/03/01/11/17/arrangement-654573_960_720.jpg")),
            ImageBrowserAsset(url: URL(string: "https://t1.daumcdn.net/cfile/tistory/2019F9354D9D2A000D")),
            ImageBrowserAsset(url: URL(string: "http://cfs11.tistory.com/image/33/tistory/2009/02/26/22/41/49a69bf854e7c")),
            ImageBrowserAsset(url: URL(string: "https://cdn.pixabay.com/photo/2014/12/17/14/20/summer-anemone-571531_960_720.jpg")),
            ImageBrowserAsset(url: URL(string: "https://byline.network/wp-content/uploads/2018/05/cat.png")),
            ImageBrowserAsset(url: URL(string: "https://t1.daumcdn.net/cfile/tistory/24283C3858F778CA2E")),
            ImageBrowserAsset(url: URL(string: "https://pbs.twimg.com/media/DW-E70PV4AAl86E.jpg")),
            ImageBrowserAsset(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhdqiz_pFt79gczCCzODGYGS-iqqDSi1JvYToBXpUQ5SBQiZ5pEg")),
            ImageBrowserAsset(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJu7L6VPKSLfcTtCOp1QdcJuxM0z5rU2-jykh2XgGjUHMEX5Au4Q")),
            ImageBrowserAsset(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO-ILfVDrkaJicjFftxV3l9MREpN0wWO0Mdme2nrzReeFfcdbzEg")),
            ]
        let viewController = ImageBrowserViewController.instance(assets, index: 9)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}


extension ImageBrowserViewController {
    static func instance(_ imageAssets: [ImageBrowserAsset], index: Int = 0) -> ImageBrowserViewController {
        let viewController = ImageBrowserViewController(imageAssets, index: index)
        viewController.barTintColor = UIColor(red: 65/255, green: 178/255, blue: 249/255, alpha: 1)
        viewController.tintColor = .white
        viewController.zoomProgressTintColor = UIColor.red
        viewController.moreProgressTintColor = UIColor.red
        viewController.isMoreButtonHidden = imageAssets.count < 2
        return viewController
    }
}
