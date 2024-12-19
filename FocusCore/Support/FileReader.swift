//
//  FileReader.swift
//  FocusCore
//
//  Created by Adriano Souza Costa on 16/08/24.
//

import Foundation

public class FileReader {
    
    // MARK: - Public Methods
    
    public static func data<T: Decodable>(
        _ fileName: String,
        ofType: String,
        bundle: Bundle = .main,
        decoder: JSONDecoder = .init()
    ) throws -> T? {
        guard let filePath = bundle.path(
            forResource: fileName,
            ofType: ofType
        ) else {
            return nil
        }
            
        let fileUrl = URL(fileURLWithPath: filePath)
        let data = try Data(contentsOf: fileUrl)
        
        return try decoder.decode(T.self, from: data)
    }
    
    public static func content(
        _ fileName: String,
        withExtension: String,
        bundle: Bundle = .main,
        decoder: JSONDecoder = .init()
    ) throws -> String? {
        guard let filePath = bundle.url(
            forResource: fileName,
            withExtension: withExtension
        ) else {
            return nil
        }
        
        return try String(contentsOf: filePath)
    }
    
}
