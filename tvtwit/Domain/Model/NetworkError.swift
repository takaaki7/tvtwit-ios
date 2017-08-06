//
//  NetworkError.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/02/01.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation

public enum NetworkError: ErrorType,CustomStringConvertible {
    
    case Unknown
    
    case NotConnectedToInternet
    
    case InternationalRoamingOff
    
    case NotReachedServer
    
    case ConnectionLost
    
    case IncorrectDataReturned
    
    internal init(error: NSError){
        if error.domain == NSURLErrorDomain {
            switch error.code {
            case NSURLErrorUnknown:
                self = .Unknown
            case NSURLErrorCancelled:
                self = .Unknown // Cancellation is not used in this project.
            case NSURLErrorBadURL:
                self = .IncorrectDataReturned // Because it is caused by a bad URL returned in a JSON response from the server.
            case NSURLErrorTimedOut:
                self = .NotReachedServer
            case NSURLErrorUnsupportedURL:
                self = .IncorrectDataReturned
            case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
                self = .NotReachedServer
            case NSURLErrorDataLengthExceedsMaximum:
                self = .IncorrectDataReturned
            case NSURLErrorNetworkConnectionLost:
                self = .ConnectionLost
            case NSURLErrorDNSLookupFailed:
                self = .NotReachedServer
            case NSURLErrorHTTPTooManyRedirects:
                self = .Unknown
            case NSURLErrorResourceUnavailable:
                self = .IncorrectDataReturned
            case NSURLErrorNotConnectedToInternet:
                self = .NotConnectedToInternet
            case NSURLErrorRedirectToNonExistentLocation, NSURLErrorBadServerResponse:
                self = .IncorrectDataReturned
            case NSURLErrorUserCancelledAuthentication, NSURLErrorUserAuthenticationRequired:
                self = .Unknown
            case NSURLErrorZeroByteResource, NSURLErrorCannotDecodeRawData, NSURLErrorCannotDecodeContentData:
                self = .IncorrectDataReturned
            case NSURLErrorCannotParseResponse:
                self = .IncorrectDataReturned
            case NSURLErrorInternationalRoamingOff:
                self = .InternationalRoamingOff
            case NSURLErrorCallIsActive, NSURLErrorDataNotAllowed, NSURLErrorRequestBodyStreamExhausted:
                self = .Unknown
            case NSURLErrorFileDoesNotExist, NSURLErrorFileIsDirectory:
                self = .IncorrectDataReturned
            case
            NSURLErrorNoPermissionsToReadFile,
            NSURLErrorSecureConnectionFailed,
            NSURLErrorServerCertificateHasBadDate,
            NSURLErrorServerCertificateUntrusted,
            NSURLErrorServerCertificateHasUnknownRoot,
            NSURLErrorServerCertificateNotYetValid,
            NSURLErrorClientCertificateRejected,
            NSURLErrorClientCertificateRequired,
            NSURLErrorCannotLoadFromNetwork,
            NSURLErrorCannotCreateFile,
            NSURLErrorCannotOpenFile,
            NSURLErrorCannotCloseFile,
            NSURLErrorCannotWriteToFile,
            NSURLErrorCannotRemoveFile,
            NSURLErrorCannotMoveFile,
            NSURLErrorDownloadDecodingFailedMidStream,
            NSURLErrorDownloadDecodingFailedToComplete:
                self = .Unknown
            default:
                self = .Unknown
            }
        }
        else {
            self = .Unknown
        }
    }
    
    public var description: String {
        let text: String
        switch self {
        case Unknown:
            text = "NetworkError_Unknown"
        case NotConnectedToInternet:
            text = "NetworkError_NotConnectedToInternet"
        case InternationalRoamingOff:
            text = "NetworkError_InternationalRoamingOff"
        case NotReachedServer:
            text = "NetworkError_NotReachedServer"
        case ConnectionLost:
            text = "NetworkError_ConnectionLost"
        case IncorrectDataReturned:
            text = "NetworkError_IncorrectDataReturned"
        }
        return text
    }
    
}