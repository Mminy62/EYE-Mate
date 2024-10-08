//
//  ColorTestView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/31.
//

import SwiftUI

struct ColorTestView: View {
    @StateObject var viewModel = ColorTestViewModel()
    @State var isTestComplete = false

    var body: some View {

        if !isTestComplete {
            ColorTest(viewModel: viewModel, isTestComplete: $isTestComplete)
        } else {
            ColorTestResultView(viewModel: viewModel)
                .onAppear {
                    MapCoordinator.shared.checkIfLocationServiceIsEnabled()
                }
        }
    }
}

//MARK: - 테스트 화면
private struct ColorTest: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: ColorTestViewModel
    @FocusState private var isFocused: Bool

    @State private var answer = ""
    @State private var testPercent = 0.0
    @Binding var isTestComplete: Bool

    var body: some View {
        ZStack {
            Color.white

            VStack {
                Spacer()
                    .frame(height: 5)

                HStack {
                    Text("색각 검사")
                        .frame(maxWidth: .infinity)
                        .font(.pretendardBold_24)
                        .overlay(alignment: .trailing) {
                            Button(action: {
                                router.navigateBack()
                            }, label: {
                                Image("close")
                            })
                            .padding(.trailing)
                        }
                }

                ProgressView(value: testPercent, total: 12)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.customGreen))

                if !viewModel.isTestStarted {
                    Spacer()

                    Text("보이는 각 판의 번호를 입력하세요.\n다음 화면부터 테스트가 시작됩니다!")
                        .multilineTextAlignment(.center)
                        .font(.pretendardMedium_20)
                } else {

                    Spacer()

                    Text("보이는 각 판의 번호를 입력하세요.")
                        .multilineTextAlignment(.center)
                        .font(.pretendardMedium_20)
                }

                Spacer()

                viewModel.testColorSet[viewModel.index]
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Spacer()

                if viewModel.isTestStarted {
                    Text("아무것도 보이지 않으면 다음버튼을 클릭하세요.")
                        .font(.pretendardMedium_18)
                }
                TextField("숫자를 입력하세요.", text: $answer)
                    .focused($isFocused)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                    .onChange(of: answer) { newValue in
                        if newValue.count > 2 {
                            answer.removeLast()
                        }
                    }

                HStack {
                    if viewModel.index >= 2 {
                        CustomButton(title: "이전",
                                     background: .customGreen,
                                     fontStyle: .pretendardBold_16,
                                     action: {
                            viewModel.userAnswer[viewModel.index] = answer
                            withAnimation {
                                testPercent -= 1
                            }
                            viewModel.index -= 1
                            answer = viewModel.userAnswer[viewModel.index]
                        }
                        )
                        .frame(maxHeight: 75)
                    }

                    CustomButton(title: viewModel.index != 12 ? "다음" : "제출하기",
                                 background: .customGreen,
                                 fontStyle: .pretendardBold_16,
                                 action: {
                        viewModel.userAnswer[viewModel.index] = answer
                        viewModel.isTestStarted = true
                        withAnimation {
                            if viewModel.index != 12 {
                                testPercent += 1
                            }
                        }

                        viewModel.index += 1
                        if viewModel.index >= viewModel.testColorSet.count {
                            viewModel.index = 0
                            viewModel.updateResult()
                            isFocused = false
                            isTestComplete.toggle()
                        }
                        answer = viewModel.userAnswer[viewModel.index]
                    }
                    )
                    .frame(maxHeight: 75)
                }
            } //VStack
            .navigationBarBackButtonHidden()
        } //ZStack
        .onTapGesture {
            isFocused = false
        }
    }
}

//MARK: - 테스트 결과 화면
private struct ColorTestResultView: View {
    @ObservedObject var viewModel: ColorTestViewModel
    @ObservedObject var coordinator: MapCoordinator = MapCoordinator.shared
    @ObservedObject var loginViewModel = LoginViewModel.shared

    @EnvironmentObject var router: Router
    @EnvironmentObject var tabManager: TabManager

    @AppStorage("Login") var loggedIn: Bool = false
    @AppStorage("user_UID") private var userUID: String = ""

