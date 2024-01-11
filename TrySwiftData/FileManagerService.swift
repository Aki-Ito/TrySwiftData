//
//  FileManagerService.swift
//  TrySwiftData
//
//  Created by 伊藤明孝 on 2024/01/10.
//
import Foundation
import AVFoundation
import UIKit

class FileManagerService{
    static let shared = FileManagerService()
    let fileManager = FileManager.default
    
    //MARK: フォルダを作る
    public func createFolder(){
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("error: no directory")
            return
        }
        
        let myAppDirectory = docDirectory.appending(path: "MyAppContents", directoryHint: .isDirectory)
        do{
            try fileManager.createDirectory(at: myAppDirectory, withIntermediateDirectories: true)
        }catch{
            print("Failed Creating Folder: \(error.localizedDescription)")
        }
    }
    
    //MARK: ファイルの保存
    public func saveFile(file: Data, fileName: String){
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("error: no directory")
            return
        }
        
        let myAppDirectory = docDirectory.appending(path: "MyAppContents")
        
        do{
            if !fileManager.fileExists(atPath: myAppDirectory.path) {
                try fileManager.createDirectory(at: myAppDirectory, withIntermediateDirectories: true, attributes: nil)
            }
            let fullPath = myAppDirectory.appending(path: fileName)
            
            try file.write(to: fullPath)
        }catch{
            print("error: no directory")
        }
    }
    
    //MARK: ファイルの読み込み
    public func readFile(fileName: String) -> Data?{
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("error: no directory")
            return nil
        }
        
        let myAppDirectory = docDirectory.appending(path: "MyAppContents")
        let fullPath = myAppDirectory.appending(path: fileName)
        
        do{
            let fileContents = try Data(contentsOf: fullPath)
            return fileContents
        }catch{
            print("error: \(error.localizedDescription)")
        }
        return nil
    }
    
    //MARK: ファイルの読み込み
    public func readFile(fullPath: String) -> Data?{
        let fullPathURL = URL(filePath: fullPath)
        
        do{
            let fileContents = try Data(contentsOf: fullPathURL)
            return fileContents
        }catch{
            print("error: \(error.localizedDescription)")
        }
        return nil
    }
}
