//
//  TMTrailModel.swift
//
//  Created by Kartoza on 09/01/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class TMTrailModel: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let trail = "trail"
  }

  // MARK: Properties
  public var trail: [TMTrail]?

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
    if let items = json[SerializationKeys.trail].array { trail = items.map { TMTrail(json: $0) } }
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = trail { dictionary[SerializationKeys.trail] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.trail = aDecoder.decodeObject(forKey: SerializationKeys.trail) as? [TMTrail]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(trail, forKey: SerializationKeys.trail)
  }

}
