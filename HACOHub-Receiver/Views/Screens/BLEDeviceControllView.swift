//
//  BLETestView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/14.
//

import SwiftUI
import CoreBluetooth

struct BLEDeviceControllView: View {
  @StateObject private var bleManager = BLEManager()
  @State private var isShowingQRScan = false
  @State private var connectedPeripheral: CBPeripheral? = nil
  @State private var discoveredPeripherals: [PeripheralInfo] = []
  @State private var qrCodeValue: String = ""

  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 24) {
        HStack {
          Circle()
            .fill(bleManager.isSwitchedOn ? Color.green : Color.red)
            .frame(width: 16, height: 16)
          Text(bleManager.isSwitchedOn ? "Bluetooth: ON" : "Bluetooth: OFF")
            .font(.headline)
        }

        Button {
          bleManager.startScanning()
        } label: {
          Text("スキャン開始")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .opacity(bleManager.isSwitchedOn ? 1.0 : 0.6)
        }
        .disabled(!bleManager.isSwitchedOn)

        Button {
          isShowingQRScan = true
        } label: {
          Label("QRコード読み取り", systemImage: "qrcode.viewfinder")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: .green.opacity(0.3), radius: 4, x: 0, y: 2)
        }
      }
      .padding()

      ScrollView {
        ConnectedDeviceList(
          bleManager: bleManager,
          connectedDevices: bleManager.peripheralInfos.filter { $0.isConnected }
        )

        if !bleManager.peripheralInfos.isEmpty {
          DeviceListView(
            title: "接続可能デバイス",
            peripheralInfos: bleManager.peripheralInfos,
            disabled: false,
            onSelect: { info in
              bleManager.connectPeripheral(peripheral: info.peripheral)
            }
          )
        }

        if !bleManager.weekPeripheralInfos.isEmpty {
          DeviceListView(
            title: "信号が弱く接続できないデバイス",
            peripheralInfos: bleManager.weekPeripheralInfos,
            disabled: true
          )
        }
      }
    }
    .navigationDestination(isPresented: $isShowingQRScan) {
      QRScanView(qrCodeValue: $qrCodeValue, onQRCodeDetected: { value in
        print("QRコード読み取り: \(value)")
        qrCodeValue = value
        // TODO: 不要になったら消す
//        isShowingQRScan = false

        // BLEデバイスを開錠
        var deviceFound = false
        let components = qrCodeValue.split(separator: "-")
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
    }
  }
}

#Preview {
  BLEDeviceControllView()
}
