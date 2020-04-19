//
//  RealmInitializer.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/18.
//  Copyright © 2020 石場清子. All rights reserved.
//

import RealmSwift

final class RealmInitializer: RealmInitializeService {
    let configuration: Realm.Configuration?

    init(configuration: Realm.Configuration? = nil) {
        self.configuration = configuration
    }

    func initializeRealm() -> Realm {
        do {
            var realm: Realm
            if let configuration = configuration {
                realm = try Realm(configuration: configuration)
            } else {
                realm = try Realm()
            }
            return realm

        } catch {
            fatalError("Realm initialize error: \(error)")
        }
    }
}
