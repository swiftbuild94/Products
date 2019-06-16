//
//  PreviewView.swift
//  Products
//
//  Created by Patricio Benavente on 16/06/19.
//  Copyright © 2019 Patricio Benavente. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewView: UIView {
	override class var layerClass: AnyClass {
		return AVCaptureVideoPreviewLayer.self
	}
	
	/// Convenience wrapper to get layer as its statically known type.
	var videoPreviewLayer: AVCaptureVideoPreviewLayer {
		return layer as! AVCaptureVideoPreviewLayer
	}
}

