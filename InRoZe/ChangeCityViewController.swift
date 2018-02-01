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
    var spinner: UIActivityIndicatorView!
    var subtitle: UILabel!
    var foreGroundView: UIView!
    var smallSquareView: UIView!
    let squareSide: CGFloat = 200.0
    
    // Outlets
    @IBOutlet weak var changeCityHeaderView: UIView!
    @IBOutlet weak var selectedCity: UIImageView!
    
    
    // View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        navigationController?.navigationBar.tintColor = Colors.logoRed
        //navigationItem.title = currentCity.name.rawValue
        tableView.separatorStyle = .none
        updateCityImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: NotificationFor.serverRequestDoneUpdating), object: nil)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // remove Notification Observer
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationFor.serverRequestDoneUpdating), object: nil)
    }
    
    
    
    
    // Methods
    @objc private func updateUI() {
        //print("Done Updating From Server")
        DispatchQueue.main.async { [unowned self] in
            self.spinner.stopAnimating()
            for subView in self.foreGroundView.subviews {
                subView.removeFromSuperview()
            }
            self.foreGroundView.removeFromSuperview()
            self.tableView.reloadData()
            self.updateCityImage()
        }
        
        
    }
    
    private func fetchNewCityFromServer() {
        if (!UserDefaults().isLoggedIn) {
            //print("USER IS LOG IN AND IM FETCHING SERVER")
            RequestHandler().fetchEventIDsFromServer()
        } else {
            UserDefaults().isLoggedIn = false
        }
    }
    
    private func activateForeGroundAndSpinner() {
        
        let screenHeight = CellSize.phoneSizeHeight
        let screenWidth = CellSize.phoneSizeWidth
        let smallSquareX = (screenWidth - squareSide) / 2
        let smallSquareY = (screenHeight - squareSide) / 2
    
        foreGroundView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        foreGroundView.backgroundColor = UIColor.clear
        
        smallSquareView = UIView(frame: CGRect(x: smallSquareX, y: smallSquareY, width: squareSide, height: squareSide))
        smallSquareView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        smallSquareView.layer.cornerRadius = 20.0
        
        subtitle = UILabel(frame: CGRect(x: smallSquareX, y: (screenHeight / 2) + 30, width: squareSide, height: 20))
        let fontName = "HelveticaNeue-Medium"
        let textFont = UIFont(name: fontName, size: 17)
        subtitle.textColor = .white
        subtitle.font = textFont
        subtitle.text = "Loading..."
        subtitle.textAlignment = .center
        //foreGroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.center = foreGroundView.center
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        foreGroundView.addSubview(smallSquareView)
        foreGroundView.addSubview(spinner)
        foreGroundView.addSubview(subtitle)
        //self.view.addSubview(foreGroundView)
        UIApplication.shared.keyWindow!.addSubview(foreGroundView)
        
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
        let curCityCode = UserDefaults().currentCityCode
        let newCityCode = listOfCities[indexPath.row].code
        if (curCityCode == newCityCode) {
            //print("SAME City")
        } else {
            //print("DIFFERENT City")
            UserDefaults().currentCityCode = newCityCode
            activateForeGroundAndSpinner()
            fetchNewCityFromServer()
            //print("After FetchRequestFromServer")
            
            
            for index in 0..<listOfCities.count {
                listOfCities[index].current = false
            }
            listOfCities[indexPath.row].current = true
            //tableView.reloadData()
            //updateCityImage()
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
