//
//  AstigmatismTest.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI

struct AstigmatismView: View {
    @ObservedObject var viewModel = AstigmatismViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            CustomNavigationTitle(title: "난시 검사",
                                  isDisplayLeftButton: true)
            .navigationDestination(isPresented: $profileViewModel.isPresentedProfileView) {
                ProfileView()
            }
            
            ExplanationTextView(str: "간단한 테스트를 통해\n난시 여부를 확인해보세요!")
            
            Spacer()
            
            TestOnboardingView(image:[Image("Component1"), Image("Component2"), Image("Component5")], thirdTitle: "원의 중심으로 초점을 두고\n선의 변화를 확인하세요!")
                .padding(.horizontal, 10)
            
            Spacer()
            
            CustomButton(title: "테스트 시작하기",
                      background: .customGreen,
                      fontStyle: .pretendardBold_16,
                      action: {
                viewModel.isPresentedTestView.toggle()
            })
            .navigationDestination(isPresented: $viewModel.isPresentedTestView, destination: {
                DistanceConditionView(title: "난시 검사", type: .astigmatism)
            })
            .frame(maxHeight: 75)
            
            Spacer()
            
            WarningText()
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    AstigmatismView()
}
