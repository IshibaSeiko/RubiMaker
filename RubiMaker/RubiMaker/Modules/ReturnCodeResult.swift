//
//  ReturnCodeResult.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/15.
//  Copyright © 2020 石場清子. All rights reserved.
//

import Foundation

enum IndividualResult {
    case loading
    case success(_ T: Decodable)
    case failure(_ error: Error)
    case systemError
    case payloadTooLarge
    case rateLimitExceeded

    var errorMessage: String {
        switch self {
        case .failure(_):
            return "エラーが発生しました。\nアプリ管理者までお問い合わせください。"
        case .systemError:
            return "システムエラーが発生しました。\nアプリ管理者までお問い合わせください。"
        case .payloadTooLarge:
            return "変換する文字が多過ぎます。\n文字数を減らし、再度お試しください。"
        case .rateLimitExceeded:
            return "本日の利用上限を超過しました。\n時間を開けて再度お試しください。"
        default:
            return ""
        }
    }
}

protocol ReturnCodeResult: AnyObject {
    func returnCodeResult(returnCode: IndividualResult)
}

