//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Alamofire


class Direction: NSManagedObject {
    
    // MARK: - Core Data
    
    static func insertWithAttributes(attributes: [String : AnyObject], managedObjectContext:NSManagedObjectContext) -> Direction {
        let entity = NSEntityDescription.entityForName("Direction", inManagedObjectContext: managedObjectContext)
        let direction = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as! Direction
        
        if let stringValue = attributes["Value"] as? String, let intValue = Int(stringValue) {
            direction.value = NSNumber(integer: intValue)
        }
        
        direction.name = attributes["Text"] as? String
        return direction
    }
    
    // MARK: - Metro API
    
    static func getDirections(route: Route, success onSuccess:(directions:[Direction])->Void, failure onFailure:(directions:[Direction], error:NSError?)->Void) {
        Alamofire.request(.GET, "http://svc.metrotransit.org/NexTrip/Directions/\(route.routeNumber!)", parameters: ["format": "json"])
            .responseJSON { response in
                debugPrint(response)
                
                var directions = [Direction]()
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                if let JSON = response.result.value  as? [[String : AnyObject]] {
                    for item in JSON {
                        let direction = insertWithAttributes(item, managedObjectContext: appDelegate.managedObjectContext)
                        directions.append(direction)
                    }
                    onSuccess(directions: directions)
                } else {
                    onFailure(directions: directions, error: nil)
                }
        }
    }
}