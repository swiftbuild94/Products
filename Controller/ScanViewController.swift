//
//  ScanViewController.swift
//  Products
//
//  Created by Patricio Benavente on 18/05/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

	@IBOutlet weak var videoPreview: UIView! //Disabled
	
	@IBOutlet weak var messageLabel: UILabel!
	
	var qrCodeFrameView:UIView?
	var stringCode: String?
	var video = AVCaptureVideoPreviewLayer()
	
	private enum error {
		case noCamaraAvailable
		case videoInputInitFail
	}
	
	private func captureOutput(_ captureOutput: AVCaptureOutput, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){
		print("Capture Output")
		
		/*
		if metadataObjects.count > 0 {
			let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
			if machineReadableCode.type == AVMetadataObject.ObjectType.qr {
				stringCode = machineReadableCode.stringValue
				messageLabel.text = stringCode
			}
		}
		*/
		
		if  metadataObjects.count == 0 {
			qrCodeFrameView?.frame = CGRect.zero
			messageLabel.text = "No code is detected"
			return
		}else{
			let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
			let barCodeObject = video.transformedMetadataObject(for: metadataObj)
			qrCodeFrameView?.frame = barCodeObject!.bounds
			if metadataObj.stringValue != nil {
				stringCode = metadataObj.stringValue
				messageLabel.text = stringCode
			}
		}
	}
	
	private func scanCode() {
		let avCaptureSession = AVCaptureSession()
		guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
			print("No Camara")
			return
		}
		guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
			print("Failed to init camara.")
			return
		}
		
		let avCaptureOutput = AVCaptureMetadataOutput()
		avCaptureOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
		
		avCaptureSession.addInput(avCaptureInput)
		avCaptureSession.addOutput(avCaptureOutput)
		
		avCaptureOutput.metadataObjectTypes = [.aztec,.code128,.code39,.code39Mod43,.code93,.ean13,.ean8,.ean13,.interleaved2of5,.itf14,.pdf417,.qr,.upce]
		/*
		let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
		videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
		videoPreviewLayer.frame = view.layer.bounds
		view.layer.addSublayer(videoPreviewLayer)
		*/
		
		video = AVCaptureVideoPreviewLayer(session: avCaptureSession)
		video.videoGravity = AVLayerVideoGravity.resizeAspectFill
		video.frame = view.layer.bounds
		view.layer.addSublayer(video)
		//self.view.bringSubviewToFront(videoPreview)
		self.view.bringSubviewToFront(messageLabel)
		
		if let qrCodeFrameView = qrCodeFrameView {
			qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
			qrCodeFrameView.layer.borderWidth = 2
			self.view.addSubview(qrCodeFrameView)
			self.view.bringSubviewToFront(qrCodeFrameView)
		}
		
		avCaptureSession.startRunning()
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		scanCode()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
