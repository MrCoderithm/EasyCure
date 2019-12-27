//
//  AppointmentModel.swift
//  EasyCure
//
//  Created by Ali Muhammad on 2019-12-25.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//
import UIKit

class AppointmentModel {
    var DocID: String?
    var Name: String?
    var Day: String?
    var Time: String?
    init(DocID:String?, Name:String?, Day:String?, Time:String) {
        self.DocID = DocID
        self.Name = Name
        self.Day = Day
        self.Time = Time
    }
}
