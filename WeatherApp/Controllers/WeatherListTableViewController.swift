//
//  WeatherListTableViewController.swift
//  WeatherApp
//
//  Created by Veerababu Mulugu on 29/05/23.
//


import CoreLocation
import GooglePlaces
import UIKit

class WeatherListTableViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    private var locationViewModel = LocationViewModel()
    private var weatherListViewModel: WeatherListViewModel?
    private var weatherData: [WeatherResponseData] = []
    
    private var lastUnitSelection: Unit = .celsius
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        setUpModels()
        
        let userDefaults = UserDefaults.standard
        if let value = userDefaults.value(forKey: "unit") as? String {
            lastUnitSelection = Unit(rawValue: value) ?? .celsius
        }
        
        if weatherListViewModel?.locality.isEmpty ?? true {
            weatherListViewModel?.getLocalCityName()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddWeatherCityViewController" {
            guard let autocompleteController = GMSAutocompleteViewController() as GMSAutocompleteViewController? else {
                return
            }
            
            autocompleteController.delegate = self
            // Configure autocompleteController as needed
            present(autocompleteController, animated: true, completion: nil)
            
        } else if segue.identifier == "SettingsTableViewController" {
            guard let nav = segue.destination as? UINavigationController,
                  let settingsTVC = nav.viewControllers.first as? SettingsTableViewController else {
                fatalError("SettingsTableViewController not found")
            }
            
            settingsTVC.delegate = self
        }
    }
    
    private func setUpModels() {
        let webService = WebServiceReal(baseUrlString: Constants.baseUrl, appId: Constants.appId)
        let weatherService = WeatherServiceReal(webService: webService)
        let viewModel = WeatherListViewModel(service: weatherService, currentLocation: locationViewModel.currentLocation)
        weatherListViewModel = viewModel
        
        weatherListViewModel?.onData = { [weak self] data in
            guard let self = self else { return }
            
            let hasName = self.weatherData.contains { $0.name?.capitalized == data.name?.capitalized }
            if !hasName {
                self.weatherData.append(data)
                self.reloadTableView()
            }
        }
        
        weatherListViewModel?.onError = { [weak self] title, message in
            self?.showErrorAlert(title: title, message: message)
        }
        
        weatherListViewModel?.getLocalWeather()
        
        weatherListViewModel?.onError = { [weak self] title, message in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(alert, animated: true)
            }
        }
    
        locationViewModel.onError = { [weak self] title, message in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(alert, animated: true)
        }
        
        locationViewModel.setupLocationManager()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        present(alert, animated: true)
    }
}

extension WeatherListTableViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if let locality = place.name {
            weatherListViewModel?.getWeatherForCity(city: locality)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        showErrorAlert(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension WeatherListTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatherdataCell = tableView.dequeueReusableCell(withIdentifier: "CityWeatherDataTableViewCell", for: indexPath) as? CityWeatherDataTableViewCell else {
            return UITableViewCell()
        }
        
        weatherdataCell.imgAtmosphere.image = nil
        let weatherResponse = weatherData[indexPath.row]
        weatherdataCell.lblCityName.text = weatherResponse.name ?? ""
        weatherdataCell.updateCityWeatherData(weatherData: weatherResponse)
        
        return weatherdataCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}

extension WeatherListTableViewController: SettingsDelegate {
    func settingsDone(vm: SettingsViewModel) {
        if lastUnitSelection.rawValue != vm.selectedUnit.rawValue {
            weatherListViewModel?.updateUnit(to: vm.selectedUnit)
            tableView.reloadData()
            lastUnitSelection = Unit(rawValue: vm.selectedUnit.rawValue) ?? .celsius
        }
    }
}
