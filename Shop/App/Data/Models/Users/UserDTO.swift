//
//  UserDTO.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.06.23.
//

import Foundation
import BackedCodable

struct UserDTO: BackedDecodable {    
    init(_: DeferredDecoder) {  }
    
    @Backed()
    var id: Int

    @Backed(Path("name", "firstname"))
    var firstname: String
    
    @Backed(Path("name", "lastname"))
    var lastname: String
    
    @Backed()
    var email: String
    
    @Backed()
    var phone: String
}
