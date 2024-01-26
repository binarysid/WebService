//
//  Car.swift
//  Cars
//
//  Created by Linkon Sid on 19/12/22.
//

import Foundation

struct CarViewData:Hashable,Identifiable {
    let id:Int64
    let title:String
    let image:String?
    let description:String
    let date:String
    let time:String
}
