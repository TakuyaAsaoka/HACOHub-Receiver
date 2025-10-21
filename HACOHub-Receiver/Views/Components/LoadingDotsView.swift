//
//  LoadingDotsView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/22.
//

import SwiftUI

struct LoadingDotsView: View {
  @State private var activeDot = 0
  let dotCount = 3
  let animationDuration = 0.4
  let color: Color

  var body: some View {
    HStack(spacing: 8) {
      ForEach(0..<dotCount, id: \.self) { index in
        Circle()
          .fill(index == activeDot ? color : color.opacity(0.3))
          .frame(width: 12, height: 12)
          .animation(.easeInOut(duration: animationDuration), value: activeDot)
      }
    }
    .onAppear {
      // タイマーでアクティブなドットを順番に切り替える
      Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
        withAnimation {
          activeDot = (activeDot + 1) % dotCount
        }
      }
    }
  }
}

#Preview {
  LoadingDotsView(color: getRGBColor(79, 190, 159))
}
