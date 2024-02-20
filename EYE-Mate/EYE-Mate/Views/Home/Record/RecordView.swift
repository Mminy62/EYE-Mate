//
//  Record.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct RecordView: View {
    @ObservedObject private var viewModel = HomeViewModel.shared

    private func goBack() {
        viewModel.isPresentedRecordView = false
    }
    
    var body: some View {
            VStack(spacing: 0) {
                CustomNavigationTitle(title: "기록")
                
                Spacer()
                
                HorizontalDivider(color: Color.customGreen, height: 4)
                ScrollView {
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(maxWidth: 320)
                                .frame(height: 32)
                                .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 6, x: 2, y: 2)
                                .foregroundStyle(Color.white)
                                .overlay{
                                    Text("23년 11월 21일(월) ~ 24년 01월 17일(수)")
                                        .font(.pretendardRegular_16)
                                }
                            
                            NavigationLink(destination: AddRecordView()) {
                                RoundedRectangle(cornerRadius: 16)
                                    .frame(maxWidth: 40)
                                    .frame(height: 32)
                                    .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 6, x: 2, y: 2)
                                    .foregroundStyle(Color.white)
                                    .overlay{
                                        Image(systemName: "plus")
                                            .foregroundStyle(Color.customGreen)
                                            .font(.system(size: 20))
                                    }
                            }
                        }
                        RecordBox(type: .vision)
                        // TODO: Data 없을 때 분기
                        VisionChart()
//                      EmptyVisionChart()
                        RecordBox(type: .colorVision)
                        RecordBox(type: .astigmatism)
                        RecordBox(type: .eyesight)
                    }.padding(16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.lightGray)
                .scrollIndicators(ScrollIndicatorVisibility.hidden)
            }
            .navigationBarBackButtonHidden()
        }
}

#Preview {
    RecordView()
}
