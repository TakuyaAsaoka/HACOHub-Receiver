//
//  BLEManager.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/14.
//

import CoreBluetooth
import SwiftUI
import Combine

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
  @Published var isSwitchedOn = false
  @Published var weekPeripheralInfos = [PeripheralInfo]()
  @Published var peripheralInfos = [PeripheralInfo]()
  var centralManager: CBCentralManager!
  var bleBaseUUID: CBUUID?
  var data: Data = Data()

  override init() {
    super.init()

    #if targetEnvironment(simulator)
    print("⚠️ Running on simulator — BLE not initialized")
    #else
    centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    if let bleBaseUUIDString = Bundle.main.object(forInfoDictionaryKey: "BLEBaseUUID") as? String {
      bleBaseUUID = CBUUID(string: bleBaseUUIDString)
    }
    #endif
  }

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state == .poweredOn {
      isSwitchedOn = true
    } else {
      isSwitchedOn = false
    }
  }

  // TODO: 会場だと違う機器に繋いでしまうかも。ある程度指定しておきたい。
  func startScanning() {
    print("BLEスキャンを開始")

    let connectedDevices = peripheralInfos.filter { $0.isConnected }
    for info in connectedDevices {
      centralManager.cancelPeripheralConnection(info.peripheral)
    }

    weekPeripheralInfos.removeAll()
    peripheralInfos.removeAll()
    
    centralManager.scanForPeripherals(withServices: nil, options: nil)
  }

  // スキャン中、BLEデバイスを見つけるたびに呼ばれる関数
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    let deviceName = peripheral.name ?? "名前なしデバイス"
    let uuidString = peripheral.identifier.uuidString
    let peripheral = PeripheralInfo(peripheral: peripheral, rssi: RSSI)

    if RSSI.intValue >= -50 {
      if !peripheralInfos.contains(where: { $0.id == peripheral.peripheral.identifier }) {
        print("BLEデバイスNo: \(peripheralInfos.count)")
        print("接続可能: \(deviceName), UUID: \(uuidString), RSSI: \(RSSI)")
        peripheralInfos.append(peripheral)
      }
    } else {
      if !weekPeripheralInfos.contains(where: { $0.id == peripheral.peripheral.identifier }) {
        print("BLEデバイスNo: \(weekPeripheralInfos.count)")
        print("接続不可（信号弱）: \(deviceName), UUID: \(uuidString), RSSI: \(RSSI)")
        weekPeripheralInfos.append(peripheral)
      }
    }
  }

  func connectPeripheral(peripheral: CBPeripheral) {
    print("Connect peripheral: \(peripheral.name ?? "名前なし")")
    centralManager.stopScan()
    centralManager.connect(peripheral, options: nil)
  }

  func disconnectPeripheral(peripheral: CBPeripheral) {
    print("Disconnecting from: \(peripheral.name ?? "名前なし")")
    centralManager.cancelPeripheralConnection(peripheral)
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("✅ 接続成功: \(peripheral.name ?? "名前なし"), UUID: \(peripheral.identifier.uuidString)")
    if let index = peripheralInfos.firstIndex(where: { $0.peripheral.identifier == peripheral.identifier }) {
      peripheralInfos[index].isConnected = true
    }
    // 意外とこれがないとサービスの登録がうまくいかなかった
    peripheral.delegate = self
    peripheral.discoverServices(nil)
  }

  // 接続失敗時に呼ばれる
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    print("❌ 接続失敗: \(peripheral.name ?? "名前なし"), UUID: \(peripheral.identifier.uuidString), error: \(error?.localizedDescription ?? "なし")")
    if let index = peripheralInfos.firstIndex(where: { $0.peripheral.identifier == peripheral.identifier }) {
      peripheralInfos[index].isConnected = false
    }
  }

  // Service探索完了後に呼ばれる
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    print("enter didDiscoverService")
    guard let services = peripheral.services else { return }

    for service in services { peripheral.discoverCharacteristics(nil, for: service) }
  }

  // Characteristic探索完了後に呼ばれる
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    print("enter didDiscoevrCharacteristics")
    guard let characteristics = service.characteristics else { return }
    for characteristic in characteristics { print("キャラ発見: \(characteristic)") }
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if let error = error {
      print("読み取りエラー: \(error.localizedDescription)")
      return
    }

    guard let data = characteristic.value else { return }

    // データを文字列に変換（UTF-8の場合）
    if let stringValue = String(data: data, encoding: .utf8) {
      print("読み取り成功: \(stringValue)")
    } else {
      print("読み取り成功、バイナリ: \(data)")
    }
  }

  // 切断時に呼ばれる処理
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    if let error = error {
      print("❌ 切断（エラーあり）: \(peripheral.name ?? "Unknown"), UUID: \(peripheral.identifier.uuidString), error: \(error.localizedDescription)")
    } else {
      print("⚠️ 切断（エラーなし）: \(peripheral.name ?? "Unknown"), UUID: \(peripheral.identifier.uuidString)")
    }

    // 状態更新
    if let index = peripheralInfos.firstIndex(where: { $0.peripheral.identifier == peripheral.identifier }) {
      peripheralInfos[index].isConnected = false
    }
    if let index = weekPeripheralInfos.firstIndex(where: { $0.peripheral.identifier == peripheral.identifier }) {
      weekPeripheralInfos[index].isConnected = false
    }
  }

  // 書き込み処理後に呼ばれる
  func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
    if let error = error {
      print("書き込み失敗: \(error.localizedDescription)")
    } else {
      print("書き込み成功: \(characteristic.uuid)")
    }
  }

  private func findCharacteristic(peripheral: CBPeripheral, serviceUUID: CBUUID, characteristicUUID: CBUUID) -> CBCharacteristic? {
    guard let service = peripheral.services?.first(where: { $0.uuid == serviceUUID }),
          let characteristics = service.characteristics else { return nil }

    return characteristics.first(where: { $0.uuid == characteristicUUID })
  }

  func unlockDevice(_ peripheral: CBPeripheral) {
    print("🔓 開錠操作実行: \(peripheral.name ?? "Unknown")")
    guard let serviceUUID: CBUUID = uuidWithAlias(alias: 0x0200) else { return }
    guard let characteristicUUID: CBUUID = uuidWithAlias(alias: 0x0201) else { return }
    guard let characteristic = findCharacteristic(
      peripheral: peripheral,
      serviceUUID: serviceUUID,
      characteristicUUID: characteristicUUID
    ) else {
      print("❌ 書き込み先キャラなし")
      return
    }

    let opeCode: [UInt8] = [0x12, 0x34, 0x56] // パスワードが123456の意味
    let afterAction: UInt8 = 0x00
    let autolockTime: [UInt8] = [0x00, 0x00]

    var data = Data()
    data.append(contentsOf: opeCode)
    data.append(afterAction)
    data.append(contentsOf: autolockTime)

    peripheral.writeValue(data, for: characteristic, type: .withResponse)
  }

  func renameDevice(_ peripheral: CBPeripheral, newName: String) {
    print("✏️ 名前変更: \(newName)")
    guard let serviceUUID: CBUUID = uuidWithAlias(alias: 0x0100) else { return }
    guard let characteristicUUID: CBUUID = uuidWithAlias(alias: 0x0101) else { return }
    guard let characteristic = findCharacteristic(
      peripheral: peripheral,
      serviceUUID: serviceUUID,
      characteristicUUID: characteristicUUID)
    else {
      print("❌ 書き込みキャラなし")
      return
    }

    var data = newName.data(using: .utf8) ?? Data()
    if data.count < 8 {
      data.append(contentsOf: Array(repeating: 0x00, count: 8 - data.count))
    } else if data.count > 8 {
      data = data.subdata(in: 0..<8)
    }

    peripheral.writeValue(data, for: characteristic, type: .withResponse)
  }

  func registerDevice(_ peripheral: CBPeripheral) {
    print("🔍 登録: \(peripheral.name ?? "Unknown")")
    guard let serviceUUID: CBUUID = uuidWithAlias(alias: 0x0100) else { return }
    guard let characteristicUUID: CBUUID = uuidWithAlias(alias: 0x106) else { return }
    guard let characteristic = findCharacteristic(
      peripheral: peripheral,
      serviceUUID: serviceUUID,
      characteristicUUID: characteristicUUID)
    else {
      print("❌ 書き込みキャラなし")
      return
    }

    // Registerに書き込む値
    let value: UInt32 = 0x6B59AC

    // UInt32を3バイトに分解してDataに変換
    let bytes: [UInt8] = [
      UInt8((value >> 16) & 0xFF),
      UInt8((value >> 8) & 0xFF),
      UInt8(value & 0xFF)
    ]

    let data = Data(bytes)
    peripheral.writeValue(data, for: characteristic, type: .withResponse)
  }
}

