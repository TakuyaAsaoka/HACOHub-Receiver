//
//  QRVerifiedView.swift
//  HACOHub-Receiver
//
//  Created by AsaokaTakuya on 2025/10/22.
//

import SwiftUI

struct QRVerifiedView: View {
  var body: some View {
    BaseLayout {
      VStack(spacing: 53) {
        VStack(spacing: 26) {
          Image("VerifiedIcon")
            .resizable()
            .scaledToFit()
            .frame(width: 116, height: 116)

          VStack(spacing: 12) {
            Text.sfProRegular("QR Code Verified!", size: 36)
              .foregroundColor(.white)
            Text.sfProRegular("Locker A-204 is now opend", size: 24)
              .foregroundColor(getRGBColor(153, 161, 175))
          }
        }

        VStack(alignment: .leading, spacing: 18) {
          HStack {
            VStack(alignment: .leading, spacing: 24) {
              Text.sfProRegular("Customer Information", size: 16)
                .foregroundColor(getRGBColor(153, 161, 175))

              VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                  Image("CustomerIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                  VStack(alignment: .leading) {
                    Text.sfProRegular("Customer Name", size: 14)
                      .foregroundColor(getRGBColor(153, 161, 175))
                    Text.sfProRegular("Riki Asano", size: 20)
                      .foregroundColor(.white)
                  }
                }

                HStack(spacing: 16) {
                  Image("LuggageIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                  VStack(alignment: .leading) {
                    Text.sfProRegular("Reservation ID", size: 14)
                      .foregroundColor(getRGBColor(153, 161, 175))
                    Text.sfProRegular("#000006", size: 20)
                      .foregroundColor(.white)
                  }
                }
              }
            }
            .frame(width: 400, alignment: .leading)

            Spacer()

            VStack(alignment: .leading, spacing: 24) {
              Text.sfProRegular("Locker Details", size: 16)
                .foregroundColor(getRGBColor(153, 161, 175))

              VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                  Image("PinGreenIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                  VStack(alignment: .leading) {
                    Text.sfProRegular("Locker Number", size: 14)
                      .foregroundColor(getRGBColor(153, 161, 175))
                    Text.sfProRegular("A-204", size: 20)
                      .foregroundColor(getRGBColor(79, 190, 159))
                  }
                }

                HStack(spacing: 16) {
                  Image("ClockGreenIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                  VStack(alignment: .leading) {
                    Text.sfProRegular("Started Time", size: 14)
                      .foregroundColor(getRGBColor(153, 161, 175))
                    Text.sfProRegular("October 15, 2025", size: 20)
                      .foregroundColor(.white)
                  }
                }
              }
            }
            .frame(width: 400, alignment: .leading)
          }

          Divider()
            .background(getRGBColor(54, 65, 83))

          HStack {
            VStack(alignment: .leading, spacing: 3) {
              Text.sfProRegular("Locker Size", size: 14)
                .foregroundColor(getRGBColor(153, 161, 175))
              Text.sfProRegular("Medium", size: 20)
                .foregroundColor(.white)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
              Text.sfProRegular("Fee", size: 14)
                .foregroundColor(getRGBColor(153, 161, 175))
              Text.sfProRegular("$5", size: 24)
                .foregroundColor(getRGBColor(79, 190, 159))
            }
          }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 32)
        .background(getRGBColor(30, 41, 57))
        .cornerRadius(14)
        .overlay(
          RoundedRectangle(cornerRadius: 14)
            .stroke(getRGBColor(54, 65, 83), lineWidth: 1)
        )
      }
      .frame(width: 896)
    }
  }
}

#Preview {
    QRVerifiedView()
}
