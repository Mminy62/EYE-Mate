//
//  SightTestViewModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/02.
//

import Foundation
import FirebaseFirestore

class SightTestViewModel: ObservableObject {
    @Published var userAnswer: [String] = []
    
    private var left = ""
    private var right = ""
    
    var isLeftEye: Bool {
        if userAnswer[0] == "Y" {
            left = "좋음"
            return true
        } else {
            left = "나쁨"
            return false
        }
    }
    
    var isRightEye: Bool {
        if userAnswer[1] == "Y" {
            right = "좋음"
            return true
        } else {
            right = "나쁨"
            return false
        }
    }
    
    var leftImage: String {
        isLeftEye ? "Component9" : "Component10"
    }
    
    var rightImage: String {
        isRightEye ? "Component9" : "Component10"
    }
    
    var titleText: String {
        if isLeftEye && isRightEye {
            return "양쪽 눈"
        } else if !isLeftEye && isRightEye {
            return "왼쪽 눈"
        } else if isLeftEye && !isRightEye {
            return "오른쪽 눈"
        } else {
            return "양쪽 눈"
        }
    }
    
    var subTitleText: String {
        if isLeftEye && isRightEye {
            return "의 시야가 넓은 것 같습니다."
        } else {
            return "의 시야가 좁아진 것 같습니다."
        }
    }
    
    var explainText: String {
        if isLeftEye && isRightEye {
            return "눈 건강 유지를 위해\n주기적으로 정밀 눈 검사를 권장드려요."
        } else {
            return "정확한 진단을 위해\n정밀 눈 검사를 받아보는걸 추천드려요."
        }
    }
}

//MARK: - Firebase Method
extension SightTestViewModel {
    func saveResult(_ uid: String) {
        let sightDoc = Firestore.firestore()
            .collection("Records")
            .document(uid)
            .collection("Sights")
            .document()
        
        let sightItem = Sights(left: left, right: right)
        
        do {
            let _ = try sightDoc.setData(from: sightItem)
        } catch {
            print("error: \(error.localizedDescription)")
        }
        
    }
}
