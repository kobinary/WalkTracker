//
//  LogoHelper.swift
//  WalkTracker
//
//  Created by Maria Ortega on 27/02/2019.
//  Copyright © 2019 Maria Ortega. All rights reserved.
//

import UIKit

class LogoHelper: NSObject {

    func setupLogo() -> UIImageView {
        let logo = UIImage(named: "logoIcon.png")
        let imageView = UIImageView(image:logo)
        return imageView
    }
}
