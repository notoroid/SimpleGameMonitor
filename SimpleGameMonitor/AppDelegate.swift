//
//  AppDelegate.swift
//  SimpleGameMonitor
//
//  Created by 能登 要 on 2023/12/08.
//

#if os(macOS)

import AppKit

// referenced by
// https://zenn.dev/ohnami/articles/b9da5d63aba119

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
   }
}

#endif

