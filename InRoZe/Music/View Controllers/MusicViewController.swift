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
    
    
    // Outlets
    @IBOutlet weak var searchCatalogueButton: UIBarButtonItem!
    
    // Actions
    @IBAction func searchCatalogueTouched(_ sender: UIBarButtonItem) {
        print("searchCatalogueTouched")
    }
    

    
    // properties
    var mixtapes: [Mixtape]? //{ didSet { print("Total Mixtapes: \(mixtapes?.count ?? 0)") } }
    
    var recentlyPlayedMix: [Mixtape]?
    var newReleasesMix: [Mixtape]?
    var yourListMix: [Mixtape]?
    var numberOfCells: Int = 0
    
    //private let sectionNames = ["New Releases", "Your List", "Recently Played"]
    //private let sectionNames = ["Your List"]
    
    
    // VIEW life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCatalogueButton.tintColor = Colors.logoRed

        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        let sizeH = collectionView?.frame.height
//        let sizeW = collectionView?.frame.width
//        print("CollectionView Size: WxH [\(sizeW ?? 0) x \(sizeH ?? 0)]")
        setupNavBar()
        otherMixtapes()
        getAllMixtapes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        otherMixtapes()
        print("yourList [\(yourListMix?.count ?? 0)] - New [\(newReleasesMix?.count ?? 0)] - Recent [\(recentlyPlayedMix?.count ?? 0)]")
        getAllMixtapes()
    }
    
    
    // Methods
    
    
    
    // Get info for Recently Played, Your List and New Releases
    private func otherMixtapes() {
        yourListMix = Mixtape.listOfFollows(in: mainContext)
        newReleasesMix = Mixtape.newReleases(in: mainContext)
        recentlyPlayedMix = Mixtape.recentlyPlayed(in: mainContext)
        getNumberCells()
        
    }
    
    
    private func getNumberCells() {
        var numb = 0
        if let released = newReleasesMix?.count, released > 0 {
            numb += 1
        }
        if let played = recentlyPlayedMix?.count, played > 0 {
            numb += 1
        }
        if let yourList = yourListMix?.count, yourList > 0 {
            numb += 1
        }
        numberOfCells = numb
    }
    
    
    private func getAllMixtapes() {
        if let context = container?.viewContext {
            context.perform {
                let request: NSFetchRequest<Mixtape> = Mixtape.fetchRequest()
                
                //Get full list of Active mixtapes
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
    
    
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.view.backgroundColor = .white
        navigationItem.title = "Mixtapes"
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCatalogueCell.identifier, for: indexPath) as! MusicCatalogueCell
        cell.tag = indexPath.row
        cell.mixtape = mixtapes?[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell: \(indexPath.row)")
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MusicCollectionHeader.identifier, for: indexPath) as! MusicCollectionHeader
        //header.sectionNames = sectionNames
        //print("IN HEADER: Count: ", yourListMix?.count ?? 0)
        
        // Send all 3 array of mixtapes (New Releases, Recently Played, Your list)
        header.newReleasesMix = newReleasesMix
        header.recentlyPlayedMix = recentlyPlayedMix
        header.yourListMix = yourListMix
        
        // Here we must realod all the Header Lists and Cell
        header.reloadAllData()
        return header
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 20)) / 2
        let itemSize2 = (collectionView.frame.width) / 2
        return CGSize(width: itemSize2, height: itemSize2 + 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let currentHeight = CGFloat(260 * numberOfCells + 80)
        return CGSize(width: collectionView.frame.width, height: currentHeight)
    }
    
    
}







