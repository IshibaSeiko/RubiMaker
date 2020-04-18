//
//  ConvertEntity.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/18.
//  Copyright © 2020 石場清子. All rights reserved.
//

import Realm
import RealmSwift

final class ConvertEntity: Object {
    @objc dynamic var requestId = ""
    @objc dynamic var outputType = ""
    @objc dynamic var input = ""
    @objc dynamic var converted = ""
    @objc dynamic var favoriteFlg = false
    @objc dynamic var deleteFlg = false

    override static func primaryKey() -> String? {
        return "requestId"
    }

    required init() {
        super.init()
    }

    required init(input: String, convertResponse: ConvertResponse) {
        super.init()
        requestId = convertResponse.requestId
        outputType = convertResponse.outputType
        self.input = input
        converted = convertResponse.converted
        favoriteFlg = false
        deleteFlg = false
    }

    required init(convertEntity: ConvertEntity,
                  changeFavoriteStatus: Bool = false,
                  changeDeleteStatus: Bool = false) {
        super.init()
        requestId = convertEntity.requestId
        outputType = convertEntity.outputType
        self.input = convertEntity.input
        converted = convertEntity.converted
        favoriteFlg = changeFavoriteStatus ? !convertEntity.favoriteFlg : convertEntity.favoriteFlg
        deleteFlg = changeDeleteStatus ? !convertEntity.deleteFlg : convertEntity.deleteFlg

    }
}
