//
//  ConnectedDeviceList.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/20.
//

import SwiftUI
import CoreBluetooth

struct ConnectedDeviceList: View {
  @ObservedObject var bleManager: BLEManager
  let connectedDevices: [PeripheralInfo]

  @State private var isEditingName = false
  @State private var newName = ""

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      if !connectedDevices.isEmpty {
        Text("🟢 接続中のデバイス")
          .font(.title3)
          .bold()
          .padding(.horizontal)

        ForEach(connectedDevices, id: \.peripheral.identifier) { info in
          DeviceRowView(info: info, bleManager: bleManager)
        }
      } else {
        Text("⚪️ 接続中のデバイスはありません")
          .font(.caption)
          .foregroundColor(.gray)
      }
    }
    .padding()
  }
}

struct DeviceRowView: View {
  let info: PeripheralInfo
  @ObservedObject var bleManager: BLEManager
  @State private var isEditingName = false
  @State private var newName = ""

  var body: some View {
    HStack(spacing: 0) {
      HStack {
        Text(info.peripheral.name ?? "名前なし")
          .font(.headline)

        Button(action: {
          newName = info.peripheral.name ?? ""
          isEditingName = true
        }) {
          Image(systemName: "pencil")
            .foregroundColor(.gray)
            .padding(.leading, 6)
        }
        .buttonStyle(.plain)
      }

      Spacer()

      HStack(spacing: 16) {
        Button(action: {
          bleManager.unlockDevice(info.peripheral)
        }) {
          Label("開錠", systemImage: "lock.open.fill")
            .font(.headline)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
        }

        Button(action: {
          bleManager.disconnectPeripheral(peripheral: info.peripheral)
        }) {
          Label("切断", systemImage: "wifi.slash")
            .font(.headline)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color.gray.opacity(0.2))
            .foregroundColor(.red)
            .cornerRadius(12)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.6), lineWidth: 1)
            )
        }

        Button(action: {
          bleManager.registerDevice(info.peripheral)
        }) {
          Label("登録", systemImage: "checkmark.seal.fill")
            .font(.headline)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: .green.opacity(0.3), radius: 4, x: 0, y: 2)
        }
      }
    }
    .padding()
    .background(Color.green.opacity(0.15))
    .cornerRadius(12)
    .alert("デバイス名を変更", isPresented: $isEditingName) {
      TextField("新しい名前を入力", text: $newName)
      Button("保存") {
        bleManager.renameDevice(info.peripheral, newName: newName)
      }
      Button("キャンセル", role: .cancel) { }
    } message: {
      Text("デバイスの表示名を変更します。")
    }
  }
}
