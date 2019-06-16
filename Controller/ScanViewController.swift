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
	
	private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
									  AVMetadataObject.ObjectType.code39,
									  AVMetadataObject.ObjectType.code39Mod43,
									  AVMetadataObject.ObjectType.code93,
									  AVMetadataObject.ObjectType.code128,
									  AVMetadataObject.ObjectType.ean8,
									  AVMetadataObject.ObjectType.ean13,
									  AVMetadataObject.ObjectType.aztec,
									  AVMetadataObject.ObjectType.pdf417,
									  AVMetadataObject.ObjectType.itf14,
									  AVMetadataObject.ObjectType.dataMatrix,
									  AVMetadataObject.ObjectType.interleaved2of5,
									  AVMetadataObject.ObjectType.qr]
	
	private func captureOutput(_ captureOutput: AVCaptureOutput, didOutputMetadataObjects metadataObjects: [AVMetadataObject]!, from connection: AVCaptureConnection!){
		print("Capture Output")
		
		if  metadataObjects.count == 0 {
			qrCodeFrameView?.frame = CGRect.zero
			messageLabel.text = "No code is detected"
			return
		}
		let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
		//if supportedCodeTypes.contains(metadataObj.type) {
		//if metadataObj.type.rawValue == ".qr" {
			//convertFromAVMetadataObjectObjectType(AVMetadataObject.ObjectType.qr) {
			
			let barCodeObject = avCaptureVideoPreviewLayer.transformedMetadataObject(for: metadataObj)
			qrCodeFrameView?.frame = barCodeObject!.bounds
			if metadataObj.stringValue != nil {
				stringCode = metadataObj.stringValue
				messageLabel.text = stringCode
				
			}
		//}
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
			
			if supportedCodeTypes.contains(metadataObject.type) {
				qrCodeFrame.isHidden = false
				let barCodeObject = avCaptureVideoPreviewLayer.transformedMetadataObject(for: metadataObject)
				qrCodeFrame?.frame = barCodeObject!.bounds
			}
			
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			//if (stringValue != ""){
			if ((stringValue != "")&&(foundCode == false)){
				foundCode = true
				stringCode = stringValue
				messageLabel.text = stringCode
				print("Code: \(stringCode!)")
				//avCaptureSession.stopRunning()
				performSegue(withIdentifier: "segueAddProductToBasket", sender: self)
				qrCodeFrame.isHidden = true
			}
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		foundCode = false
		scanCode()
		qrCodeFrame.isHidden = true
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
