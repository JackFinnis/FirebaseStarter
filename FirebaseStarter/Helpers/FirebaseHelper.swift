//
//  FirebaseHelper.swift
//  Ecommunity
//
//  Created by Jack Finnis on 08/10/2021.
//

import Foundation
import FirebaseFirestore

struct FirebaseHelper {
    // MARK: - Properties
    let database = Firestore.firestore()
    
    // MARK: - General Static Fetching
    func getDocumentData(collection: String, documentID: String) async -> [String : Any]? {
        try? await database.collection(collection).document(documentID).getDocument().data()
    }
    
    // MARK: - General Updating Data
    func addDocument(collection: String, documentID: String, data: [String : Any]) async {
        try? await database.collection(collection).document(documentID).setData(data)
    }
    
    func updateData(collection: String, documentID: String, data: [String : Any]) async {
        try? await database.collection(collection).document(documentID).updateData(data)
    }
    
    func addElement(collection: String, documentID: String, arrayName: String, element: String) async {
        if let data = await getDocumentData(collection: collection, documentID: documentID) {
            var array = data[arrayName] as? [String] ?? []
            array.append(element)
            await updateData(collection: collection, documentID: documentID, data: [arrayName : array])
        }
    }
    
    func addUserListener(userID: String, completion: @escaping (User?) -> Void) -> ListenerRegistration {
        addDocumentListener(collection: "users", documentID: userID) { data in
            completion(User(id: userID, data: data))
        }
    }
    
    func addUsersListener(userIDs: [String]?, completion: @escaping ([User]) -> Void) -> ListenerRegistration {
        addCollectionListener(collection: "users", documentIDs: userIDs) { documents in
            completion(documents.map { document -> User in
                return User(id: document.documentID, data: document.data())
            })
        }
    }
    
    // MARK: - General Listeners
    func addDocumentListener(collection: String, documentID: String, completion: @escaping ([String : Any]) -> Void) -> ListenerRegistration {
        database.collection(collection).document(documentID).addSnapshotListener { (document, error) in
            if let data = document?.data() {
                completion(data)
            }
        }
    }
    
    func addCollectionListener(collection: String, documentIDs: [String]?, completion: @escaping ([QueryDocumentSnapshot]) -> Void) -> ListenerRegistration {
        database.collection(collection).addSnapshotListener { (queryDocuments, error) in
            if let documents = queryDocuments?.documents {
                completion(documents.filter { document in
                    documentIDs == nil || documentIDs!.contains(document.documentID)
                })
            }
        }
    }
    
    // MARK: - Users
    func getUser(userID: String) async -> User? {
        if let data = await getDocumentData(collection: "users", documentID: userID) {
            return User(id: userID, data: data)
        }
        return nil
    }
}
