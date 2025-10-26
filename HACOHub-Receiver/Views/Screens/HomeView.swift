//
//  HomeView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/22.
//

import SwiftUI
import CoreBluetooth

struct HomeView: View {
  @ObservedObject var bleManager: BLEManager
	@Binding var path: NavigationPath

	var body: some View {
		BaseLayout {
			PrimaryRoundedButton(
				iconName: "QRIcon",
				text: "Scan QR Code",
				weight: .bold,
				size: 40,
				vPadding: 26,
				radius: 11,
				action: {
					path.append("scan")
				}
			)
			.frame(width: 800)
			.offset(y: -25)
		}
  }
}
