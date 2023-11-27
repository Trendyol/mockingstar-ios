//
//  StreamError.swift
//  
//
//  Created by Yusuf Özgül on 27.11.2023.
//

import Foundation

public enum StreamError: Error {
    case Error(error: Error?, partialData: [UInt8])
}
