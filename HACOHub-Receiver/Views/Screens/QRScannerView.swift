//
//  QRScannerView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/14.
//

import SwiftUI
import AVKit
import VisionKit

@MainActor
struct QRScannerView: View {
  @Environment(\.dismiss) private var dismiss
  @ObservedObject var bleManager = BLEManager.shared
  @State private var scannedText: String = ""

  var body: some View {
    VStack {
      if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
        DataScannerViewRepresentable(
          recognizedText: $scannedText,
          onScan: handleScan
        )
        .ignoresSafeArea()
      } else {
        Text("このデバイスではカメラ利用不可")
      }
    }
  }

  private func handleScan(_ value: String) {
    scannedText = value
    print("📷 QRコード検出: \(value)")

    // QRコードの内容に応じて通信先を切り替え
    if value.contains("DEVICE_A") {
      bleManager.connectToDevice(named: "DeviceA")
    } else if value.contains("DEVICE_B") {
      bleManager.connectToDevice(named: "DeviceB")
    }

    dismiss()
  }
}

struct DataScannerViewRepresentable: UIViewControllerRepresentable {
  @Binding var recognizedText: String
  var onScan: (String) -> Void

  func makeUIViewController(context: Context) -> DataScannerViewController {
    let controller = DataScannerViewController(
      recognizedDataTypes: [.barcode(symbologies: [.QR])],
      qualityLevel: .balanced,
      recognizesMultipleItems: false,
      isHighFrameRateTrackingEnabled: false,
      isHighlightingEnabled: true
    )
    controller.delegate = context.coordinator
    try? controller.startScanning()
    return controller
  }

  func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }

  final class Coordinator: NSObject, DataScannerViewControllerDelegate {
    let parent: DataScannerViewRepresentable
    init(parent: DataScannerViewRepresentable) { self.parent = parent }

    func dataScanner(_ dataScanner: DataScannerViewController,
                     didAdd addedItems: [RecognizedItem],
                     allItems: [RecognizedItem]) {
      for item in addedItems {
        if case let .barcode(barcode) = item, let value = barcode.payloadStringValue {
          parent.recognizedText = value
          parent.onScan(value)
        }
      }
    }
  }
}


#Preview {
    QRScannerView()
}
