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
  @State private var connectedPeripheral: CBPeripheral? = nil
  @State private var discoveredPeripherals: [PeripheralInfo] = []

  var body: some View {
    VStack(spacing: 16) {
      HStack {
        Circle()
          .fill(bleManager.isSwitchedOn ? Color.green : Color.red)
          .frame(width: 16, height: 16)
        Text(bleManager.isSwitchedOn ? "Bluetooth: ON" : "Bluetooth: OFF")
          .font(.headline)
      }
      .padding()

      if let connected = connectedPeripheral {
        VStack(alignment: .leading, spacing: 4) {
          Text("🟢 接続中のデバイス")
            .font(.title3)
            .bold()
          Text("名前: \(connected.name ?? "名前なし")")
          Text("UUID: \(connected.identifier.uuidString)")
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
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
      }
      .disabled(!bleManager.isSwitchedOn)

      if !bleManager.peripheralInfos.isEmpty {
        SectionView(
          title: "接続可能デバイス",
          peripheralInfos: bleManager.peripheralInfos,
          disabled: false,
          onSelect: { info in
            bleManager.connectPeripheral(peripheral: info.peripheral)
          }
        )
      }

      if !bleManager.weekPeripheralInfos.isEmpty {
        SectionView(
          title: "信号が弱く接続できないデバイス",
          peripheralInfos: bleManager.weekPeripheralInfos,
          disabled: true
        )
      }
    }
  }
}

#Preview {
  BLETestView()
}
