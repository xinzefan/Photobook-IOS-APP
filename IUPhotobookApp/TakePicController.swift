//
//  SecondViewController.swift
//  Lab27Xcode
//
//  Created by Brooks, Travis Raleigh on 4/16/19.
//  Copyright © 2019 C323 Spring 2019 - trabrook. All rights reserved.
//

// THIS IS CONNECTED TO THE TakePic TAB

import UIKit
//import PhotosUI
//import MobileCoreServices
import CoreLocation

class TakePicController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate {
    
    var settings = [Settings]()
    
    
  private lazy var leftBtn:UIButton = {
        var leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: "return"), for: UIControl.State.normal)
        leftBtn.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
        leftBtn.addTarget(self, action: #selector(backToPrevious), for: UIControl.Event.touchUpInside)
        return leftBtn
    }()
    
    private var imageNavigationVC:UINavigationController?
    private var imageData:Data?
    private let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D? = nil
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var currentPlace: UITextField!
    @IBOutlet weak var informationTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.update_location()
        
        pictureView.image = UIImage(named:"apple")
        
        settings = CoreModelData.shared.getAllSettingsData()
        
    }
    func update_location() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func capturePicture(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        picker.delegate = self;
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func addPicture(_ sender: Any) {
        
        // save the data or back to the hometab or clean all data
        guard let imageData = self.imageData else {
            return
        }
        guard let name = self.currentPlace.text,!name.isEmpty else {
            return
        }
        guard let information = self.informationTextField.text,!information.isEmpty else {
            return
        }
        guard let longitude = self.location?.longitude else {
            return
        }
        guard let latitude = self.location?.latitude else {
            return
        }
        let id = self.stringNowTimeStamp() + self.getRandomStringOfLength(length: 15)
        CoreModelData.shared.saveDataWith(id: id, title: name, descrip: information, longitude: String(format: "%f", longitude), latitude: String(format: "%f", latitude), image: imageData)
        let notificationSuccessName = Notification.Name(rawValue: "gobackSuccessVC")
        NotificationCenter.default.post(name: notificationSuccessName, object: self,
                                        userInfo: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // click back button action
    @objc func backToPrevious(){
        if let nvc = self.imageNavigationVC {
            nvc.popViewController(animated: true)
        }
    }
    
    func configImageWithHeader(_ image:UIImage) {
        
        if let imageChangeData = image.jpegData(compressionQuality: 1.0) {
            pictureView.image = image
            imageData = imageChangeData
        }
    }
    // return the current timestamp
    private func stringNowTimeStamp() -> String {
        let now = Date()
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// get the random letter
    ///
   // length: required length
   private func getRandomStringOfLength(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var ranStr = ""
        for _ in 0..<length {
            
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            ranStr.append(characters[characters.index(characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image:UIImage? = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        if (image == nil )
        {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        
        guard let oldImage = image else {
            return
        }
        configImageWithHeader(oldImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.imageNavigationVC = navigationController
        
        if navigationController.viewControllers.count > 1 {
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                         action: nil)
            spacer.width = -10
            viewController.navigationItem.leftBarButtonItems = [spacer, UIBarButtonItem(customView: leftBtn)]
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let firstLocation = locations.first {
            self.location = firstLocation.coordinate
        }
    }
    
    @IBOutlet weak var goToGalleryButton: UIButton!
    //@IBOutlet weak var placeNameField: UITextField!
    @IBOutlet weak var placeInfoField: UITextField!
    @IBOutlet weak var addPicButton: UIButton!
    
    
    //Used for theme
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //FIRST GET COLORS
        let currentTheme = settings[0].currentTheme
        
        let aTheme = settings[Int(currentTheme)]
        
        let str = aTheme.background1
        
        let redEnd = str?.index((str?.startIndex)!, offsetBy: 2)
        let red = str?[...redEnd!]
        
        let greenStartIndex = str?.index((str?.startIndex)!, offsetBy: 4)
        let greenEndIndex = str?.index((greenStartIndex ?? nil)!, offsetBy: 2)
        let green = str?[greenStartIndex!...greenEndIndex!]
        
        let blueStartIndex = str?.index((greenEndIndex ?? nil)!, offsetBy: 2)
        let blueEndIndex = str?.index((blueStartIndex ?? nil)!, offsetBy: 2)
        let blue = str?[blueStartIndex!...blueEndIndex!]
        
        print("Red: \(red) \nGreen: \(green) \nBlue: \(blue)" )
        
        var redStr = ""
        redStr.append(String(red!))
        
        var greenStr = ""
        greenStr.append(String(green!))
        
        var blueStr = ""
        blueStr.append(String(blue!))
        
        var redInt = Int(redStr)
        var greenInt = Int(greenStr)
        var blueInt = Int(blueStr)
        
        //NOW COLOR THEM
        
        let crimson = UIColor(red: CGFloat(CGFloat(redInt!)/255), green:CGFloat(CGFloat(greenInt!)/255), blue: CGFloat(CGFloat(blueInt!)/255), alpha: 1)
        
        let cream = UIColor(red: 237, green: 235, blue: 235, alpha: 1)
        
        self.view.backgroundColor = crimson
        
        pictureView.backgroundColor = cream
        
        goToGalleryButton.setTitleColor(crimson, for: .normal)
        goToGalleryButton.backgroundColor = cream
        
        currentPlace.backgroundColor = cream
        currentPlace.textColor = crimson
        
        placeInfoField.backgroundColor = cream
        placeInfoField.textColor = crimson
        
        addPicButton.setTitleColor(crimson, for: .normal)
        addPicButton.backgroundColor = cream
        
    }
    
    
}
