
import UIKit
import RealmSwift

protocol DDBBManagerDelegate:AnyObject{ //Protocol needed to stablish changes in the realm database
    func didSaveFavouriteWithError(error: Error?)
    func didIsSaved(saved: Bool)
    func didDeleteFavouriteWithError(error: Error?)
}

class DDBBManager {
    static let shared = DDBBManager() //Singleton
    private let configuration: Realm.Configuration!
    
    private init() {
        let url = FileManager.default.urls(for: .documentDirectory,
                                           in: .userDomainMask)
            .last?
            .appendingPathComponent("pokedexapp_v1.realm")
        
        configuration = Realm.Configuration(fileURL: url,
                                            inMemoryIdentifier: nil,
                                            syncConfiguration: nil,
                                            encryptionKey: nil,
                                            readOnly: false,
                                            schemaVersion: 1,
                                            migrationBlock: nil,
                                            deleteRealmIfMigrationNeeded: true,
                                            shouldCompactOnLaunch: nil,
                                            objectTypes: nil)
    }
    func loadFavourites() -> RealmSwift.Results<Results>{
            let realm = try! Realm(configuration: self.configuration)
            let favourites: RealmSwift.Results<Results> = realm.objects(Results.self)
            return favourites
    }
    func removeAll(){
        do{
            let realm = try Realm(configuration: self.configuration)
            try realm.write{
                realm.deleteAll()
            }
            
        }catch{
            print("DDBBManager", error)
            
        }
    }
    func write(_ block:()-> Void, finish: ((Error?)-> Void)? = nil){
        do{
            let realm = try Realm(configuration: self.configuration)
            try realm.write(block)
            finish?(nil)
        }catch{
            print("DDBBManager", error)
            finish?(error)
        }
    }
    func save <T: Object>(_ object: T, _ block: ((Error?) -> Void)?) {
        do{
            let realm = try Realm(configuration: self.configuration)
            try realm.write {
                realm.add(object, update: .error)
                block?(nil)
            }
        }catch{
            print(error)
            block?(error)
            
        }
    }
    func delete <T: Object>(_ object: T, _ block: ((Error?)-> Void)?){
        do{
            let realm = try Realm(configuration: self.configuration)
            try realm.write{
                realm.delete(object)
                block?(nil)
            }
        }catch{
            print(error)
            block?(error)
        }
    }
    func get <T: Object>(_ object: T.Type, filter: String? = nil)-> [T]{
        var result: [T] = [T]()
        do{
            let realm = try Realm(configuration: self.configuration)
            let objects = realm.objects(object)
            if let filter = filter{
                result = Array(objects.filter(filter))
            }else{
                result = Array(objects)
            }
        }catch{
            print(error)
        }
        return result
    }
}
