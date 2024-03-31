//
//  String+Extension.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/11.
//

import Foundation

extension String {
    static let defaultProfileURL = "https://firebasestorage.googleapis.com/v0/b/eye-mate-29855.appspot.com/o/Profile_Images%2FdefaultImage.png?alt=media&token=923656d8-3cd8-4098-b5aa-3628770e0256"
    
    func convertMeter() -> String {
        guard let temp = Double(self) else { return "0m" }
        
        if temp > 1000.0 {
            return String(format: "%.2f", (Double(self) ?? 1.0) / 1000.0) + "km"
        }
        else {
            return String(Int(self) ?? 0) + "m"
        }
    }


}

