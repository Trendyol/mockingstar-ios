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
        var data = Data()

        open()

        while hasBytesAvailable {
            let bytesRead = read(&buffer, maxLength: bufferSize)

            if bytesRead < 0 {
                // Handle error
                close()
                throw StreamError.Error(error: streamError, partialData: [UInt8](data))
            }

            if bytesRead > 0 {
                // Append the read bytes to the Data object
                data.append(buffer, count: bytesRead)
            }
        }

        close()

        return data
    }
}
