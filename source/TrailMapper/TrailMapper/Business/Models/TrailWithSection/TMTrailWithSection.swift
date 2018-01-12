//
//  TMTrailWithSection.swift
//
//  Created by  on 12/01/18
//  Copyright (c) Kartoza. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class TMTrailWithSection: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let trailsWithSections = "trails_with_sections"
  }

  // MARK: Properties
  public var trailsWithSections: [TMTrailsWithSections]?

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
    if let items = json[SerializationKeys.trailsWithSections].array { trailsWithSections = items.map { TMTrailsWithSections(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = trailsWithSections { dictionary[SerializationKeys.trailsWithSections] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.trailsWithSections = aDecoder.decodeObject(forKey: SerializationKeys.trailsWithSections) as? [TMTrailsWithSections]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(trailsWithSections, forKey: SerializationKeys.trailsWithSections)
  }

}
