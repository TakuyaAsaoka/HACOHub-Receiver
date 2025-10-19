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
  }
}

#Preview {
  BLETestView()
}
