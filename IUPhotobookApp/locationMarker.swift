//
//  MoreController.swift
//  Lab27Xcode
//
//  Created by xinze fan on 4/19/19.
//  Copyright © 2019 C323 Spring 2019 - trabrook. All rights reserved.
//

import UIKit

protocol locationMarkerDelegate {
    func reloadDataWithModel()
}

class locationMarker: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    var model:LocationData?
    var delegate : locationMarkerDelegate?
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var backImageBtn: UIButton!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configDataWithModel()

        settings = CoreModelData.shared.getAllSettingsData()
    }
    
    @IBAction func Back(_ sender: Any) {
        
    }
    @IBAction func clickBtnAction(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            // eidt photo
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            picker.delegate = self;
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
            break
        case 20:
            // start to eidt
            guard let imageData = self.imageData else {
                return
            }
            if let id = self.model?.id,!id.isEmpty {
                CoreModelData.shared.changePersonWith(id: id, title: self.model?.title ?? "", discreption: self.model?.descrip ?? "", longitude: self.model?.longitude ?? "", latitude: self.model?.latitude ?? "", image: imageData)
                self.delegate?.reloadDataWithModel()
            }
            break
        default:
            break
        }
    }
    // click back button's action
    @objc func backToPrevious(){
        if let nvc = self.imageNavigationVC {
            nvc.popViewController(animated: true)
        }
    }
    
    func configImageWithHeader(_ image:UIImage) {
        
        if let imageChangeData = image.jpegData(compressionQuality: 1.0) {
            self.backImageBtn.setBackgroundImage(image, for: .normal)
            imageData = imageChangeData
        }
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
    private func configDataWithModel() {
        self.titleNameLabel.text = self.model?.title
        if let imageData = self.model?.image {
            if let image = UIImage(data: imageData) {
                self.backImageBtn.setBackgroundImage(image, for: .normal)
            }
        }
        self.detailNameLabel.text = self.model?.descrip
        
    }
    
    @IBOutlet weak var editPicButton: UIButton!
    
    
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
        
        var redStr = ""
        redStr.append(String(red!))
        
        var greenStr = ""
        greenStr.append(String(green!))
        
        var blueStr = ""
        blueStr.append(String(blue!))
        
        let redInt = Int(redStr)
        let greenInt = Int(greenStr)
        let blueInt = Int(blueStr)
        
        //NOW COLOR THEM
        
        let crimson = UIColor(red: CGFloat(CGFloat(redInt!)/255), green:CGFloat(CGFloat(greenInt!)/255), blue: CGFloat(CGFloat(blueInt!)/255), alpha: 1)
        
        let cream = UIColor(red: 237, green: 235, blue: 235, alpha: 1)
        
        titleNameLabel.textColor = cream
        titleNameLabel.backgroundColor = crimson
        
        self.view.backgroundColor = crimson
        
        backImageBtn.setTitleColor(crimson, for: .normal)
        backImageBtn.backgroundColor = cream
        
        detailNameLabel.textColor = cream
        detailNameLabel.backgroundColor = crimson
        
        editPicButton.setTitleColor(crimson, for: .normal)
        editPicButton.backgroundColor = cream
        
        hintLabel.textColor = cream
        hintLabel.backgroundColor = crimson
        
    }
    

}

