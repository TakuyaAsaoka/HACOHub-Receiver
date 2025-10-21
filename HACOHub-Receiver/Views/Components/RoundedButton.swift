//
//  RoundedButton.swift
//  HACOHub
//
//  Created by AsaokaTakuya on 2025/10/04.
//

import SwiftUI

struct RoundedButtonBase: View {
  let text: String
  let textColor: Color
  let size: CGFloat
  let weight: FontWeight
  let bgColor: Color
  let vPadding: CGFloat
  let lineColor: Color?
  let lineWidth: CGFloat?
  let radius: CGFloat
  let action: () -> Void

  init(
    text: String,
    textColor: Color,
    size: CGFloat,
    weight: FontWeight,
    bgColor: Color,
    vPadding: CGFloat,
    lineColor: Color? = nil,
    lineWidth: CGFloat? = nil,
    radius: CGFloat,
    action: @escaping () -> Void
  ) {
    self.text = text
    self.textColor = textColor
    self.size = size
    self.weight = weight
    self.bgColor = bgColor
    self.vPadding = vPadding
    self.lineColor = lineColor
    self.lineWidth = lineWidth
    self.radius = radius
    self.action = action
  }

  var body: some View {
    Button {
      action()
    } label: {
      Group {
        switch weight {
        case .regular:
          Text.sfProRegular(text, size: size)
        case .medium:
          Text.sfProMedium(text, size: size)
        case .semiBold:
          Text.sfProSemiBold(text, size: size)
        case .bold:
          Text.sfProBold(text, size: size)
        }
      }
      .foregroundColor(textColor)
      .padding(.vertical, vPadding)
      .frame(maxWidth: .infinity)
      .background(bgColor)
      .overlay(
        Group {
          if let lineColor = lineColor, let lineWidth = lineWidth {
            RoundedRectangle(cornerRadius: radius)
              .stroke(lineColor, lineWidth: lineWidth)
          }
        }
      )
      .cornerRadius(radius)
    }
  }
}

struct WhiteRoundedButton: View {
  let text: String
  let textColor: Color
  let weight: FontWeight
  let size: CGFloat
  let vPadding: CGFloat
  let radius: CGFloat
  let action: () -> Void

  var body: some View {
    RoundedButtonBase(
      text: text,
      textColor: textColor,
      size: size,
      weight: weight,
      bgColor: .white,
      vPadding: vPadding,
      lineColor: getRGBColor(66, 74, 83),
      lineWidth: 1,
      radius: radius,
      action: action
    )
  }
}

struct PrimaryRoundedButton: View {
  let text: String
  let weight: FontWeight
  let size: CGFloat
  let vPadding: CGFloat
  let radius: CGFloat
  let action: () -> Void

  var body: some View {
    RoundedButtonBase(
      text: text,
      textColor: .white,
      size: size,
      weight: weight,
      bgColor: getRGBColor(79, 190, 159),
      vPadding: vPadding,
      radius: radius,
      action: action
    )
  }
}

struct GrayRoundedButton: View {
  let text: String
  let weight: FontWeight
  let size: CGFloat
  let vPadding: CGFloat
  let radius: CGFloat
  let action: () -> Void

  var body: some View {
    RoundedButtonBase(
      text: text,
      textColor: .black,
      size: size,
      weight: weight,
      bgColor: getRGBColor(175, 184, 193),
      vPadding: vPadding,
      radius: radius,
      action: action
    )
  }
}

#Preview {
  VStack {
    WhiteRoundedButton(
      text: "test",
      textColor: .black,
      weight: .regular,
      size: 20,
      vPadding: 20,
      radius: 16,
      action: {}
    )
    PrimaryRoundedButton(
      text: "test",
      weight: .bold,
      size: 20,
      vPadding: 20,
      radius: 16,
      action: {}
    )
    GrayRoundedButton(
      text: "test",
      weight: .bold,
      size: 20,
      vPadding: 20,
      radius: 16,
      action: {}
    )
  }
}
