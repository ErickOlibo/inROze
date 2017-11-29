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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        navigationController?.navigationBar.tintColor = Colors.logoRed
        print(listOfCities)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Change City Cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = listOfCities[indexPath.row].name
        cell.accessoryType = listOfCities[indexPath.row].current ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.none {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            
            let newCityCode = listOfCities[indexPath.row].code
            UserDefaults().currentCityCode = newCityCode
            for index in 0..<listOfCities.count {
                listOfCities[index].current = false
            }
            listOfCities[indexPath.row].current = true
            tableView.reloadData()
        }
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
