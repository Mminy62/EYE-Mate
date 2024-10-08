//
//  CustomNavigationTitle.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI
import Kingfisher

struct CustomNavigationTitle: View {
    var title: String = ""
    var isDisplayLeftButton: Bool = false

    @EnvironmentObject var router: Router
    @EnvironmentObject var tabManager: TabManager
    
    @ObservedObject var profileViewModel = ProfileViewModel.shared

    @AppStorage("user_name") private var userName: String = "EYE-Mate"

    var body: some View {
        HStack(alignment: .bottom) {
            if isDisplayLeftButton {
                Button(action: { router.navigateBack() },
                       label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 33))
                        .foregroundColor(.black)
                })
            }
            VStack(alignment: .leading) {
                if title == "" {
                    Text("EYE-Mate")
                        .font(.pretendardSemiBold_22)
                }
                Spacer()
                    .frame(height: 10)
                if title == "" {
                    switch tabManager.selection {
                    case .home:
                        HStack(spacing: 5) {
                            Text(userName)
                                .font(.pretendardBold_30)
                                .foregroundColor(.customGreen)

                            Text("님!")
                                .font(.pretendardBold_30)
                        }
                    case .movement:
                        Text("눈 운동")
                            .font(.pretendardBold_30)
                    case .community:
                        Text("게시판")
                            .font(.pretendardBold_30)
                    case .eyeMap:
                        Text("내 주변")
                            .font(.pretendardBold_30)
                    }
                } else {
                    Text(title)
                        .font(.pretendardBold_30)
                }

            }

            Spacer()


            if title == "" {
                Button(action: {
                    router.navigate(to: .profile)
                }, label: {
                    profileViewModel.profileImage
                        .ProfileImageModifier()
                        .frame(width: 50, height: 50)
                })
            }

        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

#Preview {
    CustomNavigationTitle()
}
