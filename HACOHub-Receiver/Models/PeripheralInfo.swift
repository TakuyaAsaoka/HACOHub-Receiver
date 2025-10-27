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
	var power: Int
  var isConnected: Bool = false

	init(peripheral: CBPeripheral, rssi: NSNumber) {
    self.id = peripheral.identifier
    self.peripheral = peripheral
    self.rssi = rssi
		self.power = -1
  }
	
	var powerString: String {
			switch power {
			case 0: return "0 dBm"
			case 1: return "+4 dBm"
			case 8: return "+8 dBm"
			default: return "未取得"
			}
	}
}
