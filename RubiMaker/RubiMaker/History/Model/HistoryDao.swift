//
//  HistoryDao.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/18.
//  Copyright © 2020 石場清子. All rights reserved.
//

import Foundation
import RealmSwift

final class HistoryDao {
    static let dao = RealmDaoHelper<ConvertEntity>()

    static func add(objects: [ConvertEntity]) {
        deleteAll()
        dao.add(objects: objects)
    }

    static func deleteAll() {
        dao.deleteAll()
    }

    static func findByID(id: Int) -> ConvertEntity? {
        guard let object = dao.findFirst(key: id as AnyObject) else {
            return nil
        }
        return object
    }

    static func findUnDeleteObjects() -> [ConvertEntity] {
        let predicate = NSPredicate(format: "deleteFlg = false")
        let objects = dao.filter(predicate: predicate)
        return Array(objects)
    }

    static func findFirst() -> ConvertEntity? {
        guard let object = dao.findFirst() else {
            return nil
        }
        return object
    }

    static func findAll() -> [ConvertEntity] {
        return Array(dao.findAll())
    }

    static func update(object: ConvertEntity) {
        dao.update(object: object)
    }
}
