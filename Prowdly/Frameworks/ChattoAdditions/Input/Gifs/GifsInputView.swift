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

import UIKit
import Photos

public struct GifsInputViewAppearance {
    public var liveCameraCellAppearence: LiveCameraCellAppearance
    public init(liveCameraCellAppearence: LiveCameraCellAppearance) {
        self.liveCameraCellAppearence = liveCameraCellAppearence
    }
}

protocol GifsInputViewProtocol {
    weak var delegate: GifsInputViewDelegate? { get set }
    weak var presentingController: UIViewController? { get }
}

protocol GifsInputViewDelegate: class {
    func inputView(_ inputView: GifsInputViewProtocol, didSelectGif image: UIImage)
}

class GifsInputView: UIView, GifsInputViewProtocol {

    fileprivate lazy var collectionViewQueue = SerialTaskQueue()
    fileprivate var collectionView: UICollectionView!
    fileprivate var collectionViewLayout: UICollectionViewFlowLayout!
    fileprivate var dataProvider: GifsInputDataProviderProtocol!
    fileprivate var cellProvider: GifsInputCellProviderProtocol!
    fileprivate var itemSizeCalculator: GifsInputViewItemSizeCalculator!

    weak var delegate: GifsInputViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    weak var presentingController: UIViewController?
    var appearance: GifsInputViewAppearance?
    init(presentingController: UIViewController?, appearance: GifsInputViewAppearance) {
        super.init(frame: CGRect.zero)
        self.presentingController = presentingController
        self.appearance = appearance
        self.commonInit()
    }

    deinit {
        self.collectionView.dataSource = nil
        self.collectionView.delegate = nil
    }

    private func commonInit() {
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.configureCollectionView()
        self.configureItemSizeCalculator()
        self.dataProvider = GifsInputPlaceholderDataProvider()
        self.cellProvider = GifsInputPlaceholderCellProvider(collectionView: self.collectionView)
        self.collectionViewQueue.start()
        requestAccessToGif()
    }

    private func configureItemSizeCalculator() {
        self.itemSizeCalculator = GifsInputViewItemSizeCalculator()
        self.itemSizeCalculator.itemsPerRow = 3
        self.itemSizeCalculator.interitemSpace = 1
    }

    private func requestAccessToGif() {
        self.replacePlaceholderItemsWithPhotoItems()
    }
    
    private func replacePlaceholderItemsWithPhotoItems() {
        self.collectionViewQueue.addTask { [weak self] (completion) in
            guard let sSelf = self else { return }
            
            let newDataProvider = GifsInputWithPlaceholdersDataProvider(gifsDataProvider: GifsInputDataProvider(), placeholdersDataProvider: GifsInputPlaceholderDataProvider())
            newDataProvider.delegate = sSelf
            sSelf.dataProvider = newDataProvider
            sSelf.cellProvider = GifsInputCellProvider(collectionView: sSelf.collectionView, dataProvider: newDataProvider)
            sSelf.collectionView.reloadData()
            DispatchQueue.main.async(execute: completion)
        }
    }
    
    func reload() {
        self.collectionViewQueue.addTask { [weak self] (completion) in
            self?.collectionView.reloadData()
            DispatchQueue.main.async(execute: completion)
        }
    }
}

extension GifsInputView: UICollectionViewDataSource {

    func configureCollectionView() {
        self.collectionViewLayout = GifsInputCollectionViewLayout()
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false

        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.addSubview(self.collectionView)
        self.addConstraint(NSLayoutConstraint(item: self.collectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.collectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataProvider.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        cell = self.cellProvider.cellForItem(at: indexPath)
        return cell
    }
}

extension GifsInputView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let request = self.dataProvider.requestGifImage(at: indexPath.item, progressHandler: nil, completion: { [weak self] result in
            guard let sSelf = self, let image = result.image else { return }
            sSelf.delegate?.inputView(sSelf, didSelectGif: image)
        })
        self.cellProvider.configureGifImageLoadingIndicator(at: indexPath, request: request)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSizeCalculator.itemSizeForWidth(collectionView.bounds.width, atIndex: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.itemSizeCalculator.interitemSpace
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.itemSizeCalculator.interitemSpace
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

extension GifsInputView: GifsInputDataProviderDelegate {
    func handleGifsInputDataProviderUpdate(_ dataProvider: GifsInputDataProviderProtocol, updateBlock: @escaping () -> Void) {
        self.collectionViewQueue.addTask { [weak self] (completion) in
            guard let sSelf = self else { return }

            updateBlock()
            sSelf.collectionView.reloadData()
            DispatchQueue.main.async(execute: completion)
        }
    }

}

private class GifsInputCollectionViewLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.width != self.collectionView?.bounds.width
    }
}
