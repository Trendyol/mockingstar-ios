//
//  Error.swift
//
//
//  Created by Yusuf Özgül on 27.11.2023.
//

import Foundation

func createError(message: String) -> Error {
    let userInfo: [String : Any] = [
        NSLocalizedDescriptionKey: message
    ]

    return NSError(domain: "MockingStar", code: -1, userInfo: userInfo)
}
