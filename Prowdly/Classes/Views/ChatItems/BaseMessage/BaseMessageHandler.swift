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

import Foundation

public protocol DemoMessageViewModelProtocol {
    var messageModel: DemoMessageModelProtocol { get }
}

class BaseMessageHandler {

    private let messageSender: DemoChatMessageSender
    private let messagesSelector: MessagesSelectorProtocol

    init(messageSender: DemoChatMessageSender, messagesSelector: MessagesSelectorProtocol) {
        self.messageSender = messageSender
        self.messagesSelector = messagesSelector
    }
    func userDidTapOnFailIcon(viewModel: DemoMessageViewModelProtocol) {
        print("userDidTapOnFailIcon")
        self.messageSender.sendMessage(viewModel.messageModel)
    }

    func userDidTapOnAvatar(viewModel: MessageViewModelProtocol) {
        print("userDidTapOnAvatar")
    }

    func userDidTapOnBubble(viewModel: DemoMessageViewModelProtocol) {
        print("userDidTapOnBubble")
    }

    func userDidBeginLongPressOnBubble(viewModel: DemoMessageViewModelProtocol) {
        print("userDidBeginLongPressOnBubble")
//        let imageToShare = [ viewModel.messageModel.type ]
//        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//
//        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
//
//        // present the view controller
//        self.present(activityViewController, animated: true, completion: nil)
    }

    func userDidEndLongPressOnBubble(viewModel: DemoMessageViewModelProtocol) {
        print("userDidEndLongPressOnBubble")
    }

    func userDidSelectMessage(viewModel: DemoMessageViewModelProtocol) {
        print("userDidSelectMessage")
        self.messagesSelector.selectMessage(viewModel.messageModel)
    }

    func userDidDeselectMessage(viewModel: DemoMessageViewModelProtocol) {
        print("userDidDeselectMessage")
        self.messagesSelector.deselectMessage(viewModel.messageModel)
    }
}
