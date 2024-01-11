//
//  AddRecipeViewController.swift
//  TrySwiftData
//
//  Created by 伊藤明孝 on 2024/01/11.
//

import UIKit

class AddRecipeViewController: UIViewController {
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    let fileManagerService = FileManagerService.shared
    let swiftDataService = SwiftDataService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
    }
    
    @IBAction func tappedImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func tappedSaveButton(_ sender: Any) {
        self.saveContents()
    }
    
    
    @IBAction func tappedAddProcessButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toProcess", sender: nil)
    }
    
    private func saveContents(){
        guard let image = addImageButton.imageView?.image else {return}
        let data = image.jpegData(compressionQuality: 0.2)
        let fileName = titleTextField.text!
        fileManagerService.saveFile(file: data!, fileName: fileName)
        
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("error: no directory")
            return
        }
        
        let myAppDirectory = docDirectory.appending(path: "MyAppContents")
        let titleImagePath = myAppDirectory.appending(path: fileName)
        swiftDataService.saveRecipe(titleImagePath: titleImagePath.path(), title: fileName, cookProcess: nil)
        self.getPreviousController()
    }
    
    private func getPreviousController(){
        let preNvc = self.presentingViewController as! UINavigationController
        let vc = preNvc.viewControllers[0] as! ViewController
        vc.fetchData()
    }
    
}

extension AddRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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

extension AddRecipeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
