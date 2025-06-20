//
//  Color.swift
//  DemoApp
//
//  Created by Danil Chernikov on 19.06.2025.
//

import SwiftUI

extension UIColor {
    static let darkBlue =      #colorLiteral(red: 0, green: 0.4352941176, blue: 0.5215686275, alpha: 1) //006f85
    static let bluishGrey =    #colorLiteral(red: 0.4862745098, green: 0.6039215686, blue: 0.6117647059, alpha: 1) //7c9a9c
    static let skyBlue =       #colorLiteral(red: 0.6, green: 0.7725490196, blue: 0.8078431373, alpha: 1) //99c5ce
    static let lightBlue =     #colorLiteral(red: 0.6588235294, green: 0.8078431373, blue: 0.8352941176, alpha: 1) //a8ced5
    
    /// The SwiftUI color associated with the receiver.
    var suColor: Color { Color(self) }
}
