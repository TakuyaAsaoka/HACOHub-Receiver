//
//  RootView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/13.
//

import SwiftUI

struct RootView: View {
  @State private var isActive = false

  var body: some View {
    ZStack {
      if !isActive {
        SplashView {
          isActive = true
        }
        .transition(.opacity)
      } else {
        NavigationStack {
          BLEDeviceControllView()
        }
      }
    }
    .animation(.easeInOut(duration: 0.5), value: isActive)
  }
}

#Preview {
    RootView()
}
