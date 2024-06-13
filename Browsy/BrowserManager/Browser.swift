//
//  Browser.swift
//  Browsy
//
//  Created by julionb on 31/05/24.
//

import Foundation
import AppKit

struct Browser: Hashable {
    let name: String
    let icon: NSImage
    let appUrl: URL
}

func aBrowserList(number: Int = 3) -> [Browser] {
   (1...number).map { i in Browser(name: "Browser \(i)", icon: NSImage(named: NSImage.actionTemplateName)!, appUrl: URL(string: "browser\(i).com")!) }
}
