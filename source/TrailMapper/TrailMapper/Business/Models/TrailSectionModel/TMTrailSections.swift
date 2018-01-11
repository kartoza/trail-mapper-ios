//
//  TMTrailSections.swift
//
//  Created by  on 10/01/18
//  Copyright (c) Kartoza. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class TMTrailSections: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let id = "id"
    static let geom = "geom"
    static let grade = "grade"
    static let guid = "guid"
    static let notes = "notes"
    static let imagePath = "image"
    static let offset = "offset"

    static let synchronised = "synchronised"
    static let dateTimeStart = "date_time_start"
    static let dateTimeEnd = "date_time_end"

  }

  // MARK: Properties
  public var name: String?
  public var id: Int?
  public var geom: String?
  public var grade: Int?
  public var guid: String?
  public var notes: String?
  public var imagePath: String?
    public var offset: Int?

    public var synchronised: String?
    public var dateTimeStart: String?
    public var dateTimeEnd: String?

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
    geom = json[SerializationKeys.geom].string
    grade = json[SerializationKeys.grade].int
    guid = json[SerializationKeys.guid].string
    notes = json[SerializationKeys.notes].string
    imagePath = json[SerializationKeys.imagePath].string
    offset = json[SerializationKeys.offset].int

    synchronised = json[SerializationKeys.synchronised].string
    dateTimeStart = json[SerializationKeys.dateTimeStart].string
    dateTimeEnd = json[SerializationKeys.dateTimeEnd].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = geom { dictionary[SerializationKeys.geom] = value }
    if let value = grade { dictionary[SerializationKeys.grade] = value }
    if let value = guid { dictionary[SerializationKeys.guid] = value }
    if let value = notes { dictionary[SerializationKeys.notes] = value }
    if let value = imagePath { dictionary[SerializationKeys.imagePath] = value }
    if let value = offset { dictionary[SerializationKeys.offset] = value }

    if let value = synchronised { dictionary[SerializationKeys.synchronised] = value }
    if let value = dateTimeStart { dictionary[SerializationKeys.dateTimeStart] = value }
    if let value = dateTimeEnd { dictionary[SerializationKeys.dateTimeEnd] = value }

    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObject(forKey: SerializationKeys.name) as? String
    self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? Int
    self.geom = aDecoder.decodeObject(forKey: SerializationKeys.geom) as? String
    self.grade = aDecoder.decodeObject(forKey: SerializationKeys.grade) as? Int
    self.guid = aDecoder.decodeObject(forKey: SerializationKeys.guid) as? String
    self.notes = aDecoder.decodeObject(forKey: SerializationKeys.notes) as? String
    self.imagePath = aDecoder.decodeObject(forKey: SerializationKeys.imagePath) as? String
    self.offset = aDecoder.decodeObject(forKey: SerializationKeys.offset) as? Int

    self.synchronised = aDecoder.decodeObject(forKey: SerializationKeys.synchronised) as? String
    self.dateTimeStart = aDecoder.decodeObject(forKey: SerializationKeys.dateTimeStart) as? String
    self.dateTimeEnd = aDecoder.decodeObject(forKey: SerializationKeys.dateTimeEnd) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: SerializationKeys.name)
    aCoder.encode(id, forKey: SerializationKeys.id)
    aCoder.encode(geom, forKey: SerializationKeys.geom)
    aCoder.encode(grade, forKey: SerializationKeys.grade)
    aCoder.encode(guid, forKey: SerializationKeys.guid)
    aCoder.encode(notes, forKey: SerializationKeys.notes)
    aCoder.encode(imagePath, forKey: SerializationKeys.imagePath)
    aCoder.encode(offset, forKey: SerializationKeys.offset)

    aCoder.encode(synchronised, forKey: SerializationKeys.synchronised)
    aCoder.encode(dateTimeStart, forKey: SerializationKeys.dateTimeStart)
    aCoder.encode(dateTimeEnd, forKey: SerializationKeys.dateTimeEnd)
  }

}
