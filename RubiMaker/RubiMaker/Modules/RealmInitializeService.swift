//
//  RealmInitializeService.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/18.
//  Copyright © 2020 石場清子. All rights reserved.
//

import RealmSwift

protocol RealmInitializeService {
    var configuration: Realm.Configuration? { get }
    func initializeRealm() -> Realm
}

