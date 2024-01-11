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
    @IBOutlet weak var tableView: UITableView!
    public var recipeModel : RecipeModel?
    
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
    
    private func moveToProcess(model: RecipeModel){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nvc = storyboard.instantiateViewController(withIdentifier: "AddNVC") as! UINavigationController
        let vc = nvc.viewControllers[0] as! RecipeProcessViewController
        vc.recipeModel = self.recipeModel
        self.present(vc, animated: true)
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

extension AddRecipeViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeModel?.cookProcess?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
