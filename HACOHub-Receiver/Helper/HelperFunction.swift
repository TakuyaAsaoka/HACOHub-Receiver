//
//  HelperFunction.swift
//  HACOHub
//
//  Created by AsaokaTakuya on 2025/10/02.
//

import SwiftUI
import CoreBluetooth

func getRGBColor(_ r: Int, _ g: Int, _ b: Int, _ a: Double = 1) -> Color {
  Color(.sRGB,
    red: Double(r) / 255.0,
    green: Double(g) / 255.0,
    blue: Double(b) / 255.0,
    opacity: a
  )
}

func uuidWithAlias(alias: UInt16) -> CBUUID? {
  guard let baseUUID = Bundle.main.object(forInfoDictionaryKey: "BLEBaseUUID") as? String else {
    print("⚠️ BLEBaseUUID が Info.plist に設定されていません")
    return nil
  }

  let aliasHex = String(format: "%04X", alias)
  var chars = Array(baseUUID)

  for i in 0..<aliasHex.count {
    chars[4 + i] = Array(aliasHex)[i]
  }

  let newUUIDString = String(chars)
  return CBUUID(string: newUUIDString)
}
