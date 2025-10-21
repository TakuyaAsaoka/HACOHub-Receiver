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

  var body: some View {
    BaseLayout {
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
                bleManager.unlockDevice(info.peripheral)
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
        .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // ← 中央に固定
      }
    }
  }
}
