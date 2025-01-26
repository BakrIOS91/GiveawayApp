//
//  GiveAwayClient.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

protocol GiveAwayClientProtocol {
    func getGiveAways(_ requestModel: GiveAwayRequestModel?) async -> Result<[GiveAwayItem]?, APIError>
    func getGiveAwayDetail(_ id: Int) async -> Result<GiveAwayItem?, APIError>
}


struct GiveAwayClient: GiveAwayClientProtocol {
    
    func getGiveAways(_ requestModel: GiveAwayRequestModel? = nil) async -> Result<[GiveAwayItem]?, APIError> {
        if let requestModel = requestModel {
            return await GiveAwayRequests.GetFilteredGiveAways(requestModel: requestModel).performResult()
        } else {
            return await GiveAwayRequests.GetAllGiveAways().performResult()
        }
    }
    
    func getGiveAwayDetail(_ id: Int) async -> Result<GiveAwayItem?, APIError> {
        return await GiveAwayRequests.GetdGiveAwayDetails(itemId: id).performResult()
    }
}
