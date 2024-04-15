//
//  FileManager.swift
//  HealthPulse
//
//  Created by Leon Grimmeisen on 15.04.24.
//

import Foundation

class LocalFileManager {
    
    // Singleton
    static let instance = LocalFileManager()
    private init() {}
    
    // MARK: Public Functions
    
    // MARK: Private Functions
    
    private func getDocumentsDirectory() -> URL {
        // this function returns the directory from the user for our app specifically, no other app can acccess this.
        // this belongs to our app, synced to iCloud with App, deleted with app, ...
        // no limit for data to be stored in here
        // we can read and write files in there freely
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths [0]
    }
    
//    private func createFolderIfNeeded(folderName: String) {
//        guard let url = getURLForFolder(folderName: folderName) else { return }
//        if !FileManager.default.fileExists(atPath: url.path) {
//            do {
//                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
//            } catch let error {
//                print("error creating directory \(error.localizedDescription)")
//            }
//        }
//    }
    
}

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

