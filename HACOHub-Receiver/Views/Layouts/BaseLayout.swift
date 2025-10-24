//
//  BaseLayout.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/22.
//

import SwiftUI

struct BaseLayout<Content: View>: View {
  let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

	var body: some View {
		VStack(spacing: 0) {
			Header() // Headerの高さはここで確保
			
			GeometryReader { geometry in
				ZStack {
					getRGBColor(19, 20, 38)
					
					if let uiImage = UIImage(named: "HACOHubBackgroundLogo") {
						let height: CGFloat = geometry.size.height
						let imageRatio = uiImage.size.width / uiImage.size.height
						let width = height * imageRatio
						
						Image("HACOHubBackgroundLogo")
							.resizable()
							.frame(width: width, height: height)
							.offset(x: -50)
						
						content
							.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
							.padding(.top, 56)
							.padding(.bottom, 26)
					}
				}
				.frame(width: geometry.size.width, height: geometry.size.height)
			}
		}
		.ignoresSafeArea()
	}
}

#Preview {
  BaseLayout {
    Text.sfProBold("Hello, World", size: 50)
      .foregroundColor(.white)
  }
}
