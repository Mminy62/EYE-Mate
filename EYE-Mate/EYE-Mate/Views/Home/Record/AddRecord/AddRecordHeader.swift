//
//  AddRecordHeader.swift
//  EYE-Mate
//
//  Created by seongjun on 2/1/24.
//

import SwiftUI

struct AddRecordHeader: View {
    @EnvironmentObject var router: Router

    let onPressResetButton: () -> Void

    private func goBack() {
        router.navigateBack()
    }

    var body: some View {
        ZStack {
            HStack {
                Button {
                    goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.system(size: 32))
                        .padding(.bottom, 2)
                }
                Spacer()
                Button {
                    onPressResetButton()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(Color.customGreen)
                            .font(.system(size: 15))
                            .padding(.bottom, 2)
                        Text("초기화")
                            .font(.pretendardSemiBold_14)
                            .foregroundStyle(Color.customGreen)

                    }
                    .padding(8)
                    .frame(height: 30)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.customGreen, lineWidth: 1)
                    }
                }
            }.padding(.horizontal, 12)
            HStack {
                Spacer()
                Text("기록 추가하기")
                    .font(.pretendardSemiBold_18)
                Spacer()
            }
        }
    }
}

#Preview {
    AddRecordHeader(onPressResetButton: {})
}