    @State var showAlert = false

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 1)
                
                TestResultTitleView(type: .colorVision)

                ScrollView(showsIndicators: false) {
                    ColorTestResultTextView(viewModel: viewModel)

                    Spacer()

                    ColorTestResultGraph(viewModel: viewModel)

                    Spacer()

                    WarningText()

                    Spacer()

                    if coordinator.total != 0 {
                        Text("내 주변에 총 \(coordinator.total >= 5 ? "5개 이상의" : "\(coordinator.total)개의") 장소가 있어요!")
                            .font(.pretendardBold_20)

                            .foregroundColor(.customGreen)
                        Color.customGreen
                            .frame(height: 3)
                            .padding(.horizontal, 10)
                        VStack {
                            ForEach(0..<coordinator.total, id: \.self) { index in
                                PlaceCellView(place: coordinator.resultInfo[index])
                            }

                            Button(action: {
                                //TODO: - 로그인 상태라면 저장 후 이동, 아니면 Alert창
                                if loggedIn {
                                    viewModel.saveResult(userUID)
                                    tabManager.selection = .eyeMap
                                    router.navigateToRoot()
                                } else {
                                    showAlert = true
                                }
                            }, label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                    .foregroundColor(.customGreen)
                                    .frame(height: 80)
                                    .padding(10)
                                    .overlay(
                                        Text("모든 장소를 확인하려면 내 주변 화면에서 확인하세요!")
                                            .multilineTextAlignment(.center)
                                            .font(.pretendardLight_16)
                                            .foregroundColor(.tabGray)
                                    )
                            })
                        }
                    } else {
                        Text("내 주변에 안과나 안경점이 없어요!")
                            .font(.pretendardBold_24)
                            .foregroundColor(.customGreen)

                        Spacer()

                        Text("내 주변 화면에서\n다른 안과나 안경점을 찾아보세요!")
                            .multilineTextAlignment(.center)
                            .font(.pretendardSemiBold_20)

                        Spacer()
                    }
                }


                CustomButton(title: "돌아가기",
                             background: .customGreen,
                             fontStyle: .pretendardBold_16,
                             action: {
                    if loggedIn {
                        //TODO: - 사용자 모델 추가 시 저장하고 navigateToRoot() 하기!
                        viewModel.saveResult(userUID)
                        router.navigateToRoot()
                    } else {
                        //TODO: - Alert 창 띄워주고 선택
                        showAlert = true
                    }
                } )
                .frame(maxHeight: 75)
            }
            .navigationBarBackButtonHidden()

            TestAlertView(showAlert: $showAlert)
        }
        .fullScreenCover(isPresented: $loginViewModel.showFullScreenCover, content: {
            LoginView(isAlertView: true)
        })
        .animation(.easeInOut(duration: 0.1), value: showAlert)
    }
}

//MARK: - 테스트 결과 텍스트
private struct ColorTestResultTextView: View {
    @ObservedObject var viewModel: ColorTestViewModel

    //TODO: - 사용자 계정 나오면 ViewModel에 추가 후 수정필요!
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Color.customGreen
                .frame(width: 3, height: 20)
            
            Text("색채 지각:")
                .font(.pretendardSemiBold_24)
            
            Text(viewModel.resultMessage)
                .font(.pretendardSemiBold_32)
                .foregroundColor(viewModel.resultMessageColor)
                .padding(.leading, 15)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 30)
    }
}

//MARK: - 테스트 결과 표
private struct ColorTestResultGraph: View {
    @ObservedObject var viewModel: ColorTestViewModel

    var body: some View {
        VStack {
            Text(viewModel.result)
                .font(.pretendardMedium_22)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("순서")
                        .font(.pretendardRegular_26)
                    Spacer()
                    Text("정답")
                        .font(.pretendardRegular_26)
                    Spacer()
                    Text("제출")
                        .font(.pretendardRegular_26)
                    Spacer()
                } // HStack
                Color.customGreen
                    .frame(width: UIScreen.main.bounds.width / 1.2, height: 2)
                VStack {
                    ForEach(1..<13) { index in
                        HStack(alignment: .center) {
                            Spacer()
                            Text("\(index).")
                                .frame(minWidth: 35)
                                .font(.pretendardRegular_18)

                            Spacer()
                            Text(viewModel.answerSet[index])
                                .frame(minWidth: 35)
                                .font(.pretendardRegular_18)

                            Spacer()
                            Text(viewModel.userAnswer[index])
                                .frame(minWidth: 35)
                                .font(.pretendardRegular_18)

                            Spacer()
                        }
                        .frame(maxHeight: 15)
                        if index <= 11 {
                            Color.customGreen
                                .frame(width: UIScreen.main.bounds.width / 1.5, height: 1)
                        }
                    }
                }
                Spacer()
            } // VStack
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customGreen, lineWidth: 2)
                    .foregroundColor(.white)
                    .shadow(radius: 2, x: 1, y: 1)
                    .frame(width: UIScreen.main.bounds.width / 1.2)
            )
            .padding(.vertical, 5)
        }
        .padding(.top, 10)
    }
}

#Preview {
    ColorTestView()
}
