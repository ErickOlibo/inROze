//
//  MusicViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 04/01/2018.
//  Copyright © 2018 Erick Olibo. All rights reserved.
//

import UIKit
import CoreData
import LNPopupController

//private let reuseIdentifier = "Cell"

class MusicViewController: UICollectionViewController {
    
    
    // Core Data model container and context
    var container: NSPersistentContainer? = AppDelegate.appDelegate.persistentContainer
    let mainContext = AppDelegate.viewContext
    
    
    // Outlets
    @IBOutlet weak var searchCatalogueButton: UIBarButtonItem!
    
    // Actions
    @IBAction func searchCatalogueTouched(_ sender: UIBarButtonItem) {
        //searchIconPressed()
    }
    

    // properties
    var mixtapes: [Mixtape]? //{ didSet { print("Total Mixtapes: \(mixtapes?.count ?? 0)") } }
    
    var recentlyPlayedMix: [Mixtape]?
    var newReleasesMix: [Mixtape]?
    var yourListMix: [Mixtape]?
    var numberOfCells: Int = 0
    
    
    // VIEW life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCatalogueButton.tintColor = Colors.logoRed
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        setupNavBar()
        updateThreeMixCellsAndCollections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Add listener for MixtapePlayerVC
        NotificationCenter.default.addObserver(self, selector: #selector(noticeFromMusicPlayer), name: NSNotification.Name(rawValue: NotificationFor.playerDidChangeFollowStatus), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noticeFromPlayedList), name: NSNotification.Name(rawValue: NotificationFor.userDidChangeRecentlyPlayedList), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noticeFromPlayedList), name: NSNotification.Name(rawValue: NotificationFor.serverRequestDoneUpdating), object: nil)
        updateThreeMixCellsAndCollections()
        print("yourList [\(yourListMix?.count ?? 0)] - New [\(newReleasesMix?.count ?? 0)] - Recent [\(recentlyPlayedMix?.count ?? 0)]")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationFor.playerDidChangeFollowStatus), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationFor.userDidChangeRecentlyPlayedList), object: nil)
    }
    
    
    // Methods
    
    @objc private func noticeFromMusicPlayer() {
        //print("NoticeFromMusicPlayer")
        updateThreeMixCellsAndCollections()
    }
    
    @objc private func noticeFromPlayedList() {
        updateThreeMixCellsAndCollections()
    }
    
    
    // UPdate all 3 mixCells and the collections inside
    private func updateThreeMixCellsAndCollections() {
        otherMixtapes()
        getAllMixtapes()
        
    }
    
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
        //print("Get ALL Mixtapes - from notification TOO")
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
    
    
    private func loadAndPlayMixtape(mixtape: Mixtape) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationFor.dismissCurrentMixtapeVC), object: nil)
        let popupContentController = storyboard?.instantiateViewController(withIdentifier: "MixtapePlayerViewController") as! MixtapePlayerViewController
        let tabBarVC = tabBarController as! TabBarViewController
        
        popupContentController.player = tabBarVC.sharedPlayer
        popupContentController.mixtape = mixtape
        popupContentController.tabBarVC = tabBarVC
        tabBarController?.presentPopupBar(withContentViewController: popupContentController, animated: true, completion: nil)
        tabBarController?.popupBar.imageView.layer.cornerRadius = 5
        tabBarController?.popupBar.imageView.layer.borderWidth = 0.333
        tabBarController?.popupBar.imageView.layer.borderColor = UIColor.black.cgColor
        //tabBarController?.popupBar.progressViewStyle = .top
        //tabBarController?.popupBar.tintColor = Colors.logoRed
    }
    
    
    
}

// PREPARE FOR SEQUE
extension MusicViewController
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Music To Search Catalogue") {
            guard let destination = segue.destination as? SearchCatalogueViewController else { return }
            destination.isForCatalogue = true
            destination.navigationItem.title = "Catalogue"
        }
        if (segue.identifier == "Music To View Your List") {
            guard let destination = segue.destination as? SearchCatalogueViewController else { return }
            destination.isForCatalogue = false
            destination.navigationItem.title = "Your List"
        }
    }
}


extension MusicViewController: SetMusicPlayerDelegate
{
    func didTapCellForMixtape(mixtape: Mixtape) {
        loadAndPlayMixtape(mixtape: mixtape)
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
        guard let mixtape = mixtapes?[indexPath.row] else { return }
        loadAndPlayMixtape(mixtape: mixtape)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MusicCollectionHeader.identifier, for: indexPath) as! MusicCollectionHeader
        header.musicDelegate = self

        header.newReleasesMix = newReleasesMix
        header.recentlyPlayedMix = recentlyPlayedMix
        header.yourListMix = yourListMix
        
        header.reloadAllData()
        return header
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize2 = (collectionView.frame.width) / 2
        return CGSize(width: itemSize2, height: itemSize2 + 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let currentHeight = CGFloat(260 * numberOfCells + 80)
        return CGSize(width: collectionView.frame.width, height: currentHeight)
    }
    
    
}







