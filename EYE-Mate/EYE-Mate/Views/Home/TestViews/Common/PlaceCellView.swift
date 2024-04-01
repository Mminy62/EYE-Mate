//
//  PlaceCellView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/06.
//

import SwiftUI

//MARK: - 내 주변 병원 리스트 셀
struct PlaceCellView: View {
    var place: PlaceList
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.customGreen, lineWidth: 3)
            .cornerRadius(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .shadow(radius: 5, x: 2, y: 2)
            )
            .overlay(
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(place.placeName)
                            .font(.pretendardSemiBold_16)
                        HStack {
                            Text("주소")
                                .font(.pretendardSemiBold_12)
                            Text("\(place.addressName)")
                                .font(.pretendardRegular_12)
                        }
                        HStack(spacing: 5) {
                            Image(systemName: "phone")
                                .foregroundStyle(Color.customGreen)
                            Text(place.phone)
                                .font(.pretendardRegular_12)
                            Image(systemName: "figure.walk")
                                .foregroundStyle(Color.customGreen)
                            Text(place.distance.convertMeter())
                                .font(.pretendardBold_12)
                        }
                    }
                    Spacer()
                    Button(action: {
                        print(place.placeName)
                        showNaverMap(lat: Double(place.y) ?? 0.0, lng: Double(place.x) ?? 0.0, name: place.placeName)
                    }, label: {
                        Label("길찾기", systemImage: "location")
                    })
                    .buttonStyle(MapButtonStyle(cornerRadiusValue: 10))
                }
                .padding(15)
            )
            .frame(height: 80)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
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
