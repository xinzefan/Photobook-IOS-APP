//
//  AppDelegate.swift
//  Lab27Xcode
//
//  Created by Brooks, Travis Raleigh on 4/16/19.
//  Copyright © 2019 C323 Spring 2019 - trabrook. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var settings = [Settings]()
    var locations = [LocationData]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        settings = CoreModelData.shared.getAllSettingsData()
        locations = CoreModelData.shared.getAllData()
        
        // When app is initialized, load in themes
        if settings.count == 0{
            
            //Crimson and Cream
            CoreModelData.shared.saveSettingsData(background1: "169 005 051", background2: "237 235 235", currentTheme: 0, themeDescription: "Cream and Crimson")
            //Light Crimson and Cream
            CoreModelData.shared.saveSettingsData(background1: "237 023 076", background2: "237 235 235", currentTheme: 0, themeDescription: "Light Cream and Crimson")
            //Dark Crimson and Cream
            CoreModelData.shared.saveSettingsData(background1: "119 013 041", background2: "237 235 235", currentTheme: 0, themeDescription: "Dark Cream and Crimson")
            
            settings = CoreModelData.shared.getAllSettingsData()
        }
        
        // When app is initialized, load in preset locations
        if locations.count == 0{
        
        //DUNN MEADOW
            let dunnMeadowImage = UIImage(named: "dunnMeadow.JPG")
            let dMImageData = dunnMeadowImage?.jpegData(compressionQuality: 1.0)
            let titleName = "Dunn Meadow"
            let description = "A meadow where you can see frisbys, dogs, a river, and more!"
            let longitude = "-86.525230"
            let latitude = "39.168246"
            let id = "dunnMeadow"
            
            CoreModelData.shared.saveDataWith(id: id, title: titleName, descrip: description, longitude: longitude, latitude: latitude, image: dMImageData!)
            
        //LGBTQ+
            let lGBTQ = UIImage(named: "LGBTQ.JPG")
            let lGBTQImageData = lGBTQ?.jpegData(compressionQuality: 1.0)
            let titleName2 = "LGBTQ+"
            let description2 = "IU is a very accepting place! Come make your own memories with IU!!!"
            let longitude2 = "-86.525243"
            let latitude2 = "39.168583"
            let id2 = "LGBTQ"
            
            CoreModelData.shared.saveDataWith(id: id2, title: titleName2, descrip: description2, longitude: longitude2, latitude: latitude2, image: lGBTQImageData!)
            
        //Random Swing Set
            let swingImage = UIImage(named: "swing.JPG")
            let swingImageData = swingImage?.jpegData(compressionQuality: 1.0)
            let titleName3 = "Swing :)"
            let description3 = "One time I was walking along a street and saw this random swing... I was swinging and swinging, and then the owner came home... Instead of kicking me off, he gave me a push!!!"
            let longitude3 = "-86.531685"
            let latitude3 = "39.174068"
            let id3 = "swing"
            
            CoreModelData.shared.saveDataWith(id: id3, title: titleName3, descrip: description3, longitude: longitude3, latitude: latitude3, image: swingImageData!)
        
            
        }
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }




    lazy var persistentContainer: NSPersistentContainer = {
        
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            })
        return container
        }()

// MARK: - Core Data Saving support

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

}

