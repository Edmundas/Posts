//
//  UserEntity.swift
//  Posts
//
//  Created by Edmundas Matusevičius on 2022-11-06.
//
//

import Foundation
import CoreData

@objc(UserEntity)
public class UserEntity: NSManagedObject {

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var posts: Set<PostEntity>?

}

extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        request.sortDescriptors = []
        return request
    }

}

extension UserEntity: Identifiable { }
