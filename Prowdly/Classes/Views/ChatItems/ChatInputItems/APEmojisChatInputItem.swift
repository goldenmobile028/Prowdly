//
//  APEmojisChatInputItem.swift
//  Prowdly
//
//  Created by Conny Hung on 26/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APEmojisChatInputItem {
    typealias Class = APEmojisChatInputItem
    public var emojiInputHandler: ((String) -> Void)?
    
    let buttonAppearance: TabInputButtonAppearance
    public init(tabInputButtonAppearance: TabInputButtonAppearance = Class.createDefaultButtonAppearance()) {
        self.buttonAppearance = tabInputButtonAppearance
    }
    
    public static func createDefaultButtonAppearance() -> TabInputButtonAppearance {
        let images: [UIControlStateWrapper: UIImage] = [
            UIControlStateWrapper(state: .normal): UIImage(named: "emoji")!,
            UIControlStateWrapper(state: .selected): UIImage(named: "emoji_purple")!,
            UIControlStateWrapper(state: .highlighted): UIImage(named: "emoji_purple")!
        ]
        return TabInputButtonAppearance(images: images, size: nil)
    }
    
    lazy fileprivate var internalTabView: TabInputButton = {
        return TabInputButton.makeInputButton(withAppearance: self.buttonAppearance, accessibilityID: "text.chat.input.view")
    }()
    
    open var selected = false {
        didSet {
            self.internalTabView.isSelected = self.selected
        }
    }
}

// MARK: - ChatInputItemProtocol
extension APEmojisChatInputItem: ChatInputItemProtocol {
    public var presentationMode: ChatInputItemPresentationMode {
        return .keyboard
    }
    
    public var showsSendButton: Bool {
        return true
    }
    
    public var inputView: UIView? {
        return nil
    }
    
    public var tabView: UIView {
        return self.internalTabView
    }
    
    public func handleInput(_ input: AnyObject) {
        if let text = input as? String {
            self.emojiInputHandler?(text)
        }
    }
}
