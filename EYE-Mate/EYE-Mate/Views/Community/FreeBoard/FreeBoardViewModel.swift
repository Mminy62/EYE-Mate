//
//  FreeBoardViewModel.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/30/24.
//

import SwiftUI

import FirebaseFirestore

class FreeBoardViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isFetching: Bool = true
    
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    
    @Published var paginationDoc: QueryDocumentSnapshot?
    
    @Published var isShowCreateView: Bool = false
    
    @AppStorage("user_UID") var userUID: String = ""
    
    /// - 게시물 Fetch
    func fetchPosts() async {
        do {
            var query: Query!
            
            // MARK: 게시물 Pagination
            if let paginationDoc {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            } else {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .limit(to: 20)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = try await docs.documents.asyncMap{ doc -> Post? in
                var post = try? doc.data(as: Post.self)
                
                // userName 업데이트
                if let userUID = post?.userUID, !userUID.isEmpty {
                    let postUser = try await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self)
                    post?.userName = postUser.userName
                    post?.userImageURL = postUser.userImageURL!
                }
                
                // Comment 가져오기
                guard let postID = post?.id else { return nil }
                let commentsQuerySnapshot = try await Firestore.firestore()
                    .collection("Posts")
                    .document(postID)
                    .collection("Comments")
                    .order(by: "publishedDate", descending: false)
                    .getDocuments()
                
                post?.comments = try await commentsQuerySnapshot.documents.asyncMap{ commentDoc -> Comment? in
                    var comment = try? commentDoc.data(as: Comment.self)
                    
                    // 댓글 userName 업데이트
                    if let commentUserUID = comment?.userUID, !commentUserUID.isEmpty {
                        let commentUser = try await Firestore.firestore().collection("Users").document(commentUserUID).getDocument(as: User.self)
                        comment?.userName = commentUser.userName
                        comment?.userImageURL = commentUser.userImageURL!
                    }
                    
                    // 댓글의 대댓글 가져오기
                    let replyCommentsQuerySnapshot = try await Firestore.firestore()
                        .collection("Posts")
                        .document(postID)
                        .collection("Comments")
                        .document(commentDoc.documentID)
                        .collection("ReplyComments")
                        .order(by: "publishedDate", descending: false)
                        .getDocuments()
                    
                    comment?.replyComments = try await replyCommentsQuerySnapshot.documents.asyncMap{ replyDoc -> ReplyComment? in
                        var replyComment = try? replyDoc.data(as: ReplyComment.self)
                        
                        // 대댓글 userName 업데이트
                        if let replyCommentUserUID = replyComment?.userUID, !replyCommentUserUID.isEmpty {
                            let replyCommentUser = try await Firestore.firestore().collection("Users").document(replyCommentUserUID).getDocument(as: User.self)
                            replyComment?.userName = replyCommentUser.userName
                            replyComment?.userImageURL = replyCommentUser.userImageURL!
                        }
                        
                        return replyComment
                    }.compactMap{ $0 }
                    
                    return comment
                }.compactMap{ $0 }
                
                return post
            }.compactMap{ $0 }
            
            await MainActor.run {
                posts.append(contentsOf: fetchedPosts)
                
                // Pagination에 사용하기 위해 마지막에 가져온 Document를 저장
                paginationDoc = docs.documents.last
                isFetching = false
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// - 검색어를 포함한 게시물 Fetch
    func fetchPosts(searchText: String) async {
        do {
            var query: Query!
            
            query = Firestore.firestore().collection("Posts")
                .order(by: "publishedDate", descending: true)
           
            
            let docs = try await query.getDocuments()
            let fetchedPosts = try await docs.documents.asyncMap{ doc -> Post? in
                var post = try? doc.data(as: Post.self)
                
                // userName 업데이트
                if let userUID = post?.userUID, !userUID.isEmpty {
                    let postUser = try await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self)
                    post?.userName = postUser.userName
                    post?.userImageURL = postUser.userImageURL!
                }
                
                if var post = post, post.postTitle.contains(searchText) || post.postContent.contains(searchText) {
                    
                    // Comment 가져오기
                    guard let postID = post.id else { return nil }
                    let commentsQuerySnapshot = try await Firestore.firestore()
                        .collection("Posts")
                        .document(postID)
                        .collection("Comments")
                        .order(by: "publishedDate", descending: false)
                        .getDocuments()
                    
                    post.comments = try await commentsQuerySnapshot.documents.asyncMap{ commentDoc -> Comment? in
                        var comment = try? commentDoc.data(as: Comment.self)
                        
                        // 댓글 userName 업데이트
                        if let commentUserUID = comment?.userUID, !commentUserUID.isEmpty {
                            let commentUser = try await Firestore.firestore().collection("Users").document(commentUserUID).getDocument(as: User.self)
                            comment?.userName = commentUser.userName
                            comment?.userImageURL = commentUser.userImageURL!
                        }
                        
                        // 댓글의 대댓글 가져오기
                        let replyCommentsQuerySnapshot = try await Firestore.firestore()
                            .collection("Posts")
                            .document(postID)
                            .collection("Comments")
                            .document(commentDoc.documentID)
                            .collection("ReplyComments")
                            .order(by: "publishedDate", descending: false)
                            .getDocuments()
                        
                        comment?.replyComments = try await replyCommentsQuerySnapshot.documents.asyncMap{ replyDoc -> ReplyComment? in
                            var replyComment = try? replyDoc.data(as: ReplyComment.self)
                            
                            // 대댓글 userName 업데이트
                            if let replyCommentUserUID = replyComment?.userUID, !replyCommentUserUID.isEmpty {
                                let replyCommentUser = try await Firestore.firestore().collection("Users").document(replyCommentUserUID).getDocument(as: User.self)
                                replyComment?.userName = replyCommentUser.userName
                                replyComment?.userImageURL = replyCommentUser.userImageURL!
                            }
                            
                            return replyComment
                        }.compactMap{ $0 }
                        
                        return comment
                    }.compactMap{ $0 }
                    
                    return post
                } else {
                    return nil
                }
            }.compactMap{ $0 }
            
            await MainActor.run {
                posts = fetchedPosts
                isFetching = false
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// - 게시물 refresh
    func refreshable() async {
        await MainActor.run {
            isFetching = true
            posts = []
            paginationDoc = nil
        }
        
        if isSearching {
            await fetchPosts(searchText: searchText)
        } else {
            await fetchPosts()
        }
    }
    
    /// - 내가 쓴 게시물 Fetch
    func fetchMyPosts() async {
        do {
            var query: Query!
            
            if let paginationDoc {
                query = Firestore.firestore().collection("Posts")
                    .whereField("userUID", isEqualTo: userUID)
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            } else {
                query = Firestore.firestore().collection("Posts")
                    .whereField("userUID", isEqualTo: userUID)
                    .order(by: "publishedDate", descending: true)
                    .limit(to: 20)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = try await docs.documents.asyncMap{ doc -> Post? in
                var post = try? doc.data(as: Post.self)
                
                // userName 업데이트
                if let userUID = post?.userUID, !userUID.isEmpty {
                    let postUser = try await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self)
                    post?.userName = postUser.userName
                    post?.userImageURL = postUser.userImageURL!
                }
                
                // Comment 가져오기
                guard let postID = post?.id else { return nil }
                let commentsQuerySnapshot = try await Firestore.firestore()
                    .collection("Posts")
                    .document(postID)
                    .collection("Comments")
                    .order(by: "publishedDate", descending: false)
                    .getDocuments()
                
                post?.comments = try await commentsQuerySnapshot.documents.asyncMap{ commentDoc -> Comment? in
                    var comment = try? commentDoc.data(as: Comment.self)
                    
                    // 댓글 userName 업데이트
                    if let commentUserUID = comment?.userUID, !commentUserUID.isEmpty {
                        let commentUser = try await Firestore.firestore().collection("Users").document(commentUserUID).getDocument(as: User.self)
                        comment?.userName = commentUser.userName
                        comment?.userImageURL = commentUser.userImageURL!
                    }
                    
                    // 댓글의 대댓글 가져오기
                    let replyCommentsQuerySnapshot = try await Firestore.firestore()
                        .collection("Posts")
                        .document(postID)
                        .collection("Comments")
                        .document(commentDoc.documentID)
                        .collection("ReplyComments")
                        .order(by: "publishedDate", descending: false)
                        .getDocuments()
                    
                    comment?.replyComments = try await replyCommentsQuerySnapshot.documents.asyncMap{ replyDoc -> ReplyComment? in
                        var replyComment = try? replyDoc.data(as: ReplyComment.self)
                        
                        // 대댓글 userName 업데이트
                        if let replyCommentUserUID = replyComment?.userUID, !replyCommentUserUID.isEmpty {
                            let replyCommentUser = try await Firestore.firestore().collection("Users").document(replyCommentUserUID).getDocument(as: User.self)
                            replyComment?.userName = replyCommentUser.userName
                            replyComment?.userImageURL = replyCommentUser.userImageURL!
                        }
                        
                        return replyComment
                    }.compactMap{ $0 }
                    
                    return comment
                }.compactMap{ $0 }
                
                return post
            }.compactMap{ $0 }
            
            await MainActor.run {
                posts.append(contentsOf: fetchedPosts)
                paginationDoc = docs.documents.last
                isFetching = false
            }
            
        } catch {
            print("FreeBoardViewModel - fetchMyPosts(): \(error.localizedDescription)")
        }
    }
    
    /// - 스크랩한 게시물 Fetch
    func fetchScrapPosts() async {
        do {
            var query: Query!
            
            if let paginationDoc {
                query = Firestore.firestore().collection("Posts")
                    .whereField("scrapIDs", arrayContains: userUID)
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            } else {
                query = Firestore.firestore().collection("Posts")
                    .whereField("scrapIDs", arrayContains: userUID)
                    .order(by: "publishedDate", descending: true)
                    .limit(to: 20)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = try await docs.documents.asyncMap{ doc -> Post? in
                var post = try? doc.data(as: Post.self)
                
                // userName 업데이트
                if let userUID = post?.userUID, !userUID.isEmpty {
                    let postUser = try await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self)
                    post?.userName = postUser.userName
                    post?.userImageURL = postUser.userImageURL!
                }
                
                // Comment 가져오기
                guard let postID = post?.id else { return nil }
                let commentsQuerySnapshot = try await Firestore.firestore()
                    .collection("Posts")
                    .document(postID)
                    .collection("Comments")
                    .order(by: "publishedDate", descending: false)
                    .getDocuments()
                
                post?.comments = try await commentsQuerySnapshot.documents.asyncMap{ commentDoc -> Comment? in
                    var comment = try? commentDoc.data(as: Comment.self)
                    
                    // 댓글 userName 업데이트
                    if let commentUserUID = comment?.userUID, !commentUserUID.isEmpty {
                        let commentUser = try await Firestore.firestore().collection("Users").document(commentUserUID).getDocument(as: User.self)
                        comment?.userName = commentUser.userName
                        comment?.userImageURL = commentUser.userImageURL!
                    }
                    
                    // 댓글의 대댓글 가져오기
                    let replyCommentsQuerySnapshot = try await Firestore.firestore()
                        .collection("Posts")
                        .document(postID)
                        .collection("Comments")
                        .document(commentDoc.documentID)
                        .collection("ReplyComments")
                        .order(by: "publishedDate", descending: false)
                        .getDocuments()
                    
                    comment?.replyComments = try await replyCommentsQuerySnapshot.documents.asyncMap{ replyDoc -> ReplyComment? in
                        var replyComment = try? replyDoc.data(as: ReplyComment.self)
                        
                        // 대댓글 userName 업데이트
                        if let replyCommentUserUID = replyComment?.userUID, !replyCommentUserUID.isEmpty {
                            let replyCommentUser = try await Firestore.firestore().collection("Users").document(replyCommentUserUID).getDocument(as: User.self)
                            replyComment?.userName = replyCommentUser.userName
                            replyComment?.userImageURL = replyCommentUser.userImageURL!
                        }
                        
                        return replyComment
                    }.compactMap{ $0 }
                    
                    return comment
                }.compactMap{ $0 }
                
                return post
            }.compactMap{ $0 }
            
            await MainActor.run {
                posts.append(contentsOf: fetchedPosts)
                paginationDoc = docs.documents.last
                isFetching = false
            }
            
        } catch {
            print("FreeBoardViewModel - fetchScrapPosts(): \(error.localizedDescription)")
        }
    }
}

// 비동기 Map
extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}
