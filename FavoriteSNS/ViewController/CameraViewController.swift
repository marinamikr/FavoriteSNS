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
    
    @IBOutlet weak var previewView: UIView!
    var userDefaults:UserDefaults = UserDefaults.standard
    let defaults = UserDefaults.standard
    // セッションのインスタンス生成
    let captureSession = AVCaptureSession()
    var videoLayer: AVCaptureVideoPreviewLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "友達追加"
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Mamelon", size: 20)]
        // 入力（背面カメラ）
        let videoDevice = AVCaptureDevice.default(for: .video)
        let videoInput = try! AVCaptureDeviceInput.init(device: videoDevice!)
        captureSession.addInput(videoInput)
        // 出力（メタデータ）
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        // QRコードを検出した際のデリゲート設定
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // QRコードの認識を設定
        metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        // プレビュー表示
        videoLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoLayer?.frame = previewView.bounds
        videoLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewView.layer.addSublayer(videoLayer!)
        // セッションの開始
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // 複数のメタデータを検出できる
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            // QRコードのデータかどうかの確認
            if metadata.type == AVMetadataObject.ObjectType.qr {
                // 検出位置を取得
                let barCode = videoLayer?.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
                if metadata.stringValue != nil {
                    // 検出データを取得
                    let id = metadata.stringValue
                    self.performSegue(withIdentifier: "toChooseGroupeViewController", sender: id) // sender で指定したものを渡せる
                }
                self.captureSession.stopRunning()
                
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
