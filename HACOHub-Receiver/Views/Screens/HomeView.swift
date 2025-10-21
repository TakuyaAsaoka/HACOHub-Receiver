//
//  HomeView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/22.
//

import SwiftUI
import CoreBluetooth

struct HomeView: View {
  @ObservedObject var bleManager: BLEManager
  @State var isShowingQRScanView: Bool = false

  var body: some View {
    BaseLayout {
      Button {
        print("")
      } label: {
        PrimaryRoundedButton(
          text: "Scan QR Code",
          weight: .bold,
          size: 40,
          vPadding: 26,
          radius: 11,
          action: {
            isShowingQRScanView = true
          }
        )
        .frame(width: 800)
      }
    }
    .navigationDestination(isPresented: $isShowingQRScanView) {
      QRScanView(bleManager: bleManager)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
    }
  }
}
