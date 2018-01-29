//
//  ChangeCityViewController.swift
//  InRoZe
//
//  Created by Erick Olibo on 27/11/2017.
//  Copyright © 2017 Erick Olibo. All rights reserved.
//

import UIKit

class ChangeCityViewController: UITableViewController {

    
    // Properties
    //let listCities = availableCities()
    var listOfCities = listCitiesInfo()
    
    // Outlets
    @IBOutlet weak var changeCityHeaderView: UIView!
    @IBOutlet weak var selectedCity: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        navigationController?.navigationBar.tintColor = Colors.logoRed
        //navigationItem.title = currentCity.name.rawValue
        tableView.separatorStyle = .none
        updateCityImage()
    }
    
    
    private func updateCityImage() {
        let city = currentCity.name.rawValue
        navigationItem.title = city
        selectedCity.image = UIImage(named: city)?.withRenderingMode(.alwaysOriginal)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Change City Cell", for: indexPath)
        cell.selectionStyle = .none
        let isSelected = listOfCities[indexPath.row].current
        let fontName = isSelected ? "HelveticaNeue-Bold" : "HelveticaNeue"
        let textFont = UIFont(name: fontName, size: 22)
        cell.textLabel?.font = textFont
        cell.textLabel?.textColor = isSelected ? Colors.logoRed : .black
        cell.textLabel?.text = listOfCities[indexPath.row].name
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newCityCode = listOfCities[indexPath.row].code
        UserDefaults().currentCityCode = newCityCode
        for index in 0..<listOfCities.count {
            listOfCities[index].current = false
        }
        listOfCities[indexPath.row].current = true
        tableView.reloadData()
        updateCityImage()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
