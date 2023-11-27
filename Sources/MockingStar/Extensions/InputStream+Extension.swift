//
//  InputStream+Extension.swift
//
//
//  Created by Yusuf Özgül on 27.11.2023.
//

import Foundation

extension InputStream {
    public func readData(bufferSize: Int = 1024) throws -> Data {
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        var data: [UInt8] = []

        open()

        while true {
            let count = read(&buffer, maxLength: buffer.capacity)

            guard count >= 0 else {
                close()
                throw StreamError.Error(error: streamError, partialData: data)
            }

            guard count != 0 else {
                close()
                return Data(data)
            }

            data.append(contentsOf: (buffer.prefix(count)))
        }
    }
}
