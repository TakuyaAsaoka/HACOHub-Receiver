//
//  BLETestView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/14.
//

import SwiftUI
import CoreBluetooth

struct BLETestView: View {
  @StateObject private var bleManager = BLEManager()

  var body: some View {
    VStack(spacing: 16) {
      // Bluetooth ON/OFF 状態表示
      HStack {
        Circle()
          .fill(bleManager.isSwitchedOn ? Color.green : Color.red)
          .frame(width: 16, height: 16)
        Text(bleManager.isSwitchedOn ? "Bluetooth: ON" : "Bluetooth: OFF")
          .font(.headline)
      }
      .padding()

      // スキャンボタン
      Button(action: {
        bleManager.startScanning()
      }) {
        Text("スキャン開始")
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(12)
      }
      .disabled(!bleManager.isSwitchedOn)

      // 検出デバイス一覧
      List(bleManager.peripherals, id: \.identifier) { peripheral in
        Button(action: {
          bleManager.connectPeripheral(peripheral: peripheral)
        }) {
          VStack(alignment: .leading) {
            Text(peripheral.name ?? "名前なしデバイス")
              .font(.headline)
            Text("UUID: \(peripheral.identifier.uuidString)")
              .font(.caption)
              .foregroundColor(.gray)
          }
        }

        Spacer()
      }
      .padding()
      .navigationTitle("BLEテストビュー")
    }
  }
}

#Preview {
  BLETestView()
}
