//
//  DataObjectSerializable.swift
//  Twitter
//
//  Created by Phuc Nguyen on 5/13/19.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import Foundation

protocol DataObjectSerializable {
    var representation: [String: Any] { get }
}
