//
//  DistanceConditionView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/26.
//

import SwiftUI

struct DistanceConditionView: View {
    @StateObject var viewModel = DistanceConditionViewModel()
    var title: String
    var type: TestType
    @Environment(\.dismiss) var dismiss
    
    init(title: String, type: TestType) {
        self.title = title
        self.type = type
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                DistanceFaceAndDevice(model: viewModel)
                BackgroundView()
                DistanceView(viewModel: viewModel, title: title, type: type)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(title)
                            .font(.pretendardBold_24)
                    }
                    ToolbarItem {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image("close")
                        })
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

//MARK: - 설명 Text와 거리 Text View
private struct DistanceView: View {
    @ObservedObject var viewModel: DistanceConditionViewModel
    var title: String
    var type: TestType
    
    var body: some View {
        VStack {
            Spacer()
                .frame(maxHeight: 100)
            
            Text("\(title)를 위해서 휴대폰을 사용자와\n40cm ~ 50cm 간격을 유지해주세요!")
                .font(.pretendardMedium_20)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            HStack{
                Spacer()
                Text("현재거리 ")
                    .font(.pretendardRegular_30)
                Text("\(viewModel.distance)")
                    .font(.pretendardRegular_40)
                    .foregroundColor(viewModel.canStart ? .customGreen : .customRed)
                Text("CM")
                    .font(.pretendardRegular_30)
                Spacer()
            }
            
            Spacer()
            
            VStack {
                Text(viewModel.informationText)
                    .font(.pretendardMedium_20)
                    .foregroundColor(viewModel.canStart ? .customGreen : .customRed)
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                CustomBtn(title: "테스트 시작하기", background: viewModel.canStart ? .customGreen : .btnGray, fontStyle: .pretendardMedium_18, action: {
                    switch type {
                    case .vision:
                        viewModel.isActiveVisionTest = true
                    case .astigmatism:
                        viewModel.isActiveAstigmatismTest = true
                    case .sight:
                        viewModel.isActiveSightTest = true
                    }
                })
                    .frame(maxHeight: 75)
                    .disabled(!viewModel.canStart)
            }
            .navigationDestination(isPresented: $viewModel.isActiveVisionTest) {
                VisionTestView()
            }
            .navigationDestination(isPresented: $viewModel.isActiveAstigmatismTest) {
                AstigmatismTestView()
            }
            .navigationDestination(isPresented: $viewModel.isActiveSightTest) {
                SightTestView()
            }
        }
    }
}

//MARK: - Background 뷰
private struct BackgroundView: View {
    var body: some View {
        GeometryReader { g in
            Rectangle()
                .ignoresSafeArea()
                .frame(width: g.size.width, height: g.size.height)
                .foregroundColor(.white)
        }
    }
}


#Preview {
    DistanceConditionView(title: "검사", type: .vision)
}
