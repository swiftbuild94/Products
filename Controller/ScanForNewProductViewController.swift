//
//  ScanForNewProductViewController.swift
//  Products
//
//  Created by Patricio Benavente on 8/06/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit
import AVFoundation

class ScanForNewProductViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

	@IBOutlet weak var messageLabel: UILabel!
	
	@IBOutlet var qrCodeFrameView: UIView!
	
	var stringCode: String?
	var foundCode: Bool = false
	
	var avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
	let avCaptureSession = AVCaptureSession()
	var qrCodeFrame: UIView!
	
	private enum error {
		case noCamaraAvailable
		case videoInputInitFail
	}
	
	private let supportedCodeTypes: [AVMetadataObject.ObjectType] = [.upce, .code39, .code39Mod43, .code93, .code128, .ean8, .ean13, .aztec, .pdf417, .itf14, .dataMatrix, .interleaved2of5, .qr]
	
	private func authorizeCamara()->Bool {
		var authorized = false
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized: // The user has previously granted access to the camera.
			self.scanCode()
			authorized = true
		case .notDetermined: // The user has not yet been asked for camera access.
			AVCaptureDevice.requestAccess(for: .video) { granted in
				if granted {
					self.scanCode()
					authorized = true
				}else{
					authorized = false
				}
			}
		case .denied: // The user has previously denied access.
			authorized = false
		case .restricted: // The user can't grant access due to restrictions.
			authorized = false
		}
		print("Camara Authorized: \(authorized)")
		return authorized
	}
	
	private func scanCode() {
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
		
		avCaptureOutput.metadataObjectTypes = [.upce,.aztec,.code128,.code39,.code39Mod43,.code93,.ean13,.ean8,.ean13,.interleaved2of5,.itf14,.pdf417,.qr]
		
		avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
		avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
		avCaptureVideoPreviewLayer.frame = view.layer.bounds
		self.view.layer.addSublayer(avCaptureVideoPreviewLayer)
		self.view.bringSubviewToFront(messageLabel)
		
//		qrCodeFrameView = UIView()
		qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
		qrCodeFrameView.layer.borderWidth = 4
		qrCodeFrameView.isHidden = true
		view.addSubview(qrCodeFrameView)
		view.bringSubviewToFront(qrCodeFrameView)
		
		avCaptureSession.startRunning()
	}
	
//	private func captureOutput(_ captureOutput: AVCaptureOutput, didOutputMetadataObjects metadataObjects: [AVMetadataObject]!, from connection: AVCaptureConnection!){
//		print("Capture Output")
//
//		if  metadataObjects.count == 0 {
//			qrCodeFrameView?.frame = CGRect.zero
//			messageLabel.text = "No code is detected"
//			return
//		}
//		let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//		//if supportedCodeTypes.contains(metadataObj.type) {
//		//if metadataObj.type.rawValue == ".qr" {
//		//convertFromAVMetadataObjectObjectType(AVMetadataObject.ObjectType.qr) {
//
//		let barCodeObject = avCaptureVideoPreviewLayer.transformedMetadataObject(for: metadataObj)
//		qrCodeFrameView?.frame = barCodeObject!.bounds
//		if metadataObj.stringValue != nil {
//			stringCode = metadataObj.stringValue
//			messageLabel.text = stringCode
//		}
//		//}
//	}
	
	private func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		if let metadataObject = metadataObjects.first {
			guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
				qrCodeFrameView.isHidden = true
				let barCodeObject = avCaptureVideoPreviewLayer.transformedMetadataObject(for: metadataObject)
				qrCodeFrameView?.frame = barCodeObject!.bounds
				foundCode = false
				print("Error metadataObject")
				return
			}
			guard let stringValue = readableObject.stringValue else { return }
			
			if supportedCodeTypes.contains(metadataObject.type) {
				qrCodeFrameView.isHidden = false
				let barCodeObject = avCaptureVideoPreviewLayer.transformedMetadataObject(for: metadataObject)
				qrCodeFrameView?.frame = barCodeObject!.bounds
				
				AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
				if ((stringValue != "")&&(foundCode == false)){
					foundCode = true
					stringCode = stringValue
					messageLabel.text = stringCode
					print("Code: \(stringCode!)")
					//avCaptureSession.stopRunning()
					qrCodeFrameView.isHidden = true
					//foundCode = false
					performSegue(withIdentifier: "SegueNewProduct", sender: self)
				}
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		foundCode = false
		qrCodeFrameView.isHidden = true
		qrCodeFrameView.layer.borderWidth = 0
		let _ = authorizeCamara()
		/*
		if (avCaptureSession.isRunning == false) {
		avCaptureSession.startRunning()
		}
		*/
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		/*
		if (avCaptureSession.isRunning == true) {
		avCaptureSession.stopRunning()
		}
		*/
	}
	
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SegueNewProduct" {
			
			var destinationVC = segue.destination
			if let navcon = destinationVC as? UINavigationController {
				destinationVC = navcon.visibleViewController ?? destinationVC
			}
			
			if let newVC = destinationVC as? ProductViewController {
				if stringCode != nil {
					newVC.productCode = stringCode!
					//newVC.managedObjectContext = self.managedObjectContext
					//newVC.navigationItem.title = stringCode
				}
			}
		}
	}
	
}
