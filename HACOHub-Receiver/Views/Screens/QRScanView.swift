//
//  QRScanView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/20.
//

import SwiftUI
import AVFoundation

struct QRScanView: UIViewControllerRepresentable {
  @Binding var qrCodeValue: String
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

    let overlay = createStylishOverlay(frame: controller.view.bounds)
    controller.view.addSubview(overlay)

    // これで位置がずらせる
//    DispatchQueue.main.async {
//      previewLayer.frame = controller.view.bounds
//      overlayView.frame = controller.view.bounds
//      let updatedScanRect = CGRect(x: controller.view.bounds.midX - 120,
//                                   y: controller.view.bounds.midY - 120,
//                                   width: 240, height: 240)
//      borderView.frame = updatedScanRect
//      // 必要なら maskLayer の path も再設定
//    }

    DispatchQueue.global(qos: .userInitiated).async {
      session.startRunning()
    }

    return controller
  }

  func createStylishOverlay(frame: CGRect) -> UIView {
    let overlayView = UIView(frame: frame)

    // スキャン枠のサイズ
    let scanSize: CGFloat = 376

    // 画面中央に配置
    let scanRect = CGRect(
      x: (frame.width - scanSize) / 2,
      y: (frame.height - scanSize) / 2,
      width: scanSize,
      height: scanSize
    )

    // === RGB指定でカラーを定義 ===
    let borderColor = UIColor(red: 79/255, green: 190/255, blue: 159/255, alpha: 1)

    // === パラメータ ===
    let cornerLength: CGFloat = 64
    let cornerRadius: CGFloat = 8
    let borderLineWidth: CGFloat = 4

    // === 緑の外枠 ===
    let borderLayer = CAShapeLayer()
    borderLayer.path = UIBezierPath(roundedRect: scanRect, cornerRadius: cornerRadius).cgPath
    borderLayer.strokeColor = borderColor.cgColor
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.lineWidth = borderLineWidth
    overlayView.layer.addSublayer(borderLayer)

    enum CornerPosition {
      case topLeft, topRight, bottomLeft, bottomRight
    }

    // === 四隅の白い角線 ===
    func addCorner(x: CGFloat, y: CGFloat, position: CornerPosition) {
      let cornerLayer = CAShapeLayer()
      let path = UIBezierPath()

      // 緑枠線の太さと白線太さ
      let borderLineWidth: CGFloat = 4
      let cornerLineWidth: CGFloat = 8
      let offset = (cornerLineWidth - borderLineWidth) / 2

      switch position {
      case .topLeft:
        let startX = x + offset
        let startY = y + offset
        path.move(to: CGPoint(x: startX + cornerRadius, y: startY))
        path.addLine(to: CGPoint(x: startX + cornerLength, y: startY))
        path.addArc(withCenter: CGPoint(x: startX + cornerRadius, y: startY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: CGFloat(3*Double.pi/2),
                    endAngle: CGFloat(Double.pi),
                    clockwise: false)
        path.addLine(to: CGPoint(x: startX, y: startY + cornerLength))
      case .topRight:
        let startX = x - offset
        let startY = y + offset
        path.move(to: CGPoint(x: startX - cornerRadius, y: startY))
        path.addLine(to: CGPoint(x: startX - cornerLength, y: startY))
        path.addArc(withCenter: CGPoint(x: startX - cornerRadius, y: startY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: CGFloat(3*Double.pi/2),
                    endAngle: 0,
                    clockwise: true)
        path.addLine(to: CGPoint(x: startX, y: startY + cornerLength))
      case .bottomLeft:
        let startX = x + offset
        let startY = y - offset
        path.move(to: CGPoint(x: startX + cornerRadius, y: startY))
        path.addLine(to: CGPoint(x: startX + cornerLength, y: startY))
        path.addArc(withCenter: CGPoint(x: startX + cornerRadius, y: startY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: CGFloat(Double.pi/2),
                    endAngle: CGFloat(Double.pi),
                    clockwise: true)
        path.addLine(to: CGPoint(x: startX, y: startY - cornerLength))
      case .bottomRight:
        let startX = x - offset
        let startY = y - offset
        path.move(to: CGPoint(x: startX - cornerRadius, y: startY))
        path.addLine(to: CGPoint(x: startX - cornerLength, y: startY))
        path.addArc(withCenter: CGPoint(x: startX - cornerRadius, y: startY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: CGFloat(Double.pi/2),
                    endAngle: 0,
                    clockwise: false)
        path.addLine(to: CGPoint(x: startX, y: startY - cornerLength))
      }

      cornerLayer.path = path.cgPath
      cornerLayer.strokeColor = UIColor.white.cgColor
      cornerLayer.fillColor = UIColor.clear.cgColor
      cornerLayer.lineWidth = cornerLineWidth
      overlayView.layer.addSublayer(cornerLayer)
    }

    // 四隅それぞれに描画
    addCorner(x: scanRect.minX, y: scanRect.minY, position: .topLeft)       // 左上
    addCorner(x: scanRect.maxX, y: scanRect.minY, position: .topRight)      // 右上
    addCorner(x: scanRect.minX, y: scanRect.maxY, position: .bottomLeft)    // 左下
    addCorner(x: scanRect.maxX, y: scanRect.maxY, position: .bottomRight)   // 右下

    return overlayView
  }


  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var parent: QRScanView

    init(_ parent: QRScanView) {
      self.parent = parent
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
      if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
         metadata.type == .qr,
         let stringValue = metadata.stringValue {
        parent.qrCodeValue = stringValue
        parent.onQRCodeDetected?(stringValue)
      }
    }
  }
}

