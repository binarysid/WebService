//
//  Article.swift
//  Cars
//
//  Created by Linkon Sid on 19/12/22.
//

struct CarData:Codable{
    let id: Int64
    let title: String
    let ingress: String
    let image: String
    let dateTime: String
    let tags: [String]
    let content:[CarContent]
    let created: Int64
    let changed: Int64
}
