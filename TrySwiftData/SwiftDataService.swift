//
//  SwiftDataService.swift
//  FileManager
//
//  Created by 伊藤明孝 on 2023/12/14.
//

import Foundation
import SwiftData

//MARK: CRUD OPERATION
@available(iOS 17, *)
class SwiftDataService{
    static let shared = SwiftDataService()
    var container: ModelContainer?
    var context: ModelContext?
    
    init(){
        do{
            container = try ModelContainer(for: RecipeModel.self)
            if let container{
                context = ModelContext(container)
            }
        }catch{
            
        }
    }
    
    func saveRecipe(titleImagePath: String, title: String, cookProcess: [CookProcess]?){
        if let context{
            let savedRecipe = RecipeModel(id: UUID().uuidString, titleImagePath: titleImagePath, title: title, createdAt: Date(), cookProcess: cookProcess)
            context.insert(savedRecipe)
        }
    }

    func fetchRecipe(onCompletion: @escaping([RecipeModel]?, Error?) -> Void){
        let descriptor = FetchDescriptor<RecipeModel>(sortBy: [SortDescriptor<RecipeModel>(\.createdAt)])
        
        if let context{
            do{
                let data = try context.fetch(descriptor)
                onCompletion(data, nil)
            }catch{
                onCompletion(nil, error)
            }
        }
    }
    
    func updateRecipe(model: RecipeModel,  cookProcess: [CookProcess]){
        model.cookProcess = cookProcess
    }
//    
//    func deleteVideo(videoModel: VideoModel){
//        if let context{
//            context.delete(videoModel)
//        }
//    }
}
