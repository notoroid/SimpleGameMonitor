//
//  SimpleGameMonitorApp.swift
//  SimpleGameMonitor
//
//  Created by 能登 要 on 2023/12/08.
//

import SwiftUI

@main
struct SimpleGameMonitorApp: App {
    let captureManager = CaptureManager()
    
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            ContentView(captureManager: captureManager)
        }
    }
}
