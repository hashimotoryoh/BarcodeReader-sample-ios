//
//  BarcodeReaderController.swift
//  BarcodeReader
//
//  Created by 橋本 龍 on 2019/08/05.
//  Copyright © 2019 Ryoh Hashimoto. All rights reserved.
//

import UIKit
import AVFoundation

final class BarcodeReaderController: UIViewController, StoryboardInstantiable {

    // MARK: Propeties

    var captureView: UIView! {
        return view
    }

    var captureSession: AVCaptureSession!
    var capturePreviewLayer: AVCaptureVideoPreviewLayer!

    var error: Error? {
        didSet {
            if let e = error as NSError? {
                let alert = UIAlertController(title: e.localizedDescription, message: e.localizedFailureReason, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }


    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let session = AVCaptureSession()
            session.addInput(try {
                let device = AVCaptureDevice.default(for: .video)
                return try AVCaptureDeviceInput(device: device!)
            }())
            session.addOutput({
                let output = AVCaptureMetadataOutput()
                output.metadataObjectTypes = output.availableMetadataObjectTypes
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                return output
            }())
            captureSession = session

            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            captureView.layer.addSublayer(previewLayer)
            capturePreviewLayer = previewLayer
        } catch {
            self.error = error
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        capturePreviewLayer.frame = captureView.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }

}

extension BarcodeReaderController: AVCaptureMetadataOutputObjectsDelegate {

}
