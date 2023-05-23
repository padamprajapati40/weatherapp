//
//  HomeVC.swift
//  WeatherApp
//
//  Created by Padam on 23/05/23.
//

import UIKit

class HomeVC: BaseVC, UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.retriveFavoriteLocation(searchText: self.searchController.searchBar.text ?? "") { locations in
            DispatchQueue.main.async {
                self.tblCityList.reloadData()
            }
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tblCityList: UITableView!
    let viewModel = HomeVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.tblCityList.dataSource = self
        self.tblCityList.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tblCityList.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.retriveFavoriteLocation { locations in
            DispatchQueue.main.async {
                self.tblCityList.reloadData()
            }
        }
    }
    
    @IBAction func addLocationBtnTapped(sender: UIBarButtonItem) {
        let selectLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationVC") as! SelectLocationVC
        self.navigationController?.pushViewController(selectLocationVC, animated: true)
    }
    @IBAction func settingsBtnTapped(sender: UIBarButtonItem) {

    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
      

        
    }
}


extension HomeVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        cell.lblLocationName.text = self.viewModel.arrLocation[indexPath.row].cityName
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.removeLocation(for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "WeatherDetailVC") as! WeatherDetailVC
        weatherDetailVC.selectedLocation = self.viewModel.arrLocation[indexPath.row]
        self.navigationController?.pushViewController(weatherDetailVC, animated: true)
    }
    
    func removeLocation(for indexPath: IndexPath) {
        //Create the alert controller and actions
        let alert = UIAlertController(title: "Remove Location", message: "Are you sure wants to delete?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                self.viewModel.removeLocation(location: self.viewModel.arrLocation[indexPath.row]) { success in
                    DispatchQueue.main.async {
                        self.tblCityList.reloadData()
                    }
                }
            }
        }

        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        //Present the alert controller
        present(alert, animated: true, completion: nil)
    }
    
}
