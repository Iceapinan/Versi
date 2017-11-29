//
//  PresentSFViewController.swift
//  Versi
//
//  Created by IceApinan on 29/11/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

extension UIViewController {
    
    func presentSFViewController(from url: String) {
        let readMeURL = URL(string: url + readmeSegment)
        let safari = SFSafariViewController(url: readMeURL!)
        self.present(safari, animated: true, completion: nil)
    }
    
}
