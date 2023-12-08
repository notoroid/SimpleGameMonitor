//
//  PreviewView.swift
//  SimpleGameMonitor
//
//  Created by 能登 要 on 2023/12/08.
//

import SwiftUI
import AVFoundation

class PreviewCommonCoordinator: NSObject {
    
}

#if os(iOS)
import UIKit

//MARK: PreviewView for iOS/iPadOS

struct PreviewView: UIViewRepresentable {
    var previewLayer: AVCaptureVideoPreviewLayer? = nil
    
    typealias UIViewType = InternalView
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.previewLayer = previewLayer
        return coordinator
    }
    func makeUIView(context: Context) -> UIViewType {
        return InternalView()
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.backgroundColor = .black
        uiView.previewLayer = context.coordinator.previewLayer
    }
    class Coordinator: PreviewCommonCoordinator {
        var previewLayer: AVCaptureVideoPreviewLayer? = nil
    }
}

#elseif os(macOS)
import AppKit

//MARK: PreviewView.InternalView for macOS

struct PreviewView: NSViewRepresentable {
    var previewLayer: AVCaptureVideoPreviewLayer? = nil
    typealias NSViewType = InternalView
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.previewLayer = previewLayer
        return coordinator
    }
    
    func makeNSView(context: Context) -> InternalView {
        return InternalView()
    }
    
    func updateNSView(_ nsView: InternalView, context: Context) {
        nsView.backgroundColor = .black
        nsView.previewLayer = context.coordinator.previewLayer
    }
    
    class Coordinator: PreviewCommonCoordinator {
        var previewLayer: AVCaptureVideoPreviewLayer? = nil
    }
}
#endif


#if os(iOS)
//MARK: PreviewView.InternalView for iOS/iPadOS
extension PreviewView {
    class InternalView: UIView {
        typealias PreviewLayer = AVCaptureVideoPreviewLayer
        
        var previewLayer: PreviewLayer? = nil

        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            
            guard let previewLayer else {
                return
            }
            if previewLayer.superlayer != layer {
                previewLayer.frame = layer.bounds
                self.layer.addSublayer(
                    previewLayer
                )
            } else {
                previewLayer.frame = layer.bounds
            }

        }
    }
}

#elseif os(macOS)

// https://copyprogramming.com/howto/how-to-add-a-calayer-to-an-nsview-on-mac-os-x

//MARK: PreviewView.InternalView for macOS
extension PreviewView {
    
    class InternalView: NSView {
        override init(frame: CGRect) {
            super.init(frame: frame)
        
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
}

extension PreviewView.InternalView {
    var previewLayer: CALayer? {
        get {
            return layer
        }
        set {
            wantsLayer = true
            let oldBackgroundColor: CGColor? = layer?.backgroundColor
            layer = newValue
            layer?.backgroundColor = oldBackgroundColor
        }
    }

    @IBInspectable var backgroundColor: NSColor? {
        get {
            guard let backgroundColor = layer?.backgroundColor else {
                return nil
            }
            return NSColor(cgColor: backgroundColor)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
    
}

#endif



