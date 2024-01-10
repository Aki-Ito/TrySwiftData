//
//  RecipeModel.swift
//  TrySwiftData
//
//  Created by 伊藤明孝 on 2024/01/10.
//

import Foundation
import SwiftData
@available(iOS 17, *)

@Model
final class RecipeModel{
    @Attribute(.unique) var id: String
    var titleImagePath: String
    var title: String
    var createdAt: Date
    var cookProcess: CookProcess
    
    init(id: String, titleImagePath: String, title: String, createdAt: Date, cookProcess: CookProcess) {
        self.id = id
        self.titleImagePath = titleImagePath
        self.title = title
        self.createdAt = createdAt
        self.cookProcess = cookProcess
    }
    
}

struct CookProcess: Codable{
    var minute: Int?
    var imagePath: String?
    var memo: String?
}
