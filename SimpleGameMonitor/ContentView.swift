//
//  ContentView.swift
//  SimpleGameMonitor
//
//  Created by 能登 要 on 2023/12/08.
//

import SwiftUI

struct ContentView: View {
    let captureManager: CaptureManager
    
    var body: some View {
        VStack {
            if captureManager.previewLayer != nil {
                PreviewView(previewLayer: captureManager.previewLayer)
            } else {
                Rectangle()
                    .fill(.green)
            }
        }
            .foregroundColor(.red)
            .background( .black )
        #if os(iOS)
            .ignoresSafeArea(.container, edges: .bottom)
        #endif
            .onAppear(perform: {
                captureManager.setupAVCapture()
            })
            .onDisappear(perform: {
                captureManager.teardownAVCapture()
            })
    }
}

#Preview {
    ContentView( captureManager: CaptureManager() )
}
