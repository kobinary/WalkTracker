//
//  Logs.swift
//  WalkTracker
//
//  Created by Maria Ortega on 28/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit

/**********************************************
 *
 *            Custom Logs
 *
 **********************************************/

#if DEBUG
func pLog(_ message: Any) {
    print(">> \(message)")
}
#else
func pLog(_ message: Any) {  }
#endif
