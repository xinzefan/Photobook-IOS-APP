//
//  SettingsViewController.swift
//  IUPhotobookApp
//
//  Created by Brooks, Travis Raleigh on 4/29/19.
//  Copyright © 2019 C323 Spring 2019 - trabrook. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var settings = [Settings]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings = CoreModelData.shared.getAllSettingsData()
        // Do any additional setup after loading the view.
    }
    
    
    //Labels/Buttons
    @IBOutlet weak var themeDescriptionLabel: UILabel!
    @IBOutlet weak var themeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBAction func changeThemeButton(_ sender: Any) {
        print(settings[0])
        //Change the current theme in each settings object
        //currentTheme keeps track of which theme is currently being displayed and will be the same value in each instance in settings
        for theme in settings{
            
            //if theme.currentTheme == 2 {
            if theme.currentTheme == settings.count - 1{
                CoreModelData.shared.changeSettingWith(background1: theme.background1 ?? "", background2: theme.background2 ?? "", currentTheme: Int64(0), themeDescription: theme.themeDescription ?? "")
                
            }
            else{
                CoreModelData.shared.changeSettingWith(background1: theme.background1 ?? "", background2: theme.background2 ?? "", currentTheme: Int64(theme.currentTheme + 1), themeDescription: theme.themeDescription ?? "")
            }
        }
        
        //Change theme of buttons, background, etc!
        
        //FIRST GET COLORS
        //it doesn't matter which object in settings[] you get the number currentTheme from
        let currentTheme = settings[0].currentTheme
        
        //aTheme is the theme that's being/going to be displayed
        let aTheme = settings[Int(currentTheme)]
        
        //str is the list of color values for background1: the backgrounf of the app
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
        print(settings)
        
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
        
        themeDescriptionLabel.textColor = cream
        themeDescriptionLabel.backgroundColor = crimson
        themeDescriptionLabel.text = settings[Int(settings[0].currentTheme)].themeDescription
        
        self.view.backgroundColor = crimson
        
        themeButton.setTitleColor(crimson, for: .normal)
        themeButton.backgroundColor = cream
        
        backButton.setTitleColor(crimson, for: .normal)
        backButton.backgroundColor = cream
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(settings[0])
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
        //The names crimson and cream come from the original themes
        let crimson = UIColor(red: CGFloat(CGFloat(redInt!)/255), green:CGFloat(CGFloat(greenInt!)/255), blue: CGFloat(CGFloat(blueInt!)/255), alpha: 1)
        
        let cream = UIColor(red: 237, green: 235, blue: 235, alpha: 1)
        
        themeDescriptionLabel.textColor = cream
        themeDescriptionLabel.backgroundColor = crimson
        themeDescriptionLabel.text = settings[Int(settings[0].currentTheme)].themeDescription

        self.view.backgroundColor = crimson
        
        themeButton.setTitleColor(crimson, for: .normal)
        themeButton.backgroundColor = cream
        
        backButton.setTitleColor(crimson, for: .normal)
        backButton.backgroundColor = cream
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
