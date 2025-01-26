//
//  AppEnums.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

import SwiftUI

enum AppEnvironment {
    case development
    case testing
    case staging
    case release
}

/// Enum representing the types of network requests supported.
enum RequestTask {
    /// A request with no additional data in the body.
    case plain
    /// A request with URL-encoded parameters in the query string.
    case parameters(_ parameters: [String: Any])
    /// A request with a body encoded as JSON from an `Encodable` type.
    case encodedBody(Encodable)
}

/// Enum representing the types of errors that can occur in the network layer.
enum APIError: Error, Equatable {
    /// Error indicating invalid URL formation.
    case invalidURL
    /// Error indicating failure in data conversion.
    case dataConversionFailed
    /// Error indicating failure in string conversion.
    case stringConversionFailed
    /// Error representing an HTTP error with a specific status code.
    case httpError(statusCode: Int)
    /// No Internet connection.
    case noNetwork
    /// Invalid Response.
    case invalidResponse
    /// No Data
    case noData
    /// No Search Data Match
    case searchError
    
    var errorTitle: String {
        switch self {
        case .invalidURL:
            return StringConstants.error_InvalidURL_Title.text
        case .dataConversionFailed:
            return StringConstants.error_DataConversionFailed_Title.text
        case .stringConversionFailed:
            return StringConstants.error_StringConversionFailed_Title.text
        case .httpError:
            return StringConstants.error_HTTPError_Title.text
        case .noNetwork:
            return StringConstants.error_NoNetwork_Title.text
        case .invalidResponse:
            return StringConstants.error_InvalidResponse_Title.text
        case .noData:
            return StringConstants.error_NoData_Title.text
        case .searchError:
            return StringConstants.error_SearchError_Title.text
        }
    }
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return StringConstants.error_InvalidURL_Description.text
        case .dataConversionFailed:
            return StringConstants.error_DataConversionFailed_Description.text
        case .stringConversionFailed:
            return StringConstants.error_StringConversionFailed_Description.text
        case .httpError(let statusCode):
            return StringConstants.error_HTTPError_Description(statusCode)
        case .noNetwork:
            return StringConstants.error_NoNetwork_Description.text
        case .invalidResponse:
            return StringConstants.error_InvalidResponse_Description.text
        case .noData:
            return StringConstants.error_NoData_Description.text
        case .searchError:
            return StringConstants.error_SearchError_Description.text
        }
    }
    
    var errorImage: Image {
        switch self {
        case .invalidURL:
            return Image(.errorUnExpected)
        case .dataConversionFailed:
            return Image(.errorUnExpected)
        case .stringConversionFailed:
            return Image(.errorUnExpected)
        case .httpError:
            return Image(.errorUnExpected)
        case .noNetwork:
            return Image(.errorNoNetwork)
        case .invalidResponse:
            return Image(.errorServerError)
        case .noData:
            return Image(.errorNoDataa)
        case .searchError:
            return Image(.errorSearch)
        }
    }
    
    var isReloadable: Bool {
        switch self {
        case .invalidURL:
            return true
        case .dataConversionFailed:
            return false
        case .stringConversionFailed:
            return false
        case .httpError:
            return true
        case .noNetwork:
            return true
        case .invalidResponse:
            return false
        case .noData:
            return false
        case .searchError:
            return false
        }
    }
}


enum PrefrancesKeys: String {
    case kAPPFavoriteGiveAways
}


enum LookupType {
    case platform
    case type
    case sortBy
    
    var lookupTitle: String {
        switch self {
        case .platform:
            return "Platform"
        case .type:
            return "Type"
        case .sortBy:
            return "Sort Type"
        }
    }
    
    var lookupItems: [LookupItem] {
        switch self {
        case .platform:
            return FilterPlatform.allCases.map({ LookupItem(name: $0.rawValue, value: $0.value) })
        case .type:
            return FilterType.allCases.map({ LookupItem(name: $0.rawValue, value: $0.value) })
        case .sortBy:
            return FilterSortBy.allCases.map({ LookupItem(name: $0.rawValue, value: $0.value) })

        }
    }
}

enum FilterPlatform: String, CaseIterable {
    case PC
    case Steam
    case Epic = "Epic Games Store"
    case Ubisoft
    case GOG
    case Itchio
    case PS4
    case PS5
    case XboxOne = "Xbox One"
    case XboxSeriseXS = "Xbox Series XS"
    case Xbox360 = "Xbox 360"
    case Switch
    case Android
    case iOS
    case VR
    case BattleNet
    case Origin
    case DRMFree = "DRM Free"
    
    var value: String {
        switch self {
        case .PC:
            return "pc"
        case .Steam:
            return "steam"
        case .Epic:
            return "epic-games-store"
        case .Ubisoft:
            return "ubisoft"
        case .GOG:
            return "gog"
        case .Itchio:
            return "itchio"
        case .PS4:
            return "ps4"
        case .PS5:
            return "ps5"
        case .XboxOne:
            return "xbox-one"
        case .XboxSeriseXS:
            return "xbox-series-xs"
        case .Xbox360:
            return "xbox-360"
        case .Switch:
            return "switch"
        case .Android:
            return "android"
        case .iOS:
            return "ios"
        case .VR:
            return "vr"
        case .BattleNet:
            return "battlenet"
        case .Origin:
            return "origin"
        case .DRMFree:
            return "drm-free"
        }
    }
    
    static var homeFilters: [Self] {
        return [.PC,.Steam,.iOS,.Android]
    }
}

enum FilterType: String, CaseIterable {
    case Game
    case Loot
    case Beta
    
    var value: String {
        switch self {
        case .Game:
            return "game"
        case .Loot:
            return "loot"
        case .Beta:
            return "beta"
        }
    }
}

enum FilterSortBy: String, CaseIterable {
    case Date
    case Value
    case Popularity
    
    var value: String {
        switch self {
        case .Date:
            return "date"
        case .Value:
            return "value"
        case .Popularity:
            return "popularity"
        }
    }
}
