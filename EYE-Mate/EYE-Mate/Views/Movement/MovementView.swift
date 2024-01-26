//
//  Movement.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

struct HorizontalDivider: View {
    let color: Color
    let height: CGFloat

    init(color: Color, height: CGFloat = 0.5) {
        self.color = color
        self.height = height
    }

    var body: some View {
        color
            .frame(height: height)
    }
}

struct StartMovementRow: View {
    @Binding var showToast: Bool

    @State var isNavigateEightLottieView : Bool = false

    var body: some View {
        HStack {
            Image("eight-movement")
                .frame(width: 72, height: 72)
            VStack(alignment: .leading, spacing: 12){
                Text("8자 운동")
                    .font(.pretendardSemiBold_20)
                Text("점을 따라 눈을 움직이세요!")
                    .font(.pretendardSemiBold_12)
            }.padding(.leading, 12)
            Spacer()
            Button {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
                isNavigateEightLottieView = true
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }.navigationDestination(isPresented: $isNavigateEightLottieView) {
                EightLottieView(showToast: $showToast)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            .background(Color.customGreen)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .frame(width: 44, height: 44)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.25), radius: 4, x: 2, y: 2)
    }
}

struct MovementView: View {
    @State private var tempData: [Int] = [1, 2, 3]
    @State private var toast: Toast? = nil
    @State private var showToast = false

    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 12){
                        Text("EYE-Mate")
                            .font(.pretendardSemiBold_22)
                        Text("눈 운동")
                            .font(.pretendardSemiBold_32)
                    }
                    Spacer()
                    Circle()
                        .foregroundColor(Color.blue)
                        .frame(width: 50, height: 50)
                }
                .frame(height: 112)
                .padding(.horizontal, 24)

                HorizontalDivider(color: Color.customGreen, height: 4)
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("어디로 가야 하오 님!")
                            .font(.pretendardSemiBold_22)
                        Text("오늘도 눈 건강 챙기셨나요? 👀")
                            .font(.pretendardRegular_22)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    VStack(alignment: .leading) {
                        Text("#오늘의 눈 운동")
                            .font(.pretendardRegular_16)
                        Text("0회")
                            .font(.pretendardSemiBold_20)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    ForEach(0..<3) { index in
                        StartMovementRow(showToast: $showToast)
                    }
                    .padding(.horizontal, -10)
                    .padding(.vertical, 0)
                    .listStyle(PlainListStyle())
                    .scrollDisabled(true)
                    .scrollContentBackground(.hidden)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("추후 다른 운동 업데이트 예정입니다.")
                            .font(.pretendardMedium_18)
                            .foregroundColor(Color.warningGray)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)
                .background(Color.textFieldGray)
            }.toastView(toast: $toast)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if showToast {
                            toast = Toast()
                            showToast.toggle()
                        }
                    }
                }
        }
    }
}

#Preview {
    MovementView()
}
