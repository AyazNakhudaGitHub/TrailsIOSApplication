//
//  ResponseFromTrailAPI.swift
//  HelloWorldApplication
//
//  Created by Ayaz Nakhuda on 2020-08-11.
//  Copyright © 2020 Ayaz Nakhuda. All rights reserved.
//

import Foundation
import SwiftUI

struct ResponseFromTrailAPI: Codable, Identifiable {
    let id : Int
    var name: String
    let location: String
    let ascent: Int
    let descent: Int
    let summary: String
    let imgSqSmall: String
}
