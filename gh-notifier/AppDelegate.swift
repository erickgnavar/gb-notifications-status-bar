//
//  AppDelegate.swift
//  gh-notifier
//
//  Created by Erick Navarro on 6/2/20.
//  Copyright © 2020 Erick Navarro. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let api = GithubApi()
    let interval = 5 // minutes

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "0 notifications"
        statusItem.button?.target = self
        statusItem.button?.action = #selector(openGithubNotificationsPage)
        // first load
        setTitle()
        // setup timer
        Timer.scheduledTimer(timeInterval: 60 * Double(interval), target: self, selector: #selector(setTitle), userInfo: nil, repeats: true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func setTitle() {
        api.getNotifications() {(quantity) in
            DispatchQueue.main.async {
                self.statusItem.button?.title = "\(quantity) notifications"
            }
        }
    }

    @objc func openGithubNotificationsPage() {
        NSWorkspace.shared.open(URL(string: "https://github.com/notifications")!)
    }

}

