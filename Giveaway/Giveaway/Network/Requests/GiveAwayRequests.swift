//
//  GiveAwayRequests.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//
import Moya
import Foundation

struct GiveAwayRequests {
    
    struct GetAllGiveAways: ModelTargetType {
        typealias Response = [GiveAwayItem]?
        
        var baseURL: String { return AppTarget().kBaseURL }
        
        var requestPath: String { return "giveaways" }
        
        var requestMethod: Moya.Method {return .get}
        
        var mockResponse: [GiveAwayItem]? { return GiveAwayItem.mockArray(count: 10)}
        
        var requestTask: RequestTask {
            return .plain
        }
    }
    
    struct GetFilteredGiveAways: ModelTargetType {
        typealias Response = [GiveAwayItem]?
        
        var baseURL: String { return AppTarget().kBaseURL }
        
        var requestPath: String { return "filter" }
        
        var requestMethod: Moya.Method {return .get}
        
        var mockResponse: [GiveAwayItem]? { return GiveAwayItem.mockArray(count: 10)}
        
        var requestModel: GiveAwayRequestModel
        
        var requestTask: RequestTask {
            return .parameters(
                [
                    "platform": requestModel.platform,
                    "type": requestModel.type,
                    "sort-by": requestModel.sortBy
                ].compactMapValues({$0})
            )
        }
        
        init(requestModel: GiveAwayRequestModel) {
            self.requestModel = requestModel
        }
    }
    
    struct GetdGiveAwayDetails: ModelTargetType {
        typealias Response = GiveAwayItem?
        
        var baseURL: String { return AppTarget().kBaseURL }
        
        var requestPath: String { return "giveaway" }
        
        var requestMethod: Moya.Method {return .get}
        
        var mockResponse: GiveAwayItem? { return GiveAwayItem.mock(1)}
        
        var itemId: Int
        
        var requestTask: RequestTask {
            return .parameters([
                "id": itemId
            ])
        }
        
        init(itemId: Int) {
            self.itemId = itemId
        }
    }
    
}
