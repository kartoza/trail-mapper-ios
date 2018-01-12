//
//  TMTrailsWithSections.swift
//
//  Created by  on 12/01/18
//  Copyright (c) Kartoza. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class TMTrailsWithSections: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let trailSectionGuids = "trail_section_guids"
    static let trailGuid = "trail_guid"
  }

  // MARK: Properties
  public var trailSectionGuids: [String]?
  public var trailGuid: String?

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
    if let items = json[SerializationKeys.trailSectionGuids].array { trailSectionGuids = items.map { $0.stringValue } }
    trailGuid = json[SerializationKeys.trailGuid].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = trailSectionGuids { dictionary[SerializationKeys.trailSectionGuids] = value }
    if let value = trailGuid { dictionary[SerializationKeys.trailGuid] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.trailSectionGuids = aDecoder.decodeObject(forKey: SerializationKeys.trailSectionGuids) as? [String]
    self.trailGuid = aDecoder.decodeObject(forKey: SerializationKeys.trailGuid) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(trailSectionGuids, forKey: SerializationKeys.trailSectionGuids)
    aCoder.encode(trailGuid, forKey: SerializationKeys.trailGuid)
  }

}
