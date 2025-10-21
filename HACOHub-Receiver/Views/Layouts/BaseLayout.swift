//
//  BaseLayout.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/22.
//

import SwiftUI

struct BaseLayout<Content: View>: View {
  let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    ZStack {
      getRGBColor(19, 20, 38)
        .ignoresSafeArea()

      VStack(spacing: 0) {
        Header()

        ZStack {
          Image("HACOHubBackgroundLogo")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

          content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
      }
    }
  }
}

#Preview {
  BaseLayout {
    Text.sfProBold("Hello, World", size: 50)
      .foregroundColor(.white)
  }
}
