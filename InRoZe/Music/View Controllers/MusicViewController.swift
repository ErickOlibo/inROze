//
//  MusicViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 04/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData

//private let reuseIdentifier = "Cell"

class MusicViewController: UICollectionViewController {
    
    
    // Core Data model container and context
    //var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    let mainContext = AppDelegate.viewContext

    
    // properties
    var mixtapes: [Mixtape]? { didSet { print("Total Mixtapes: \(mixtapes?.count ?? 0)") } }
    
    
    
    // VIEW life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let sizeH = collectionView?.frame.height
        let sizeW = collectionView?.frame.width
        print("CollectionView Size: WxH [\(sizeW ?? 0) x \(sizeH ?? 0)]")
        setupNavBar()
        getAllMixtapes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAllMixtapes()
    }
    
    
    // Methods
    
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.view.backgroundColor = .white
        navigationItem.title = "Mixtapes"
    }
    
    
    private func getAllMixtapes() {
        if let context = container?.viewContext {
            context.perform {
                let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
                //let sort = NSSortDescriptor(key: "length", ascending: true, selector: nil)
                //request.sortDescriptors = [sort]
                request.predicate = NSPredicate(format: "isActive == YES")
                do {
                    let matches = try context.fetch(request)
                    self.mixtapes = matches
                } catch {
                    print("[MusicViewController] - There was an Error")
                }
                self.collectionView?.reloadData()
            }
        }
    }
 

}



extension MusicViewController: UICollectionViewDelegateFlowLayout
{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return mixtapes?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicMixCell.identifier, for: indexPath) as! MusicMixCell
        cell.tag = indexPath.row
        cell.mixtape = mixtapes?[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell: \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 20)) / 2
        return CGSize(width: itemSize, height: itemSize + 50)
    }
    
    
}