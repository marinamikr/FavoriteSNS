//
//  CameraViewController.swift
//  FavoriteSNS
//
//  Created by 原田摩利奈 on 2019/05/14.
//  Copyright © 2019 原田摩利奈. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    

    var qrCodeFrameView: UIView!
    var userDefaults:UserDefaults = UserDefaults.standard
    let defaults = UserDefaults.standard
    // セッションのインスタンス生成
    let captureSession = AVCaptureSession()
    var videoLayer: AVCaptureVideoPreviewLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "友達追加"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Mamelon", size: 20)]
       
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            self.captureSession.startRunning()
            
            qrCodeFrameView = UIView()
            // スキャンしたQRコードを緑の枠で囲む
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
        } catch {
            print(error)
            return
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                let id = metadataObj.stringValue
                 self.captureSession.stopRunning()
                self.performSegue(withIdentifier: "toChooseGroupeViewController", sender: id) // sender で指定したものを渡せる
            }
            
           
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChooseGroupeViewController" {
            let chooseGroupeViewController = segue.destination as! ChooseGroupeViewController
            chooseGroupeViewController.uuid = sender as! String
        }
    }
}
