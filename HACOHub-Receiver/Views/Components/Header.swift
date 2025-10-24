//
//  Header.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/22.
//

import SwiftUI

struct Header: View {
  var body: some View {
//      getRGBColor(28, 30, 47)

      HStack(spacing: 16) {
        Image("HACOHubGreenIcon")
          .frame(width: 50, height: 50)

        VStack(alignment: .leading, spacing: 0) {
          Text.sfProRegular("HACOHub Locker System", size: 24)
            .foregroundColor(.white)

          HStack(spacing: 0) {
            Image("PinGrayIcon")
              .frame(width: 20, height: 20)
            Text.sfProRegular("Sweet Auburn Music Fest Entrance")
            .foregroundColor(getRGBColor(175, 184, 193))
          }
        }

        Spacer()
      }
			.padding(.vertical, 26)
      .padding(.leading, 32)
			.background(getRGBColor(28, 30, 47))
			.shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
			.shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 4)
  }
}

#Preview {
    Header()
			.ignoresSafeArea()
}
