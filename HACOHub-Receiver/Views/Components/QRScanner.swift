//
//  QRScanView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/20.
//

import SwiftUI
import AVFoundation

struct QRScanner: UIViewControllerRepresentable {
  var onQRCodeDetected: ((String) -> Void)? = nil

  func makeUIViewController(context: Context) -> UIViewController {
    let controller = UIViewController()
    let session = AVCaptureSession()

    // 前面カメラを取得
    guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
          let input = try? AVCaptureDeviceInput(device: device) else {
      print("前面カメラが使用できません")
      return controller
    }

    session.addInput(input)

    let output = AVCaptureMetadataOutput()
    session.addOutput(output)

    output.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
    output.metadataObjectTypes = [.qr]

    // プレビュー用 Layer
    let previewLayer = AVCaptureVideoPreviewLayer(session: session)
    previewLayer.frame = controller.view.bounds
    previewLayer.videoGravity = .resizeAspect

    controller.view.layer.addSublayer(previewLayer)

    context.coordinator.previewLayer = previewLayer
    context.coordinator.session = session

    if let connection = previewLayer.connection {
      // 自動鏡像調整をオフ
      if connection.responds(to: #selector(setter: AVCaptureConnection.automaticallyAdjustsVideoMirroring)) {
        connection.automaticallyAdjustsVideoMirroring = false
      }

      // 鏡像を手動設定
      if connection.isVideoMirroringSupported {
        connection.isVideoMirrored = true
      }

      // 回転角度
      if connection.isVideoRotationAngleSupported(0) {
        // ここを0/90/270に変えるとカメラの向きが変わる
        // 0はカメラが右辺に来る時に正しく映る
        // 180はカメラが左辺に来る時に正しく映る
        connection.videoRotationAngle = 0
      }
    }

    let overlay = UIView(frame: controller.view.bounds)
    controller.view.addSubview(overlay)

    DispatchQueue.global(qos: .userInitiated).async {
      session.startRunning()
    }

    return controller
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    if let previewLayer = context.coordinator.previewLayer {
      previewLayer.frame = uiViewController.view.bounds
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var parent: QRScanner

    var previewLayer: AVCaptureVideoPreviewLayer?
    var session: AVCaptureSession?

    init(_ parent: QRScanner) {
      self.parent = parent
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
      if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
         metadata.type == .qr,
         let stringValue = metadata.stringValue {
        parent.onQRCodeDetected?(stringValue)
      }
    }
  }
}

