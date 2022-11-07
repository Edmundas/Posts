//
//  PostEntity.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//
//

import Foundation
import CoreData

@objc(PostEntity)
public class PostEntity: NSManagedObject {

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var user: UserEntity?
    
}

extension PostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        let request = NSFetchRequest<PostEntity>(entityName: "PostEntity")
        request.sortDescriptors = []
        return request
    }

}

extension PostEntity : Identifiable { }
