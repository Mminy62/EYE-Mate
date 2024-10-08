//
//  onBoardingViewModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import Foundation
import FirebaseFirestore

struct Article: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var url: String
}

class EyeSenseOnBoardingViewModel: ObservableObject {
    @Published var articles: [Article] = []
    var title: String
    
    let db = Firestore.firestore()
    
    init(title: String = "") {
        self.title = title
    }
}

extension EyeSenseOnBoardingViewModel {
    
    @MainActor
    func fetchData() async -> [Article] {
        do {
            articles.removeAll()
            let query = db.collection("Articles")
            let snapshot = try await query.getDocuments()
            let totalCount = snapshot.count
            let randomIndices = (0..<totalCount).shuffled().prefix(3)
            var selectedDocuments: [DocumentSnapshot] = []
            
            for index in randomIndices {
                let document = snapshot.documents[index]
                selectedDocuments.append(document)
            }
            
            for document in selectedDocuments {
                // articles에 정보 담기
                if let data = document.data() {
                    articles.append(Article(title: data["title"] as! String, url: data["url"] as! String))
                }
            }
            
            return articles
        } catch {
            print("Error getting documents: \(error)")
        }
        return []
    }
}
