//
//  TableViewController.swift
//  Lab27Xcode
//
//  Created by xinze fan on 4/18/19.
//  Copyright © 2019 C323 Spring 2019 - trabrook. All rights reserved.
//
import UIKit

class TableViewController: UITableViewController, locationMarkerDelegate{
    
    
    func reloadDataWithModel() {
    
    }

    var settings = [Settings]()
    
    var currentModel:LocationData?
    
    var objects = [LocationData]() // get the data
    override func viewDidLoad() {
        super.viewDidLoad()
        settings = CoreModelData.shared.getAllSettingsData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configChange()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //according to the segue to check the action
        if segue.identifier == "suggestionToDetail" {
            let controller = segue.destination as! locationMarker
            controller.model = self.currentModel
            controller.delegate = self
            print("bye!")
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let model = objects[indexPath.row]
        cell.textLabel!.text = String(format: "%@: %@", model.title ?? "", model.descrip ?? " ")//model.longitude ?? "",model.latitude ?? "")
        
        //ADJUST CELLS TO THEME
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
    
        cell.backgroundColor = crimson
        cell.textLabel?.textColor = cream
        
        self.view.backgroundColor = crimson
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.currentModel = objects[indexPath.row]
        performSegue(withIdentifier: "suggestionToDetail", sender: true)
        
    }
    
    

    private func configChange() {
        // get all data that was saved by the app
        objects.removeAll()
        objects = CoreModelData.shared.getAllData()
        tableView.reloadData()
    }
}
