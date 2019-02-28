//
//  Result.swift
//  WalkTracker
//
//  Created by Maria Ortega on 28/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import Foundation

enum Result<ResultType> {
    case results(ResultType)
    case error(Error)
}
