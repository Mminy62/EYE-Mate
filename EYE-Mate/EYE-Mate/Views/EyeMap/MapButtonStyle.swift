//
//  mapButtonStyle.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/25.
//

import SwiftUI

struct MapButtonStyle: ButtonStyle {
    let cornerRadiusValue: Int
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.pretendardSemiBold_12)
            .foregroundStyle(configuration.isPressed ? Color.customGreen : Color.white)
            .frame(width: 90, height: 30)
            .background(configuration.isPressed ? .white : .customGreen)
            .clipShape(RoundedRectangle(cornerRadius: CGFloat(cornerRadiusValue)))
            .overlay(
                RoundedRectangle(cornerRadius: CGFloat(cornerRadiusValue))
                        .stroke(Color.customGreen, lineWidth: 1)
                )
            
    }
}

struct MapButtonStyle2: ButtonStyle {
    let cornerRadiusValue: Int
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.pretendardSemiBold_14)
            .foregroundStyle(configuration.isPressed ? Color.customGreen : Color.white)
            .frame(width: 80, height: 40)
            .background(configuration.isPressed ? .white : .customGreen)
            .clipShape(RoundedRectangle(cornerRadius: CGFloat(cornerRadiusValue)))
            .overlay(
                RoundedRectangle(cornerRadius: CGFloat(cornerRadiusValue))
                        .stroke(Color.customGreen, lineWidth: 1)
                )
            
    }
}
