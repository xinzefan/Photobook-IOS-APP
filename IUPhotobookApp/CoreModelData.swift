//Ahmann, Heather (hahmann@iu.edu)
//Brooks, Travis (trabrook@iu.edu)
//Fan, Xinze (xinzfan@iu.edu)
//Juline, Alvin (ajuline@iu.edu)
import UIKit
import CoreData

class CoreModelData: NSObject {
    
    
    static let shared = CoreModelData()
    // get NSManagedObjectContext in AppDelegate
    let app = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = {
        let context = app.persistentContainer.viewContext
        return context
    }()
   
//    // update data
    private func saveContext() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
//    // add data for Poem
    func saveDataWith(id:String,title: String, descrip: String ,longitude:String, latitude:String,image:Data) {
        let model = NSEntityDescription.insertNewObject(forEntityName: "LocationData", into: context) as! LocationData
        model.id = id
        model.title = title
        model.descrip = descrip
        model.longitude = longitude
        model.latitude = latitude
        model.image = image
        //保存
        do {
            try context.save()
        } catch {
            fatalError("error:\(error)")
        }
    }
    
    
    func saveSettingsData(background1: String, background2: String, currentTheme: Int64, themeDescription: String){
        
        let model = NSEntityDescription.insertNewObject(forEntityName: "Settings", into: context) as! Settings
        
        model.background1 = background1
        model.background2 = background2
        model.currentTheme = currentTheme
        model.themeDescription = themeDescription
        
        
        do {
            try context.save()
        } catch {
            fatalError("error:\(error)")
        }
    }
    
//    // receive all data for poem
    func getAllData() -> [LocationData] {
        let fetchRequest: NSFetchRequest = LocationData.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            print(result.count)
            return result
        } catch {
            fatalError();
        }
    }
    
//    // receive all data for poem
    func getAllSettingsData() -> [Settings] {
        let fetchRequest: NSFetchRequest = Settings.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            print("result count: " , result.count)
            return result
        } catch {
            fatalError();
        }
    }
    

    // delete according to time
    func deleteWith(id:String) {
//    func deleteWith(describe: String) {
        let fetchRequest: NSFetchRequest = LocationData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                context.delete(data)
            }
        } catch {
            fatalError();
        }
        do {
            try context.save()
        } catch {
            fatalError("error:\(error)")
        }
    }
    // delete all
    func deleteAllPerson() {
        let result = getAllData()
        for person in result {
            context.delete(person)
        }
        do {
            try context.save()
        } catch {
            fatalError("error:\(error)")
        }
    }
    // edit data
    func changePersonWith(id:String,title: String,  discreption: String, longitude: String ,latitude:String,image:Data) {
        let fetchRequest: NSFetchRequest = LocationData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                if data.id == id {
                    data.title = title
                    data.descrip = discreption
                    data.longitude = longitude
                    data.latitude = latitude
                    data.image = image
                }
                
            }
        } catch {
            fatalError();
        }
        do {
            try context.save()
        } catch {
            fatalError("error:\(error)")
        }
    }
    
    // edit settings data (we will only be changing what the current theme is)
    func changeSettingWith(background1: String, background2: String, currentTheme: Int64, themeDescription: String) {
        let fetchRequest: NSFetchRequest = Settings.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "background1 == %@", background1)
        do {
            let result = try context.fetch(fetchRequest)
            for data in result {
                if data.background1 == background1 {
                    data.currentTheme = currentTheme
                    
                }
                data.themeDescription = themeDescription
            }
        } catch {
            fatalError();
        }
        do {
            try context.save()
        } catch {
            fatalError("error:\(error)")
        }
    }



}
