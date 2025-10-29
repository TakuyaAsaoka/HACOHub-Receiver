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
	@State var isTony: Bool = true

	var body: some View {
		BaseLayout {
			VStack {
				PrimaryRoundedButton(
					iconName: "QRIcon",
					text: "Scan QR Code",
					weight: .bold,
					size: 40,
					vPadding: 26,
					radius: 11,
					action: {
						path.append("scan")
						isTony.toggle()
					}
				)
				.frame(width: 800)
				.offset(y: -25)
				
				Image(isTony ? "TonyString" :"StarkString")
					.resizable()
					.scaledToFit()
					.frame(maxWidth: .infinity)
			}
			.padding(.horizontal, 20)
		}
  }
}
