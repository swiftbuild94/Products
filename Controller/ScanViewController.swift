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

	@IBOutlet weak var messageLabel: UILabel!
	
	var stringCode: String?
	var foundCode: Bool = false
	
	var avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
	let avCaptureSession = AVCaptureSession()
	var qrCodeFrame: UIView!
	
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
		
		qrCodeFrame = UIView()
		qrCodeFrame.layer.borderColor = UIColor.green.cgColor
		qrCodeFrame.layer.borderWidth = 4
		qrCodeFrame.isHidden = true
		view.addSubview(qrCodeFrame)
		view.bringSubviewToFront(qrCodeFrame)
		
		foundCode = false
		avCaptureSession.startRunning()
	}
	
	
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		if let metadataObject = metadataObjects.first {
			guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
				qrCodeFrame.isHidden = false
				let barCodeObject = avCaptureVideoPreviewLayer.transformedMetadataObject(for: metadataObject)
				qrCodeFrame?.frame = barCodeObject!.bounds
				return
			}
			guard let stringValue = readableObject.stringValue else { return }
			
//			if supportedCodeTypes.contains(metadataObject.type) {
//				qrCodeFrame.isHidden = false
//				let barCodeObject = avCaptureVideoPreviewLayer.transformedMetadataObject(for: metadataObject)
//				qrCodeFrame?.frame = barCodeObject!.bounds
//			}
			
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			if ((stringValue != "")&&(foundCode == false)){
				foundCode = true
				stringCode = stringValue
//				messageLabel.text = stringCode
				print("Code: \(stringCode!)")
				//avCaptureSession.stopRunning()
//				qrCodeFrame.isHidden = true
//				qrCodeFrame.frame = CGRect.zero
				performSegue(withIdentifier: "segueAddProductToBasket", sender: self)
			}
		}
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		foundCode = false
		let _ = authorizeCamara()
    }
	
	
    // MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "segueAddProductToBasket" {
			
			var destinationvc = segue.destination
			if let navcon = destinationvc as? UINavigationController {
				destinationvc = navcon.visibleViewController ?? destinationvc
			}
			
			if let newVC = destinationvc as? AddProductToBasketViewController {
				if stringCode != nil {
					//newVC.labelProductCode.text = stringCode
					newVC.productCode = stringCode
					//newVC.managedObjectContext = self.managedObjectContext
					//newVC.navigationItem.title = stringCode
				}
			}
		}
    }

}
