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
      // 残像
      LinearGradient(
        gradient: Gradient(stops: [
          .init(color: getRGBColor(79, 190, 159).opacity(0.0), location: 0.0),
          .init(color: getRGBColor(79, 190, 159).opacity(0.2), location: 0.3),
          .init(color: getRGBColor(79, 190, 159).opacity(0.4), location: 0.6),
          .init(color: getRGBColor(79, 190, 159).opacity(0.6), location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
      .frame(width: size, height: 64)
      .offset(y: scanPosition - size/2 - 64/2) // 尾が線の上に来るように調整

      // メインの線
      Rectangle()
        .fill(getRGBColor(79, 190, 159))
        .frame(width: size, height: 4)
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

    Circle()
      .fill(getRGBColor(30, 41, 57, 0.8))
      .frame(width: 112, height: 112)

    SmallCornerOverlay(size: 28, cornerLength: 10, lineWidth: 5)
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

struct SmallCornerOverlay: View {
  let size: CGFloat
  let cornerLength: CGFloat
  let lineWidth: CGFloat
  let cornerRadius: CGFloat = 4
  var body: some View {
    ZStack {
      corner(rotation: .degrees(0))
        .offset(x: -size/2 + cornerLength/2, y: -size/2 + cornerLength/2) // 左上

      corner(rotation: .degrees(90))
        .offset(x: size/2 - cornerLength/2, y: -size/2 + cornerLength/2)  // 右上

      corner(rotation: .degrees(180))
        .offset(x: size/2 - cornerLength/2, y: size/2 - cornerLength/2)   // 右下

      corner(rotation: .degrees(270))
        .offset(x: -size/2 + cornerLength/2, y: size/2 - cornerLength/2)  // 左下
    }
    .frame(width: size, height: size)
  }

  func corner(rotation: Angle) -> some View {
    Path { path in
      // 水平線を右方向に描く
      path.move(to: CGPoint(x: cornerRadius, y: 0))
      path.addLine(to: CGPoint(x: cornerLength, y: 0))
      // 角の円弧（きれいな丸角）
      path.addArc(
        center: CGPoint(x: cornerRadius, y: cornerRadius),
        radius: cornerRadius,
        startAngle: .degrees(270),
        endAngle: .degrees(180),
        clockwise: true
      )
      // 垂直線を下方向に描く
      path.addLine(to: CGPoint(x: 0, y: cornerLength))
    }
    .stroke(getRGBColor(79, 190, 159), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
    .rotationEffect(rotation)
  }
}

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    QRFrameView()
  }
}
