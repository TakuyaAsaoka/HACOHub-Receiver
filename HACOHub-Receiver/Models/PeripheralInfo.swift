//
//  PeripheralInfo.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/16.
//

import SwiftUI
import CoreBluetooth

struct PeripheralInfo: Identifiable {
  let id: UUID
  let peripheral: CBPeripheral
  let rssi: NSNumber
  let number: Int?

  init(peripheral: CBPeripheral, rssi: NSNumber, number: Int? = nil) {
    self.id = peripheral.identifier
    self.peripheral = peripheral
    self.rssi = rssi
    self.number = number
  }
}
