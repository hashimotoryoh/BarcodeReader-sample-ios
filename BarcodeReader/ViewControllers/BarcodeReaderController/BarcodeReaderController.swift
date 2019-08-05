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
            let output: AVCaptureMetadataOutput = {
                let output = AVCaptureMetadataOutput()
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                return output
            }()
            session.addOutput(output)
            output.metadataObjectTypes = [.qr, .ean8, .ean13]
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

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureView.subviews.forEach { $0.removeFromSuperview() }
        for object in metadataObjects {
            self.drawMarker(for: object)
        }
    }

    private func drawMarker(for object: AVMetadataObject) {
        let view = UIView(frame: capturePreviewLayer.layerRectConverted(fromMetadataOutputRect: object.bounds))
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor
        captureView.addSubview(view)
    }

}
