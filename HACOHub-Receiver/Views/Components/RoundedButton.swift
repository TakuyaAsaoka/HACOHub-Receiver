//
//  RoundedButton.swift
//  HACOHub
//
//  Created by AsaokaTakuya on 2025/10/04.
//

import SwiftUI

struct RoundedButtonBase: View {
	let iconName: String?
  let text: String
  let textColor: Color
	let weight: FontWeight
  let size: CGFloat
  let bgColor: Color
  let vPadding: CGFloat
  let lineColor: Color?
  let lineWidth: CGFloat?
  let radius: CGFloat
  let action: () -> Void

  init(
    iconName: String? = nil,
    text: String,
    textColor: Color,
		weight: FontWeight,
    size: CGFloat,
    bgColor: Color,
    vPadding: CGFloat,
    lineColor: Color? = nil,
    lineWidth: CGFloat? = nil,
    radius: CGFloat,
    action: @escaping () -> Void
  ) {
		self.iconName = iconName
    self.text = text
    self.textColor = textColor
		self.weight = weight
    self.size = size
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
				HStack(spacing: 16) {
					Image(iconName ?? "")
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
	let iconName: String?
  let text: String
  let textColor: Color
  let weight: FontWeight
  let size: CGFloat
  let vPadding: CGFloat
  let radius: CGFloat
  let action: () -> Void
	
	init(
		iconName: String? = nil,
		text: String,
		textColor: Color,
		weight: FontWeight,
		size: CGFloat,
		vPadding: CGFloat,
		radius: CGFloat,
		action: @escaping () -> Void
	) {
		self.iconName = iconName
		self.text = text
		self.textColor = textColor
		self.weight = weight
		self.size = size
		self.vPadding = vPadding
		self.radius = radius
		self.action = action
	}

  var body: some View {
    RoundedButtonBase(
			iconName: iconName,
      text: text,
      textColor: textColor,
			weight: weight,
      size: size,
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
	let iconName: String?
  let text: String
  let weight: FontWeight
  let size: CGFloat
  let vPadding: CGFloat
  let radius: CGFloat
  let action: () -> Void
	
	init(
		iconName: String? = nil,
		text: String,
		weight: FontWeight,
		size: CGFloat,
		vPadding: CGFloat,
		radius: CGFloat,
		action: @escaping () -> Void
	) {
		self.iconName = iconName
		self.text = text
		self.weight = weight
		self.size = size
		self.vPadding = vPadding
		self.radius = radius
		self.action = action
	}

  var body: some View {
    RoundedButtonBase(
			iconName: iconName,
      text: text,
      textColor: .white,
			weight: weight,
      size: size,
      bgColor: getRGBColor(79, 190, 159),
      vPadding: vPadding,
      radius: radius,
      action: action
    )
  }
}

struct GrayRoundedButton: View {
	let iconName: String?
  let text: String
  let weight: FontWeight
  let size: CGFloat
  let vPadding: CGFloat
  let radius: CGFloat
  let action: () -> Void
	
	init(
		iconName: String? = nil,
		text: String,
		weight: FontWeight,
		size: CGFloat,
		vPadding: CGFloat,
		radius: CGFloat,
		action: @escaping () -> Void
	) {
		self.iconName = iconName
		self.text = text
		self.size = size
		self.weight = weight
		self.vPadding = vPadding
		self.radius = radius
		self.action = action
	}

  var body: some View {
    RoundedButtonBase(
			iconName: iconName,
      text: text,
      textColor: .black,
			weight: weight,
      size: size,
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
