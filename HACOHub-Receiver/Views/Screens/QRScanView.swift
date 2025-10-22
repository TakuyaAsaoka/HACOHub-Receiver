//
//  QRScanView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/22.
//

import SwiftUI
import CoreBluetooth

struct QRScanView: View {
  @ObservedObject var bleManager: BLEManager
  @State var isShowingQRVerifiedView: Bool = false

  var body: some View {
    BaseLayout {
      ZStack {
        VStack(spacing: 32) {
          GeometryReader { geometry in
            QRScanner(onQRCodeDetected: { value in
              print("QRコード読み取り: \(value)")

              // BLEデバイスを開錠
              var deviceFound = false
              let components = value.split(separator: "-")
              let deviceName = String(components[0])
              let password = String(components[1])

              print("検出されたデバイス名: \(deviceName)")
              print("検出されたパスワード: \(password)")

              for info in bleManager.peripheralInfos {
                if info.peripheral.name == deviceName {
                  deviceFound = true
                  if password == "123456" {
                    isShowingQRVerifiedView = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                      bleManager.unlockDevice(info.peripheral)
                    }
                  } else {
                    print("パスワードが違います")
                  }
                }
              }

              if !deviceFound {
                print("⚠️ 接続中のデバイスに操作対象のデバイスが見つかりませんでした: \(deviceName)")
              }
            })
            .frame(width: 888, height: 500)
            .overlay(
                ZStack {
                    // 枠
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(getRGBColor(54, 65, 83), lineWidth: 4)
                    
                    // グリッド線
                    Path { path in
                        let width = 888.0
                        let height = 500.0
                        
                        // 縦線
                        for i in 1..<3 {
                            let x = width / 3 * CGFloat(i)
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: height))
                        }
                        
                        // 横線
                        for i in 1..<3 {
                            let y = height / 3 * CGFloat(i)
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: width, y: y))
                        }
                    }
                    .stroke(getRGBColor(74, 85, 101), lineWidth: 1)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
          }

          VStack(spacing: 12) {
            Text.sfProRegular("Scan QR Code", size: 36)
              .foregroundColor(.white)

            Text.sfProRegular("Postion the QR code within the frame", size: 24)
              .foregroundColor(getRGBColor(153, 161, 175))

            LoadingDotsView(color: getRGBColor(79, 190, 159))
          }
        }

        // TODO: マジックナンバーなくしたい
        QRFrameView()
          .offset(y: -70)
      }
      .padding(.top, 30)
      .navigationDestination(isPresented: $isShowingQRVerifiedView) {
        QRVerifiedView()
          .navigationBarBackButtonHidden(true)
          .toolbar(.hidden)
      }
    }
  }
}
