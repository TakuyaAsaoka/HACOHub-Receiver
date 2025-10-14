//
//  CustomFont.swift
//  HACOHub
//
//  Created by AsaokaTakuya on 2025/10/02.
//

import SwiftUI

enum FontNames: String {
  case notoSansJpRegular = "NotoSansJP-Regular"
  case notoSansJpBold = "NotoSansJP-Bold"
}

extension Text {
  func customFont(_ font: FontNames, size: CGFloat) -> Text {
    self.font(.custom(font.rawValue, size: size))
  }

  static func notoRegular(_ text: String, size: CGFloat) -> Text {
    Text(text).customFont(.notoSansJpRegular, size: size)
  }

  static func notoBold(_ text: String, size: CGFloat) -> Text {
    Text(text).customFont(.notoSansJpBold, size: size)
  }

  static func sfProRegular(_ text: String, size: CGFloat) -> Text {
    Text(text).font(.system(size: size, weight: .regular))
  }

  static func sfProMedium(_ text: String, size: CGFloat) -> Text {
    Text(text).font(.system(size: size, weight: .medium))
  }

  static func sfProSemiBold(_ text: String, size: CGFloat) -> Text {
    Text(text).font(.system(size: size, weight: .semibold))
  }

  static func sfProBold(_ text: String, size: CGFloat) -> Text {
    Text(text).font(.system(size: size, weight: .bold))
  }

  static func sfProRegular(_ attributedText: AttributedString) -> Text {
    Text(attributedText)
  }

  static func sfProBold(_ attributedText: AttributedString) -> Text {
    Text(attributedText)
  }
}

enum FontWeight {
  case regular
  case medium
  case semiBold
  case bold
}

#Preview {
  Text.sfProRegular("test", size: 16)
  Text.sfProBold("test", size: 16)
}
