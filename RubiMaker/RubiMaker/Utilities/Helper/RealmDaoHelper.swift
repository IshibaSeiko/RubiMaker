//
//  RealmDaoHelper.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/18.
//  Copyright © 2020 石場清子. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmDaoHelper <T : RealmSwift.Object> {

    var realm: Realm

    init() {
        let realmConfiguration = Realm.Configuration(fileURL: RealmDaoHelper.fileURL())
        let realmInitializer = RealmInitializer(configuration: realmConfiguration)
        self.realm = realmInitializer.initializeRealm()
        log?.info(self.realm.configuration.fileURL!)

        defer {
            realm.invalidate()
        }
    }

    /**
     * 新規主キー発行
     */
    func newId() -> Int? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            return nil
        }
        return (realm.objects(T.self).max(ofProperty: key) as Int? ?? 0) + 1
    }

    /**
     * 全件取得
     */
    func findAll() -> Results<T> {
        return realm.objects(T.self)
    }

    /**
     * 1件目のみ取得
     */
    func findFirst() -> T? {
        return findAll().first
    }

    /**
     * 指定キーのレコードを取得
     */
    func findFirst(key: AnyObject) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: key)
    }

    /**
     * 最後のレコードを取得
     */
    func findLast() -> T? {
        return findAll().last
    }

    func filter(predicate: NSPredicate) -> Results<T> {
        return realm.objects(T.self).filter(predicate)
    }

    /**
     * レコード追加
     */
    func add(object :T) {
        do {
            try realm.write {
                realm.add(object, update: .error)
            }
        } catch let error {
            log?.error(error.localizedDescription)
        }
    }

    /// 複数件のレコードを追加
    ///
    /// - Parameter objects: 複数件のレコード
    func add(objects: [T]) {
        do {
            try realm.write {
                realm.add(objects, update: .modified)
            }
        } catch let error {
            log?.error(error.localizedDescription)
        }
    }

    /**
     * T: RealmSwift.Object で primaryKey()が実装されている時のみ有効
     */
    @discardableResult
    func update(object: T, block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(object, update: .all)
            }
            return true
        } catch let error {
            log?.error(error.localizedDescription)
        }
        return false
    }

    @discardableResult
    func update(objects: [T], block:(() -> Void)? = nil) -> Bool {
        do {
            try realm.write {
                block?()
                realm.add(objects, update: .all)
            }
            return true
        } catch let error {
            log?.error(error.localizedDescription)
        }
        return false
    }

    /**
     * レコード削除
     */
    func delete(object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let error {
            log?.error(error.localizedDescription)
        }
    }

    /**
     * レコードを複数件削除
     */
    func delete(objects: [T]) {
        do {
            try realm.write {
                realm.delete(objects)
            }
        } catch let error {
            log?.error(error.localizedDescription)
        }
    }

    /**
     * レコード全削除
     */
    func deleteAll() {
        let objs = realm.objects(T.self)
        do {
            try realm.write {
                realm.delete(objs)
            }
        } catch let error {
            log?.error(error.localizedDescription)
        }
    }
}

extension RealmDaoHelper {
    /// RealmファイルURL
    private static func fileURL() -> URL? {
        var filePath = ""
        guard let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        filePath = documentDirectory
        filePath.append("/RubiMaker.realm")
        return URL(string: filePath)
    }
}
