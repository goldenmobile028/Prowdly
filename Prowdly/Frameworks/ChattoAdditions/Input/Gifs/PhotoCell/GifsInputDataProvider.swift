/*
 The MIT License (MIT)
 
 Copyright (c) 2015-present Badoo Trading Limited.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import PhotosUI
import UIKit
import SwiftyGif

private class GifsInputDataProviderImageRequest: GifsInputDataProviderImageRequestProtocol {
    fileprivate(set) var requestId: Int32 = -1
    private(set) var progress: Double = 0
    fileprivate var cancelBlock: (() -> Void)?

    private var progressHandlers = [GifsInputDataProviderProgressHandler]()
    private var completionHandlers = [GifsInputDataProviderCompletion]()

    func observeProgress(with progressHandler: GifsInputDataProviderProgressHandler?,
                         completion: GifsInputDataProviderCompletion?) {
        if let progressHandler = progressHandler {
            self.progressHandlers.append(progressHandler)
        }
        if let completion = completion {
            self.completionHandlers.append(completion)
        }
    }

    func cancel() {
        self.cancelBlock?()
    }

    fileprivate func handleProgressChange(with progress: Double) {
        self.progressHandlers.forEach { $0(progress) }
        self.progress = progress
    }

    fileprivate func handleCompletion(with result: GifsInputDataProviderResult) {
        self.completionHandlers.forEach { $0(result) }
    }
}

@objc
final class GifsInputDataProvider: NSObject, GifsInputDataProviderProtocol {
    weak var delegate: GifsInputDataProviderDelegate?
    private var fetchResult: [String] = []
    override init() {
        if let path = Bundle.main.path(forResource: "gif_pack1", ofType: "plist") {
            if let root = NSDictionary(contentsOfFile: path) as? [String: Any] {
                fetchResult = root["Elements"] as! [String]
            }
        }
        super.init()
    }

    deinit {
        fetchResult.removeAll()
    }

    var count: Int {
        return self.fetchResult.count
    }

    func requestPreviewImage(at index: Int,
                             targetSize: CGSize,
                             completion: @escaping GifsInputDataProviderCompletion) -> GifsInputDataProviderImageRequestProtocol {
        assert(index >= 0 && index < self.fetchResult.count, "Index out of bounds")
        let asset = self.fetchResult[index]
        let request = GifsInputDataProviderImageRequest()
        request.observeProgress(with: nil, completion: completion)
        let requestId = arc4random_uniform(1048576)
        let result: GifsInputDataProviderResult
        if let image = UIImage(named: "thumb_\(asset)") {
            result = .success(image)
        } else {
            result = .error(nil)
        }
        request.handleCompletion(with: result)
        request.cancelBlock = { [weak self] in
            
        }
        request.requestId = Int32(requestId)
        return request
    }

    func requestGifImage(at index: Int,
                          progressHandler: GifsInputDataProviderProgressHandler?,
                          completion: @escaping GifsInputDataProviderCompletion) -> GifsInputDataProviderImageRequestProtocol {
        assert(index >= 0 && index < self.fetchResult.count, "Index out of bounds")
        let asset = self.fetchResult[index]
        let request = GifsInputDataProviderImageRequest()
        request.observeProgress(with: progressHandler, completion: completion)
        let requestId = arc4random_uniform(1048576)
        let result: GifsInputDataProviderResult
//        let url = Bundle.main.url(forResource: asset, withExtension: "gif")
//        let image = UIImage.animatedImage(withAnimatedGIFURL: url)
        let image = UIImage.gif(name: asset)!
//        let image = UIImage(gifName: asset)
        result = .success(image)
        request.handleCompletion(with: result)
        request.cancelBlock = { [weak self, weak request] in
            
        }
        request.requestId = Int32(requestId)
        return request
    }
}
