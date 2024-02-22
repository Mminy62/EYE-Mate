//
//  RecordBox.swift
//  EYE-Mate
//
//  Created by seongjun on 1/30/24.
//

import SwiftUI

struct RecordBox: View {
    let type: TestType
    @ObservedObject private var recordViewModel = RecordViewModel.shared
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                HStack {
                    Text(type.rawValue)
                        .font(.pretendardBold_20)
                    Spacer()
                    Button {
                        switch type {
                        case .vision:
                            recordViewModel.isPresentedVisionRecordListView = true
                        case .colorVision:
                            recordViewModel.isPresentedColorVisionRecordListView = true
                        case .astigmatism:
                            recordViewModel.isPresentedAstigmatismRecordListView = true
                        case .eyesight:
                            recordViewModel.isPresentedEyesightRecordListView = true
                        }
                    } label: {
                        Text("모두보기")
                            .font(.pretendardRegular_14)
                            .foregroundStyle(.black)
                    }
                }
                HorizontalDivider(color: Color.lightGray, height: 3)
                VStack(alignment: .leading, spacing: 0) {
                    
                }
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
        }
    }
}

#Preview {
    RecordBox(type: .vision)
}
