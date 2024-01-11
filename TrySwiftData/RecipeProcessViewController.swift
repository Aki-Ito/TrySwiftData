//
//  RecipeProcessViewController.swift
//  TrySwiftData
//
//  Created by 伊藤明孝 on 2024/01/11.
//

import UIKit

class RecipeProcessViewController: UIViewController {

    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    let fileManagerService = FileManagerService.shared
    let swiftDataService = SwiftDataService.shared
    public var recipeModel : RecipeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    
    @IBAction func tappedSaveButton(_ sender: Any) {
        
        
    }
    
}

extension RecipeProcessViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //サイズなどを変えた際に受け取るイメージ
        if let image = info[.editedImage] as? UIImage{
            addImageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            //大きさが何も変わっていない
        }else if let originalImage = info[.originalImage] as? UIImage{
            addImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        addImageButton.setTitle("", for: .normal)
        addImageButton.imageView?.contentMode = .scaleAspectFill
        addImageButton.contentHorizontalAlignment = .fill
        addImageButton.contentVerticalAlignment = .fill
        addImageButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
}
