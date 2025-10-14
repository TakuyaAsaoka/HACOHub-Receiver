//
//  SplashView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/13.
//

import SwiftUI

struct SplashView: View {
  let onFinished: () -> Void

  var body: some View {
    ZStack {
      Color(getRGBColor(236, 249, 243))
        .ignoresSafeArea()

      VStack(alignment: .trailing) {
        Text.sfProBold("HACOHub", size: 64)
          .foregroundColor(getRGBColor(79, 190, 159))
        Text.sfProRegular("@TOYOTA AUTO BODY", size: 13)
          .foregroundColor(getRGBColor(102, 102, 102))
      }
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        withAnimation {
          onFinished()
        }
      }
    }
  }
}

#Preview {
  SplashView {}
}
