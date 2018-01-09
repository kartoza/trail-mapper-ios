//
//  TMTrail.swift
//
//  Created by Kartoza on 09/01/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class TMTrail: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let id = "id"
    static let image = "image"
    static let pkuid = "pkuid"
    static let offset = "offset"
    static let colour = "colour"
    static let guid = "guid"
    static let notes = "notes"
  }

  // MARK: Properties
  public var name: String?
  public var id: Int?
  public var image: String?
  public var pkuid: Int?
  public var offset: Int?
  public var colour: String?
  public var guid: String?
  public var notes: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    name = json[SerializationKeys.name].string
    id = json[SerializationKeys.id].int
    image = json[SerializationKeys.image].string
    pkuid = json[SerializationKeys.pkuid].int
    offset = json[SerializationKeys.offset].int
    colour = json[SerializationKeys.colour].string
    guid = json[SerializationKeys.guid].string
    notes = json[SerializationKeys.notes].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = image { dictionary[SerializationKeys.image] = value }
    if let value = pkuid { dictionary[SerializationKeys.pkuid] = value }
    if let value = offset { dictionary[SerializationKeys.offset] = value }
    if let value = colour { dictionary[SerializationKeys.colour] = value }
    if let value = guid { dictionary[SerializationKeys.guid] = value }
    if let value = notes { dictionary[SerializationKeys.notes] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.image = aDecoder.decodeObject(forKey: SerializationKeys.image) as? String
    self.pkuid = aDecoder.decodeObject(forKey: SerializationKeys.pkuid) as? Int
    self.offset = aDecoder.decodeObject(forKey: SerializationKeys.offset) as? Int
    self.colour = aDecoder.decodeObject(forKey: SerializationKeys.colour) as? String
    self.guid = aDecoder.decodeObject(forKey: SerializationKeys.guid) as? String
    self.notes = aDecoder.decodeObject(forKey: SerializationKeys.notes) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(image, forKey: SerializationKeys.image)
    aCoder.encode(pkuid, forKey: SerializationKeys.pkuid)
    aCoder.encode(offset, forKey: SerializationKeys.offset)
    aCoder.encode(colour, forKey: SerializationKeys.colour)
    aCoder.encode(guid, forKey: SerializationKeys.guid)
    aCoder.encode(notes, forKey: SerializationKeys.notes)
  }

}
