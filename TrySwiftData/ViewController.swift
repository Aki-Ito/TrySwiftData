//
//
//  Created by 伊藤明孝 on 2023/12/10.
//

import UIKit
import SwiftData

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    public var recipeModels = [RecipeModel]()
    let fileManagerService = FileManagerService.shared
    var container: ModelContainer?
    var context: ModelContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureCollectionView()
        self.fetchData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.viewWillAppear
//        self.fetchData()
//    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        // レイアウトを調整
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.collectionViewLayout = layout
    }
    
    func fetchData(){
        SwiftDataService.shared.fetchRecipe { recipes, error in
            if let error{
                print(error)
            }
            
            if let recipes{
                self.recipeModels = recipes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func convertToImage(fileName: String) -> UIImage?{
        let data = fileManagerService.readFile(fileName: fileName)
        if let data{
            return UIImage(data: data)
        }else{
            return nil
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let title = recipeModels[indexPath.row].title
        cell.label.text = title
        cell.imageView.image = self.convertToImage(fileName: recipeModels[indexPath.row].title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return recipeModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 2 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
}

