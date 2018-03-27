//
//  AppDelegate.swift
//  Prowdly
//
//  Created by Conny Hung on 1/11/18.
//  Copyright © 2018 Conny Hung. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Instabug
import XMPPFramework

protocol ChatDelegate {
    func buddyWentOnline(name: String)
    func buddyWentOffline(name: String)
    func didDisconnect()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, XMPPRosterDelegate, XMPPStreamDelegate {

    var window: UIWindow?

    var delegate:ChatDelegate! = nil
    let xmppStream = XMPPStream()
    let xmppRosterStorage = XMPPRosterCoreDataStorage()
    var xmppRoster: XMPPRoster
    
    override init() {
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.isStatusBarHidden = true
        
        setupStream()
        
        Fabric.with([Crashlytics.self])
        
        Instabug.initialize()
        Instabug.start(withToken: "c14e6ec236dd20c67e185cc051df28e8", invocationEvent: .shake)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        disconnect()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        _ = connect()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - XMPPFramework Private Methods
    private func setupStream() {
        xmppStream.hostName = "chat.prowdly.net"
        xmppRoster.activate(xmppStream)
        xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
        xmppRoster.addDelegate(self, delegateQueue: DispatchQueue.main)
    }
    
    private func goOnline() {
        let presence = XMPPPresence()
        let domain = xmppStream.myJID?.domain
        
        if domain == "gmail.com" || domain == "gtalk.com" || domain == "talk.google.com" {
            let priority = DDXMLElement.element(withName: "priority", stringValue: "24") as! DDXMLElement
            presence.addChild(priority)
        }
        xmppStream.send(presence)
    }
    
    private func goOffline() {
        let presence = XMPPPresence(type: "unavailable")
        xmppStream.send(presence)
    }
    
    func connect() -> Bool {
        if !xmppStream.isConnected {
            let jabberID = UserDefaults.standard.string(forKey: "userID")
            let myPassword = UserDefaults.standard.string(forKey: "userPassword")
            
            if !xmppStream.isDisconnected{
                return true
            }
            if jabberID == nil && myPassword == nil {
                return false
            }
            
//            jabberID = jabberID! + "@chat.prowdly.net"
            let userJID = XMPPJID(string: jabberID!)
            xmppStream.myJID = userJID
            
            do {
                try xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
//                let service = NetService(domain: "chat.prowdly.net", type: "xmpp", name: "chat.prowdly.net")
//                try xmppStream.connect(to: XMPPJID(string: jabberID!), withAddress: service.addresses, withTimeout: XMPPStreamTimeoutNone)
                print("Connection success")
                return true
            } catch {
                print("Something went wrong!")
                return false
            }
        } else {
            return true
        }
    }
    
    func disconnect() {
        goOffline()
        xmppStream.disconnect()
    }
    
    // MARK: - XMPPFramework Delegate
    func xmppStreamDidConnect(sender: XMPPStream!) {
        do {
            try xmppStream.authenticate(withPassword: UserDefaults.standard.string(forKey: "userPassword")!)
        } catch {
            print("Could not authenticate")
        }
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        goOnline()
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveIQ iq: XMPPIQ!) -> Bool {
        print("Did receive IQ")
        return false
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        print("Did receive message \(message)")
    }
    
    func xmppStream(sender: XMPPStream!, didSendMessage message: XMPPMessage!) {
        print("Did send message \(message)")
    }
    
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        let presenceType = presence.type
        let myUsername = sender.myJID?.user
        let presenceFromUser = presence.from?.user
        
        if presenceFromUser != myUsername {
            print("Did receive presence from \(presenceFromUser)")
            if presenceType == "available" {
                delegate.buddyWentOnline(name: "\(presenceFromUser)@gmail.com")
            } else if presenceType == "unavailable" {
                delegate.buddyWentOffline(name: "\(presenceFromUser)@gmail.com")
            }
        }
    }
    
    func xmppRoster(sender: XMPPRoster!, didReceiveRosterItem item: DDXMLElement!) {
        print("Did receive Roster item")
    }
}

