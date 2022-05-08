//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tornike Bardadze on 08.05.22.
//
//For this project we need 3 extra librarys so we need to create 1 extra file in project
//For text editor use which editor you want for ex (visual studio)
//We need to create file Podfile
//Then open terminal : cd in project directory: cd/developers/weatherApp then command pod init to initiallize pod file
//In pod file we are gonna use 3 librarys  :    pod 'Alamofire', '~> 4.7' , pod 'SwiftyJSON', '~> 4.0', pod 'NVActivityIndicatorView'
//Then pod install and open Weather.xcworkspace and import libraries

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
//To get user's location, we need to add items in Info.plist
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    //We declare constant for color changes
    let gradientLayer = CAGradientLayer()
    
    
    //For weather api i use openweathermap.org
    let apiKey = "822494d08864feb81be37b199286e214"
    var lat = 11.344533
    var lon = 104.33322
    //for the loading dialog box, we request make requests of the internet
    var activityIndicator: NVActivityIndicatorView!
    //to handle getting users location
    var locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2,
                                    y: (view.frame.height-indicatorSize)/2,
                                    width: indicatorSize,
                                    height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame,
                                                    type: .lineScale,
                                                    color: UIColor.white,
                                                    padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBlueBackgroundGradient()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON {
             response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.locationLabel.text = jsonResponse["name" ].stringValue
                self.conditionImageView.image = UIImage(named: iconName)
                self.conditionLabel.text = jsonWeather["main"].stringValue
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = dateFormatter.string(from: date)
                
                let suffix = iconName.suffix(1)
                if (suffix == "d") {
                    self.setGreyBackgroundGradient()
                } else {
                    self.setBlueBackgroundGradient()
                }
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
        
    // two func for background changes gradient
    func setBlueBackgroundGradient() {
        let topColor = UIColor(red: 95.0/255.0,
                               green: 165.0/255.0,
                               blue: 1.0,
                               alpha: 1.0).cgColor
        
        let bottomColor = UIColor(red: 72.0/255.0,
                                  green: 114.0/255.0,
                                  blue: 184.0/255.0,
                                  alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor,bottomColor]
    }
    
    func setGreyBackgroundGradient() {
        let topColor = UIColor(red: 151.0/255.0,
                               green: 151.0/255.0,
                               blue: 151.0/255.0,
                               alpha: 1.0).cgColor
        
        let bottomColor = UIColor(red: 72.0/255.0,
                                  green: 72.0/255.0,
                                  blue: 72.0/255.0,
                                  alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor,bottomColor]
    }
    
    
}

