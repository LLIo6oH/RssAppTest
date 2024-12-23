//
//  DBService.swift
//  RssApp
//
//  Created by Dmitry Kuklin on 23.12.2024.
//

import RealmSwift

protocol DBServiceProtocol {
    func save<T: Object>(objects: [T], completion: @escaping (Error?) -> Void)
    func fetchAll<T: Object>(ofType type: T.Type, completion: @escaping ([T]) -> Void)
    func clearCache<T: Object>(ofType type: T.Type, completion: @escaping (Error?) -> Void)
    func updateObject<T: Object>(ofType type: T.Type, withPrimaryKey primaryKey: String, updateBlock: @escaping (T) -> Void, completion: @escaping (Error?) -> Void)
}

final class DBService: DBServiceProtocol {
    private var realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func save<T: Object>(objects: [T], completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.add(objects, update: .modified)
                }
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func updateObject<T: Object>(ofType type: T.Type, withPrimaryKey primaryKey: String, updateBlock: @escaping (T) -> Void, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.async {
            do {
                if let objectToUpdate = self.realm.object(ofType: type, forPrimaryKey: primaryKey) {
                    try self.realm.write {
                        updateBlock(objectToUpdate)
                    }
                    completion(nil)
                } else {
                    completion(NSError(domain: "DBService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Object not found"]))
                }
            } catch {
                completion(error)
            }
        }
    }
    
    func fetchAll<T: Object>(ofType type: T.Type, completion: @escaping ([T]) -> Void) {
        DispatchQueue.main.async {
            let results = self.realm.objects(type)
            completion(Array(results))
        }
    }
    
    func clearCache<T: Object>(ofType type: T.Type, completion: @escaping (Error?) -> Void) {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    let objects = self.realm.objects(type)
                    self.realm.delete(objects)
                }
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
