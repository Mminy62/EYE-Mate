//
//  InfoView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/25.
//

import SwiftUI


struct InfoView: View {
    @ObservedObject var coordinator: MapCoordinator = MapCoordinator.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(coordinator.placeInfo[Key.name.rawValue] ?? "이름")")
                .font(.pretendardSemiBold_22)
            Text("\(coordinator.placeInfo[Key.address.rawValue] ?? "주소")")
                .font(.pretendardMedium_14)
            HStack {
                HStack {
                    Image(systemName: "phone")
                    Text("\(coordinator.placeInfo[Key.tel.rawValue] ?? "전화번호")")
                        .font(.pretendardSemiBold_14)
                    Image(systemName: "figure.walk")
                    Text("\(coordinator.placeInfo[Key.distance.rawValue] ?? "거리")")
                        .font(.pretendardSemiBold_14)
                }
                .padding(.horizontal, 10)
                .frame(maxWidth: 220)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.customGreen)
                        .opacity(0.2)
                    )
                Button(action: {
                    showNaverMap(lat: Double(coordinator.placeInfo[Key.lat.rawValue] ?? "0.0")!,lng: Double(coordinator.placeInfo[Key.lng.rawValue] ?? "0.0")!, name: coordinator.placeInfo[Key.name.rawValue] ?? "도착")
                }) {
                    Label("길찾기", systemImage: "location")
                }
                .buttonStyle(MapButtonStyle2(cornerRadiusValue: 20))
                .padding(.leading, 10)
            }
            .padding(.leading, -10)
        }
    }
    
    func showNaverMap(lat: Double, lng: Double, name: String) {
        // 자동차 길찾기 + 도착지 좌표 + 앱 번들 id
        guard let url = URL(string: "nmap://route/public?dlat=\(lat)&dlng=\(lng)&dname=\(name)&appname=Seonghyeon.EYE-Mate") else { return }
        // 네이버지도 앱스토어 url
        guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") else { return }

        // 네이버지도 앱이 존재 한다면,
        if UIApplication.shared.canOpenURL(url) {
            // 길찾기 open
            UIApplication.shared.open(url)
        } else { // 네이버지도 앱이 없다면,
            // 네이버지도 앱 설치 앱스토어로 이동
            UIApplication.shared.open(appStoreURL)
        }
    }
}

#Preview {
    InfoView(coordinator: MapCoordinator())
}
