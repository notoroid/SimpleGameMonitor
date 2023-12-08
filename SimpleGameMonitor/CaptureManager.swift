//
//  CaptureManager.swift
//  SimpleGameMonitor
//
//  Created by 能登 要 on 2023/10/26.
//

import Foundation
import AVFoundation
import Observation

@Observable class CaptureManager {
    var previewLayer: AVCaptureVideoPreviewLayer? = nil
    @ObservationIgnored var session: AVCaptureSession? = nil
    
    private var rotationCoordinator: AVCaptureDevice.RotationCoordinator? = nil
    private var videoRotationAngleForHorizonLevelPreviewObservation: NSKeyValueObservation?
    
    var test: Bool = true
    
    @MainActor func setupAVCapture() -> Void {
        teardownAVCapture()

//        let deviceTypes:[(String, AVCaptureDevice.DeviceType)] = [
//            (".external",.external),
//            (".microphone(builtInMicrophone)",.microphone),
//            (".builtInWideAngleCamera",.builtInWideAngleCamera),
//            (".builtInTelephotoCamera",.builtInTelephotoCamera),
//            (".builtInUltraWideCamera",.builtInUltraWideCamera),
//            (".builtInDualCamera(builtInDuoCamera)",.builtInDualCamera),
//            (".builtInDualWideCamera",.builtInDualWideCamera),
//            (".builtInTripleCamera",.builtInTripleCamera),
//            (".builtInTrueDepthCamera",.builtInTrueDepthCamera),
//            (".builtInLiDARDepthCamera",.builtInLiDARDepthCamera),
//            (".continuityCamera",.continuityCamera),
////            (".builtInDuoCamera",.builtInDuoCamera),
////            (".builtInMicrophone", .builtInMicrophone)
//        ]

        // only external devices
        let deviceTypes:[(String, AVCaptureDevice.DeviceType)] = [
            (".external",.external),
        ]
        
        for deviceType in deviceTypes {
            if let captureDevice =  AVCaptureDevice.default(deviceType.1, for: .video, position: .unspecified) {
                _ = captureDevice
                print("find: \(deviceType.0)")
                
                if let captureDeviceSupportedBack =  AVCaptureDevice.default(deviceType.1, for: .video, position: .back) {
                    print("      supported back")
                    _ = captureDeviceSupportedBack
                }
                if let captureDeviceSupportedFront =  AVCaptureDevice.default(deviceType.1, for: .video, position: .front) {
                    print("      supported front")
                    _ = captureDeviceSupportedFront
                }
            }
        }
        
        // external
        guard let captureDevice =  AVCaptureDevice.default(AVCaptureDevice.DeviceType.external, for: .video, position: .unspecified) else {
            teardownAVCapture()
            return
        }

        let session = AVCaptureSession()
        guard session.canSetSessionPreset(.hd1920x1080) else  {
            teardownAVCapture()
            return
        }
        session.sessionPreset = .hd1920x1080
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
                print("added session")
            } else {
                print("not add session")
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session:session)
            if let previewLayer {
                previewLayer.backgroundColor = CGColor(gray: 0.5, alpha: 1.0)
                previewLayer.videoGravity = .resizeAspect
                
                // disable mirroring
                previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
                previewLayer.connection?.isVideoMirrored = false
                
                let rotationCoordinator = AVCaptureDevice.RotationCoordinator(device: captureDevice, previewLayer: previewLayer)
                previewLayer.connection?.videoRotationAngle = rotationCoordinator.videoRotationAngleForHorizonLevelPreview
                // Key value opbserver
                videoRotationAngleForHorizonLevelPreviewObservation = rotationCoordinator.observe(\.videoRotationAngleForHorizonLevelPreview, options: .new) { _, change in
                    guard let videoRotationAngleForHorizonLevelPreview = change.newValue else { return }
                    previewLayer.connection?.videoRotationAngle = videoRotationAngleForHorizonLevelPreview
                }
                self.rotationCoordinator = rotationCoordinator
            }
            
            self.session = session
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
        }catch{
            teardownAVCapture()
        }
    }

    @MainActor func teardownAVCapture() -> Void {
        previewLayer?.removeFromSuperlayer()
        previewLayer = nil
        
        rotationCoordinator = nil
        
        if (session?.isRunning ?? false) {
            session?.stopRunning()
        }
        session = nil
    }
    
}
