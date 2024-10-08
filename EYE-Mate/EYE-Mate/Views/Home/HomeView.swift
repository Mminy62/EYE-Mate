//
//  Home.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/22/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var viewModel = HomeViewModel.shared
    @ObservedObject private var profileViewModel = ProfileViewModel.shared
    @State var eyeSenseOnBoardingViewModel = EyeSenseOnBoardingViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HomeViewTextView()
                    EyeSenseOnboardingView(onboardingViewModel: eyeSenseOnBoardingViewModel)
                        .padding(.horizontal, 20)
                    HomeViewCellListView()
                    Spacer()
                }
            }
            .padding(.bottom, 72)
        }
    }
}

//MARK: - 상단 텍스트 뷰
private struct HomeViewTextView: View {
    @ObservedObject private var viewModel = HomeViewModel.shared
    @AppStorage("Login") var loggedIn: Bool = false
    @AppStorage("user_UID") private var userUID: String = ""
    
    @AppStorage("user_left") private var userLeft: String = ""
    @AppStorage("user_right") private var userRight: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("오늘도 눈 건강 챙기셨나요? 👀")
                .font(.pretendardRegular_22)
                
            //TODO: - 유저 좌, 우 시력 가져와서 보여주기
            if userLeft != "" && userRight != "" {
                Text("# 최근 시력 좌 \(userLeft) 우 \(userRight)")
                    .multilineTextAlignment(.center)
                    .font(.pretendardBold_16)
            }
            else {
                Text("# 최근 시력 기록이 없어요!")
                    .multilineTextAlignment(.center)
                    .font(.pretendardBold_16)
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//MARK: - 셀 리스트 뷰
private struct HomeViewCellListView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var tabManager: TabManager

    @ObservedObject private var viewModel = HomeViewModel.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("눈 관리")
                .font(.pretendardSemiBold_20)
            HStack(spacing: 10) {
                Button(action: {
                    router.navigate(to: .record)
                }, label: {
                    HomeViewCellView(item: .init(img: Image("Record"), title: "눈 기록", subTitle: "꼼꼼한 기록 관리"), isArrowButton: false)
                        .foregroundColor(.black)
                })

                Button(action: {
                    tabManager.selection = .movement
                }, label: {
                    HomeViewCellView(item: .init(img: Image("Movement"), title: "눈 운동", subTitle: "눈 피로감 줄이기"), isArrowButton: false)
                        .foregroundColor(.black)
                })
            }
            Text("눈 검사")
                .font(.pretendardSemiBold_20)
            Button(action: {
                router.navigate(to: .checkVision)
            }, label: {
                HomeViewCellView(item: .init(img: Image("VisionTest1"), title: "시력 검사", subTitle: "나의 시력을 확인해보세요."))
                    .foregroundColor(.black)
            })
            Button(action: {
                router.navigate(to: .checkColor)
            }, label: {
                HomeViewCellView(item: .init(img: Image("VisionTest2"), title: "색각 검사", subTitle: "색상을 선명하게 구별할 수 있나요?"))
                    .foregroundColor(.black)
            })
            Button(action: {
                router.navigate(to: .checkAstigmatism)
            }, label: {
                HomeViewCellView(item: .init(img: Image("VisionTest3"), title: "난시 검사", subTitle: "난시의 징후가 있는지 검사하세요."))
                    .foregroundColor(.black)
            })
            Button(action: {
                router.navigate(to: .checkSight)
            }, label: {
                HomeViewCellView(item: .init(img: Image("VisionTest4"), title: "시야 검사", subTitle: "시야의 문제 여부를 파악해보세요."))
                    .foregroundColor(.black)
            })
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    HomeView(eyeSenseOnBoardingViewModel: EyeSenseOnBoardingViewModel())
}
