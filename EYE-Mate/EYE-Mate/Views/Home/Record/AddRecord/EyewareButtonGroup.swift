//
//  EyewareButtonGroup.swift
//  EYE-Mate
//
//  Created by seongjun on 2/1/24.
//

import SwiftUI

enum Eyeware: String {
    case not = "미착용"
    case glasses = "안경"
    case lens = "렌즈"
    case magnifying = "돋보기"
}

struct EyewareButtonGroup: View {
    let callback: (String) -> ()

    @State var selectedId: String = ""

    var body: some View {
        HStack(spacing: 12) {
            radioNotMajority
            radioGlassesMajority
            radioLensMajority
            radioMagnifyingMajority
        }
    }

    var radioNotMajority: some View {
        RadioButton(
            id: Eyeware.not.rawValue,
            label: Eyeware.not.rawValue,
            isMarked: selectedId == Eyeware.not.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }

    var radioGlassesMajority: some View {
        RadioButton(
            id: Eyeware.glasses.rawValue,
            label: Eyeware.glasses.rawValue,
            isMarked: selectedId == Eyeware.glasses.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }

    var radioLensMajority: some View {
        RadioButton(
            id: Eyeware.lens.rawValue,
            label: Eyeware.lens.rawValue,
            isMarked: selectedId == Eyeware.lens.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }

    var radioMagnifyingMajority: some View {
        RadioButton(
            id: Eyeware.magnifying.rawValue,
            label: Eyeware.magnifying.rawValue,
            isMarked: selectedId == Eyeware.magnifying.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }


    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
    }
}

#Preview {
    EyewareButtonGroup { selected in
        print("Selected is: \(selected)")
    }
}
