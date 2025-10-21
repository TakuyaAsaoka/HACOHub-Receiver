//
//  BaseLayout.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/22.
//

import SwiftUI

struct BaseLayout: View {
  var body: some View {
    ZStack {
      getRGBColor(19, 20, 38)

      VStack(spacing: 0) {
        Header()

        Image("HACOHubBackgroundLogo")
          .resizable()
          .scaledToFit()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .ignoresSafeArea()
  }
} 

#Preview {
    BaseLayout()
}
