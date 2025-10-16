//
//  SectionView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/16.
//

import SwiftUI
import CoreBluetooth

struct SectionView: View {
  let title: String
  let peripheralInfos: [PeripheralInfo]
  var disabled: Bool = false
  var onSelect: ((PeripheralInfo) -> Void)? = nil

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.headline)
        .padding(.horizontal)
      ScrollView {
        ForEach(Array(peripheralInfos.enumerated()), id: \.element.id) { index, info in
          Button {
            onSelect?(info)
          } label: {
            HStack {
              Text("#\(index + 1)")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(width: 30, alignment: .leading)

              VStack(alignment: .leading, spacing: 4) {
                Text(info.peripheral.name ?? "名前なしデバイス")
                  .font(.body)
                  .bold()
                Text("RSSI: \(info.rssi) dBm")
                  .font(.caption)
                  .foregroundColor(Int(truncating: info.rssi) >= -50 ? .green : .red)
                Text("UUID:\n\(info.peripheral.identifier.uuidString)")
                  .font(.caption2)
                  .foregroundColor(.gray)
                  .multilineTextAlignment(.leading)
              }

              Spacer()

              if !disabled {
                Image(systemName: "link.circle.fill")
                  .foregroundColor(.blue)
              } else {
                Image(systemName: "wifi.slash")
                  .foregroundColor(.gray)
              }
            }
            .padding()
            .background(info.isConnected ? Color.green.opacity(0.2) : (disabled ? Color.gray.opacity(0.1) : Color.white))
            .cornerRadius(12)
            .shadow(radius: 1)
            .padding(.horizontal)
            .animation(.easeInOut(duration: 0.3), value: info.isConnected)
          }
          .disabled(disabled)
        }
      }
    }
    .padding(.vertical, 4)
  }
}
