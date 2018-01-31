//
//  APGroupChatViewController.swift
//  Prowdly
//
//  Created by Conny Hung on 19/1/2018.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit

class APGroupChatViewController: BaseChatViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var infoView: APChatHeaderView?
    
    var isFirstAppear = true
    
    var messageSender: DemoChatMessageSender!
    let messagesSelector = BaseMessagesSelector()
    var chatName = "" {
        didSet {
            titleLabel.text = chatName
        }
    }
    
    var dataSource: DemoChatDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
        }
    }
    
    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.messagesSelector.delegate = self
        self.chatItemsDecorator = DemoChatItemsDecorator(messagesSelector: self.messagesSelector)
        
        if self.dataSource.chatItems.count != 0 {
            isFirstAppear = false
            self.navigationController?.isNavigationBarHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstAppear == true {
            navigationController?.isNavigationBarHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstAppear == true {
            isFirstAppear = false
            infoView = APChatHeaderView.viewFromXib()
            infoView?.backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
            infoView?.groupNameLabel.text = chatName
            var frame = infoView?.frame
            frame?.origin = CGPoint(x: 0, y: 28)
            frame?.size = CGSize(width: kScreenW, height: 120)
            infoView?.frame = frame!
            self.view.addSubview(infoView!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - IBAction
    @IBAction func backButtonPressed(_ sender: Any?) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func infoButtonPressed(_ sender: Any?) {
        
    }
    
    @IBAction func printButtonPressed(_ sender: Any?) {
        
    }
    
    var chatInputPresenter: BasicChatInputBarPresenter!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        chatInputView.delegate = self
        var appearance = ChatInputBarAppearance()
        appearance.tabBarAppearance.interItemSpacing = 100
        //appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.sendButtonAppearance.font = UIFont(name: "Poppins-SemiBold", size: 14)!
        appearance.textInputAppearance.font = UIFont(name: "Poppins-Regular", size: 14)!
        appearance.textInputAppearance.placeholderText = NSLocalizedString("  Type a message here", comment: "")
        appearance.textInputAppearance.placeholderFont = UIFont(name: "Poppins-Regular", size: 14)!
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }
    
    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        
        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler)
        )
        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()
        
        let photoMessagePresenter = PhotoMessagePresenterBuilder(
            viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
            interactionHandler: DemoPhotoMessageHandler(baseHandler: self.baseMessageHandler)
        )
        photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellAvatarStyle()
        
        return [
            DemoTextMessageModel.chatItemType: [textMessagePresenter],
            DemoPhotoMessageModel.chatItemType: [photoMessagePresenter],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()]
        ]
    }
    
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createEmojiInputItem())
        items.append(self.createTextInputItem())
        items.append(self.createPhotoInputItem())
        return items
    }
    
    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }
    
    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            self?.dataSource.addPhotoMessage(image)
            self?.infoView?.isHidden = true
            self?.navigationController?.setNavigationBarHidden(false, animated: false)
        }
        return item
    }
    
    private func createEmojiInputItem() -> APEmojisChatInputItem {
        let item = APEmojisChatInputItem()
        item.emojiInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }
    
    private func createFlagInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            self?.dataSource.addPhotoMessage(image)
        }
        return item
    }
}

extension APGroupChatViewController: MessagesSelectorDelegate {
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
    
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
}

extension APGroupChatViewController: ChatInputBarDelegate {
    func inputBarShouldBeginTextEditing(_ inputBar: ChatInputBar) -> Bool {
        return true
    }
    
    func inputBarDidBeginEditing(_ inputBar: ChatInputBar) {
        
    }
    
    func inputBarDidEndEditing(_ inputBar: ChatInputBar) {
        
    }

    func inputBarDidChangeText(_ inputBar: ChatInputBar) {
        
    }

    func inputBarSendButtonPressed(_ inputBar: ChatInputBar) {
        infoView?.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func inputBar(_ inputBar: ChatInputBar, shouldFocusOnItem item: ChatInputItemProtocol) -> Bool {
        return true
    }

    func inputBar(_ inputBar: ChatInputBar, didReceiveFocusOnItem item: ChatInputItemProtocol) {
        
    }

    func inputBarDidShowPlaceholder(_ inputBar: ChatInputBar) {
        
    }

    func inputBarDidHidePlaceholder(_ inputBar: ChatInputBar) {
        
    }
}
