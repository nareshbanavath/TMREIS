//
//  CoreDataManager.swift
//  TMREIS
//
//  Created by naresh banavath on 28/05/21.
//
enum CoreDataEntity : String {
  case Schools_Entity
}
import Foundation
import CoreData
class CoreDataManager
{
    static var manager = CoreDataManager()
       // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TMREISDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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

  func saveEntityData<T : Codable>(data : T , entityName : CoreDataEntity){
    guard let statusData = try? JSONEncoder().encode(data)  else {return}
    let statStr = String(data: statusData, encoding: .utf8)
    let context = persistentContainer.viewContext
//    let entity = NSEntityDescription.entity(forEntityName: entityName.rawValue, in: context)!
    switch entityName {
    case .Schools_Entity:
      print("schools")
      
      let schools = Schools_Entity(context: context)
      schools.strData = statStr
      saveContext()
    default:
      print("default")
    }
//    let ptmsMaster = PTMSMaster(entity : entity , insertInto : context)
//    ptmsMaster.taskStatuses = statStr
    
    do{
      try context.save()
    }catch let err{
      print(err)
    }
  }
    
//    func getWorkOfficeData() -> (OfficeCoordinatesStruct , WorkAreaDataStruct)?
//    {
//
//          let context = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationMaster")
//        do {
//            guard let fetchResult = try context.fetch(fetchRequest) as? [LocationMaster] else {return nil}
//            guard fetchResult.count > 0 else {return nil}
//            let ofcjsonData = (fetchResult.first?.officeCoordinates?.data(using: .utf8))!
//            let workjsonDat = (fetchResult.first?.workAreaData?.data(using: .utf8))!
//
//            guard let ofcjsonStruct = try? JSONDecoder().decode(OfficeCoordinatesStruct.self, from: ofcjsonData) , let workjsonStruct = try? JSONDecoder().decode(WorkAreaDataStruct.self, from: workjsonDat) else {fatalError()}
//            return (ofcjsonStruct , workjsonStruct)
//
//           // print(jsonStruct)
//        }catch let err{
//            print(err)
//        }
//        return nil
//    }
    
//    func saveAssignedCatTaskData(assignedData : AssignedProjects , taskData : TaskstatusData , categoryData : ProjectCatSubcatData)
//      {
//          guard let assigneddata = try? JSONEncoder().encode(assignedData) , let taskdata = try? JSONEncoder().encode(taskData) , let categorydata = try? JSONEncoder().encode(categoryData) else {return}
//        ////
//          let assignedData = String(data: assigneddata, encoding: .utf8)
//          let taskData = String(data: taskdata, encoding: .utf8)
//         let categoryData = String(data: categorydata, encoding: .utf8)
//        ////
//          let context = persistentContainer.viewContext
//          let entity = NSEntityDescription.entity(forEntityName: "PTMSMaster", in: context)!
//          let ptmsMaster = PTMSMaster(entity : entity , insertInto : context)
//          ptmsMaster.assignedProjects = assignedData
//          ptmsMaster.taskStatuses = taskData
//        ptmsMaster.categories = categoryData
//
//          do{
//              try context.save()
//          }catch let err{
//              print(err)
//          }
//      }
//      func getAssignedCatTaskData() -> (AssignedProjects , TaskstatusData , ProjectCatSubcatData )?
//      {
//
//            let context = persistentContainer.viewContext
//          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PTMSMaster")
//          do {
//              guard let fetchResult = try context.fetch(fetchRequest) as? [PTMSMaster] else {fatalError()}
//              let assignedjsonData = (fetchResult.first?.assignedProjects?.data(using: .utf8))!
//              let taskjsondata = (fetchResult.first?.taskStatuses?.data(using: .utf8))!
//              let categoryjsonData = (fetchResult.first?.categories?.data(using: .utf8))!
//
//              guard let assignedjsonStruct = try? JSONDecoder().decode(AssignedProjects.self, from: assignedjsonData) , let taskjsonStruct = try? JSONDecoder().decode(TaskstatusData.self, from: taskjsondata), let categoryjsonStruct = try? JSONDecoder().decode(ProjectCatSubcatData.self, from: categoryjsonData) else {fatalError()}
//              return (assignedjsonStruct , taskjsonStruct , categoryjsonStruct)
//
//             // print(jsonStruct)
//          }catch let err{
//              print(err)
//          }
//          return nil
//      }
    
  func getEntityData<T : Codable>(type : T.Type , entityName : CoreDataEntity) -> T?
     {
          let context = persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
  
              do {
                guard let fetchResult = try context.fetch(fetchRequest) as? [NSManagedObject] else {return nil}
               // print(fetchResult.count)
                  guard fetchResult.count > 0 else {return nil}
                let first = fetchResult.first!
                var data  : Data!
                switch first {
                case is Schools_Entity:
                  let schoolCasted = fetchResult as? [Schools_Entity]
                  guard let schoolData = (schoolCasted?.first!.strData?.data(using: .utf8)) else {return nil}
                  data = schoolData
                  
                default:
                  break;
                }
             


                  guard let taskStatusData = try? JSONDecoder().decode(T.self, from: data) else {fatalError()}
                  return taskStatusData
                 // print(jsonStruct)
              }catch let err{
                  print(err)
                //return nil
              }
              return nil
    }

}
