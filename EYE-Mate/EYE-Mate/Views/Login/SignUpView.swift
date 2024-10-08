//
//  LoginView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/26.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @ObservedObject var loginViewModel = LoginViewModel.shared
    @Binding var signUpFlag: Bool
    @FocusState private var keyFocused: Bool
    @State var openOTPView: Bool = false
    @State var countryCode : String = "+82"
    @State var mobPhoneNumber = ""
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 100)
            Text("EYE-Mate")
                .font(.pretendardBold_28)
                .foregroundStyle(Color.customGreen)
                .padding(.bottom, 40)
            
            VStack(spacing: 20) {
                Text("회원가입")
                    .font(.pretendardBold_20)
                    .foregroundStyle(Color.customGreen)
                PhoneNumberView(openOTPView: $openOTPView, signUpFlag: $signUpFlag, keyFocused: $keyFocused, countryCode: $countryCode, mobPhoneNumber: $mobPhoneNumber)
                
                // MARK: - OTP View
                if openOTPView {
                    OTPVerificationView(signUpFlag: $signUpFlag, keyFocused: $keyFocused, mobileNumber: "\(countryCode)\(mobPhoneNumber)")
                }
                
            }
            
            VStack(alignment: .leading) {
                HStack{
                    VStack(alignment: .leading, spacing: 5) {
                        Text("이미 EYE-Mate 회원이신가요?")
                            .font(.pretendardMedium_16)
                        Button {
                            signUpFlag = false
                        } label: {
                            Text("로그인")
                                .foregroundStyle(Color.customGreen)
                                .underline()
                                .font(.pretendardSemiBold_20)
                        }
                    }
                    Spacer()
                }
            }
            .padding(50)
        }
        .background(Color.white)
        .onTapGesture {
            keyFocused = false
        }
    }
}

#Preview {
    SignUpView(loginViewModel: LoginViewModel(), signUpFlag: .constant(true))
}



