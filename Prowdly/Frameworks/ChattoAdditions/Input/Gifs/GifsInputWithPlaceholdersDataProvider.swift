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

protocol GifsInputDataProviderDelegate: class {
    func handleGifsInputDataProviderUpdate(_ dataProvider: GifsInputDataProviderProtocol, updateBlock: @escaping () -> Void)
}

protocol GifsInputDataProviderProtocol: class {
    weak var delegate: GifsInputDataProviderDelegate? { get set }
    var count: Int { get }
    @discardableResult
    func requestPreviewImage(at index: Int,
                             targetSize: CGSize,
                             completion: @escaping GifsInputDataProviderCompletion) -> GifsInputDataProviderImageRequestProtocol
    @discardableResult
    func requestGifImage(at index: Int,
                          progressHandler: GifsInputDataProviderProgressHandler?,
                          completion: @escaping GifsInputDataProviderCompletion) -> GifsInputDataProviderImageRequestProtocol
}

typealias GifsInputDataProviderProgressHandler = (Double) -> Void
typealias GifsInputDataProviderCompletion = (GifsInputDataProviderResult) -> Void

enum GifsInputDataProviderResult {
    case success(UIImage)
    case error(Error?)

    var image: UIImage? {
        guard case let .success(resultImage) = self else { return nil }
        return resultImage
    }
    
    var gifImage: UIImage? {
        guard case let .success(resultGifImage) = self else { return nil }
        return resultGifImage
    }
}

protocol GifsInputDataProviderImageRequestProtocol: class {
    var requestId: Int32 { get }
    var progress: Double { get }

    func observeProgress(with progressHandler: GifsInputDataProviderProgressHandler?,
                         completion: GifsInputDataProviderCompletion?)
    func cancel()
}

final class GifsInputWithPlaceholdersDataProvider: GifsInputDataProviderProtocol, GifsInputDataProviderDelegate {
    weak var delegate: GifsInputDataProviderDelegate?
    private let gifsDataProvider: GifsInputDataProviderProtocol
    private let placeholdersDataProvider: GifsInputDataProviderProtocol

    init(gifsDataProvider: GifsInputDataProviderProtocol, placeholdersDataProvider: GifsInputDataProviderProtocol) {
        self.gifsDataProvider = gifsDataProvider
        self.placeholdersDataProvider = placeholdersDataProvider
        self.gifsDataProvider.delegate = self
    }

    var count: Int {
        return max(self.gifsDataProvider.count, self.placeholdersDataProvider.count)
    }

    @discardableResult
    func requestPreviewImage(at index: Int,
                             targetSize: CGSize,
                             completion: @escaping GifsInputDataProviderCompletion) -> GifsInputDataProviderImageRequestProtocol {
        if index < self.gifsDataProvider.count {
            return self.gifsDataProvider.requestPreviewImage(at: index, targetSize: targetSize, completion: completion)
        } else {
            return self.placeholdersDataProvider.requestPreviewImage(at: index, targetSize: targetSize, completion: completion)
        }
    }

    @discardableResult
    func requestGifImage(at index: Int,
                         progressHandler: GifsInputDataProviderProgressHandler?,
                         completion: @escaping GifsInputDataProviderCompletion) -> GifsInputDataProviderImageRequestProtocol {
        if index < self.gifsDataProvider.count {
            return self.gifsDataProvider.requestGifImage(at: index, progressHandler: progressHandler, completion: completion)
        } else {
            return self.placeholdersDataProvider.requestGifImage(at: index, progressHandler: progressHandler, completion: completion)
        }
    }

    // MARK: GifInputDataProviderDelegate
    func handleGifsInputDataProviderUpdate(_ dataProvider: GifsInputDataProviderProtocol, updateBlock: @escaping () -> Void) {
        self.delegate?.handleGifsInputDataProviderUpdate(self, updateBlock: updateBlock)
    }
}
