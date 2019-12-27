//
//  DoctorModel.swift
//  EasyCure
//
//  Created by Ali Muhammad on 2019-12-25.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//
import UIKit

class DoctorModel {
    var DocID: String?
    var Name: String?
    var Profession: String?
    init(DocID:String?, Name:String?, Profession:String?) {
        self.DocID = DocID
        self.Name = Name
        self.Profession = Profession
    }
}
