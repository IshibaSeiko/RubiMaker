//
//  ConvertAPI.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/15.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

final class ConvertAPI {
    func convert(_ sentence: String, type: ConvertType = .hiragana) {

        let request = ConvertRequest(sentence, type: type)

        APIClient.request(request: request) { response in
            switch response {
            case .success(let result):

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let result = result else {
                    return
                }
                do {
                    let decodedResult = try decoder.decode(ConvertResponse.self, from: result)
                } catch {
                    log?.info()
                }

            case .failure(let error):

                break
            }
        }
    }
}

