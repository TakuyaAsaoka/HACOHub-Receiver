//
//  QRFrameView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/22.
//

import SwiftUI

struct QRFrameView: View {
  let size: CGFloat = 384
  let cornerRadius: CGFloat = 16
  let cornerLength: CGFloat = 64
  let borderLineWidth: CGFloat = 4
  let whiteLineWidth: CGFloat = 8
  @State private var scanPosition: CGFloat = 0

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: cornerRadius)
        .stroke(getRGBColor(79, 190, 159), lineWidth: borderLineWidth)
        .frame(width: size, height: size)

      RoundedCornerOverlay(
        size: size,
        radius: cornerRadius,
        cornerLength: cornerLength,
        lineWidth: whiteLineWidth,
        borderLineWidth: borderLineWidth
      )
    }

    ZStack {
      // 尾（線の後ろ）
      LinearGradient(
        gradient: Gradient(stops: [
          .init(color: getRGBColor(79, 190, 159).opacity(0.0), location: 0.0),
          .init(color: getRGBColor(79, 190, 159).opacity(0.2), location: 0.3),
          .init(color: getRGBColor(79, 190, 159).opacity(0.4), location: 0.6),
          .init(color: getRGBColor(79, 190, 159).opacity(0.6), location: 1.0)
        ]),
        startPoint: .top,   // 上から下に尾
        endPoint: .bottom
      )
      .frame(width: size - borderLineWidth*2, height: 64)
      .offset(y: scanPosition - size/2 - 64/2) // 尾が線の上に来るように調整

      // メインの線（先端）
      Rectangle()
        .fill(getRGBColor(79, 190, 159))
        .frame(width: size - borderLineWidth*2, height: 4)
        .offset(y: scanPosition - size/2)
    }
    .onAppear {
      withAnimation(
        Animation.linear(duration: 2)
          .repeatForever(autoreverses: false)
      ) {
        scanPosition = size
      }
    }
    .frame(width: size, height: size)
    .clipped()
  }
}

struct RoundedCornerOverlay: View {
  let size: CGFloat
  let radius: CGFloat
  let cornerLength: CGFloat
  let lineWidth: CGFloat
  let borderLineWidth: CGFloat

  var body: some View {
    ZStack {
      // 左上
      cornerPath(rotation: .degrees(0))
      // 右上
      cornerPath(rotation: .degrees(90))
      // 右下
      cornerPath(rotation: .degrees(180))
      // 左下
      cornerPath(rotation: .degrees(270))
    }
    .frame(width: size, height: size)
  }

  @ViewBuilder
  func cornerPath(rotation: Angle) -> some View {
    RoundedCornerShape(radius: radius, length: cornerLength)
      .stroke(Color.white, lineWidth: lineWidth)
      .rotationEffect(rotation)
      .offset(
        x: (rotation == .degrees(90) || rotation == .degrees(180) ? (borderLineWidth/2 - lineWidth/2) : (lineWidth/2 - borderLineWidth/2)),
        y: (rotation == .degrees(180) || rotation == .degrees(270) ? (borderLineWidth/2 - lineWidth/2) : (lineWidth/2 - borderLineWidth/2))

      )
  }
}

struct RoundedCornerShape: Shape {
  let radius: CGFloat
  let length: CGFloat

  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: 0, y: length))
    path.addLine(to: CGPoint(x: 0, y: radius))
    path.addQuadCurve(to: CGPoint(x: radius, y: 0), control: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: length, y: 0))
    return path
  }
}


#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    QRFrameView()
  }
}
