//
//  Saasquatch.swift
//  saasquatch
//
//  Created by Brendan Crawford on 2016-03-03.
//  Copyright © 2016 Brendan Crawford. All rights reserved.
//  Modified by Trevor Lee on 2017-05-18.

import Foundation
import UIKit

open class Saasquatch {
    
    
    
    /**
     Saasquatch is the Referral Saasquatch iOS SDK which provides a set of mfunctions
     for interfacing with Referral SaaSquatch.
     It can register a user with Referral SaaSquatch, retrieve information about users and referral codes, validate referral codes,
     apply referral codes to a user's account, create a cookie user, upsert a user, and get a users share links.
     */
    
    
    
    fileprivate static let urlString = "https://app.referralsaasquatch.com/api/v1"
    
    fileprivate static let baseURL: URL = URL(string: urlString)!
    
    fileprivate static let session = URLSession(configuration: URLSessionConfiguration.default)
    
    
    
    /**
     Create a user and account.
     
     Registers a user with Referral SaaSquatch.
     
     - parameter tenant:            Identifies which tenant to connect to.
     - parameter userID:            ID to uniquely track users and let us handle accounts that are shared between users.
     - parameter accountID:         ID to link a group of users together.
     - parameter token:             The JWT to sign the request.
     - parameter userInfo:          A Foundation object from which to generate JSON for the request.
     - parameter completionHandler: A block object to be executed when the task finishes. This block has no return value.
     
     - Seealso: http://docs.referralsaasquatch.com/api/methods
     */
    
    open class func registerUserForTenant(
        _ tenant: String,
        withUserID userID: String,
        withAccountID accountID: String,
        withToken token: String?,
        withUserInfo userInfo: AnyObject,
        completionHandler: @escaping (_ userInfo: AnyObject?, _ error: NSError?) -> Void) {
        
        let url = baseURL.appendingPathComponent("/\(tenant)/open/account/\(accountID)/user/\(userID)")
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if token != nil {
            request.setValue(token, forHTTPHeaderField: "X-SaaSquatch-User-Token")
        }
        
        request.httpMethod = "POST"
        
        var data: Data?
        do {
            data = try JSONSerialization.data(withJSONObject: userInfo, options: JSONSerialization.WritingOptions(rawValue: 0))
        } catch let error as NSError {
            completionHandler(nil, error)
            return
        }
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if (error != nil) {
                completionHandler(nil, error as NSError?)
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            
            var encoding = String.Encoding.utf8
            if let textEncodingName = response?.textEncodingName {
                let cfStringEncoding = CFStringConvertIANACharSetNameToEncoding(textEncodingName as CFString!)
                encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(cfStringEncoding))
            }
            
            if httpResponse?.statusCode == 201 {
                var userInfo: AnyObject?
                do {
                    userInfo = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        as AnyObject? as AnyObject? as AnyObject?
                } catch let error as NSError {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(userInfo, nil)
                return
                
            } else {
                let errorString = NSString(data: data!, encoding: encoding.rawValue)
                let userInfo: [AnyHashable: Any] = [NSLocalizedDescriptionKey: errorString!]
                let error = NSError(domain: "HTTP error", code: (httpResponse?.statusCode)!, userInfo: userInfo)
                completionHandler(nil, error)
                return
            }
        })
        
        dataTask.resume()
    }
    
    
    /**
     User Upsert
     
     Updates/creates a user and an account with Referral SaaSquatch.
     
     - parameter tenant:            Identifies which tenant to connect to.
     - parameter userID:            ID to uniquely track users and let us handle accounts that are shared between users.
     - parameter accountID:         ID to link a group of users together.
     - parameter token:             The JWT to sign the request.
     - parameter userInfo:          A Foundation object from which to generate JSON for the request.
     - parameter completionHandler: A block object to be executed when the task finishes. This block has no return value.
     
     - Seealso: https://docs.referralsaasquatch.com/api/methods
     */
    
    open class func userUpsert(
        _ tenant: String,
        withUserID userID: String,
        withAccountID accountID: String,
        withToken token: String?,
        withUserInfo userInfo: AnyObject,
        completionHandler: @escaping (_ userInfo: AnyObject?, _ error: NSError?) -> Void) {
        
        
        
        let url = baseURL.appendingPathComponent("/\(tenant)/open/account/\(accountID)/user/\(userID)")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if token != nil {
            request.setValue(token, forHTTPHeaderField: "X-SaaSquatch-User-Token")
        }
        
        request.httpMethod = "PUT"
        var data: Data?
        do {
            data = try JSONSerialization.data(withJSONObject: userInfo, options: JSONSerialization.WritingOptions(rawValue: 0))
        } catch let error as NSError {
            completionHandler(nil, error)
            return
        }
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if (error != nil) {
                completionHandler(nil, error as NSError?)
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            
            var encoding = String.Encoding.utf8
            if let textEncodingName = response?.textEncodingName {
                let cfStringEncoding = CFStringConvertIANACharSetNameToEncoding(textEncodingName as CFString!)
                encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(cfStringEncoding))
            }
            
            if httpResponse?.statusCode == 200 {
                var userInfo: AnyObject?
                do {
                    userInfo = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        as AnyObject? as AnyObject? as AnyObject?
                } catch let error as NSError {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(userInfo, nil)
                return
                
            } else {
                let errorString = NSString(data: data!, encoding: encoding.rawValue)
                let userInfo: [AnyHashable: Any] = [NSLocalizedDescriptionKey: errorString!]
                let error = NSError(domain: "HTTP error", code: (httpResponse?.statusCode)!, userInfo: userInfo)
                completionHandler(nil, error)
                return
            }
        })
        
        dataTask.resume()
    }
    
    
    /**
     Create Cookie User
     
     Generates a cookie account/user with Referral SaaSquatch.
     
     - parameter tenant:            Identifies which tenant to connect to.
     - parameter token:             The JWT to sign the request.
     - parameter userInfo:          A Foundation object from which to generate JSON for the request.
     - parameter completionHandler: A block object to be executed when the task finishes. This block has no return value.
     
     - Seealso: https://docs.referralsaasquatch.com/api/methods
     */
    
    open class func createCookieUser(
        _ tenant: String,
        withToken token: String?,
        withUserInfo userInfo: AnyObject,
        completionHandler: @escaping (_ userInfo: AnyObject?, _ error: NSError?) -> Void) {
        
        
        
        let url = baseURL.appendingPathComponent("/\(tenant)/open/user/cookie_user")
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        if token != nil {
            request.setValue(token, forHTTPHeaderField: "X-SaaSquatch-User-Token")
        }
        
        request.httpMethod = "PUT"
        var data: Data?
        do {
            data = try JSONSerialization.data(withJSONObject: userInfo, options: JSONSerialization.WritingOptions(rawValue: 0))
        } catch let error as NSError {
            completionHandler(nil, error)
            return
        }
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if (error != nil) {
                completionHandler(nil, error as NSError?)
                return
            }
            
            
            let httpResponse = response as? HTTPURLResponse
            
            var encoding = String.Encoding.utf8
            if let textEncodingName = response?.textEncodingName {
                let cfStringEncoding = CFStringConvertIANACharSetNameToEncoding(textEncodingName as CFString!)
                encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(cfStringEncoding))
            }
            
            if httpResponse?.statusCode == 200 {
                var userInfo: AnyObject?
                do {
                    userInfo = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        as AnyObject? as AnyObject? as AnyObject?
                } catch let error as NSError {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(userInfo, nil)
                return
                
            } else {
                let errorString = NSString(data: data!, encoding: encoding.rawValue)
                let userInfo: [AnyHashable: Any] = [NSLocalizedDescriptionKey: errorString!]
                let error = NSError(domain: "HTTP error", code: (httpResponse?.statusCode)!, userInfo: userInfo)
                completionHandler(nil, error)
                return
            }
        })
        
        dataTask.resume()
    }
    
    
    /**
     Lookup a User
     
     Gets a user's information from Referral Saasquatch.
     
     - parameter tenant:            Identifies which tenant to connect to.
     - parameter userID:            ID to uniquely track users and let us handle accounts that are shared between users.
     - parameter accountID:         ID to link a group of users together.
     - parameter token:             The JWT to sign the request.
     - parameter completionHandler: A block object to be executed when the task finishes. This block has no return value.
     
     - SeeAlso: http://docs.referralsaasquatch.com/api/methods
     */
    
    open class func userForTenant(
        _ tenant: String,
        withUserID userID: String,
        withAccountID accountID: String,
        withToken token: String?,
        completionHandler: @escaping (_ userInfo: AnyObject?, _ error: NSError?) -> Void) {
        
        let url = baseURL.appendingPathComponent("/\(tenant)/open/account/\(accountID)/user/\(userID)")
        let request = NSMutableURLRequest(url: url)
        //var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if token != nil {
            request.setValue(token, forHTTPHeaderField: "X-SaaSquatch-User-Token")
        }
        
        
        let dataTask = saasquatchDataTaskStatusOKWithRequest(request as URLRequest, withCallback: completionHandler)
        dataTask.resume()
    }
    
    
    /**
     Get a User by a Referral Code
     
     Gets a user's information by their referral code.
     
     - parameter referralCode:      The referral code of the user being looked up.
     - parameter tenant:            Identifies which tenant to connect to.
     - parameter token:             The JWT to sign the request.
     - parameter completionHandler: A block object to be executed when the task finishes. This block has no return value.
     
     - SeeAlso: http://docs.referralsaasquatch.com/api/methods
     */
    
    open class func userByReferralCode(
        _ referralCode: String,
        forTenant tenant: String,
        withToken token: String?,
        completionHandler: @escaping (_ userInfo: AnyObject?, _ error: NSError?) -> Void) {
        
        let urlString = "\(baseURL)/\(tenant)/open/user?referralCode=\(referralCode)"
        let url = URL(string: urlString)
        if (url == nil) {
            let userInfo: [AnyHashable: Any] = [NSLocalizedDescriptionKey: "A URL cannot be formed from the parameters"]
            let error = NSError(domain: "Malformed URL", code: 0, userInfo: userInfo)
            completionHandler(nil, error)
            return
        }
        let request = NSMutableURLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if (token != nil) {
            request.setValue(token, forHTTPHeaderField: "X-SaaSquatch-User-Token")
        }
        
        let dataTask = saasquatchDataTaskStatusOKWithRequest(request as URLRequest, withCallback: completionHandler)
        dataTask.resume()
    }
    
    
    /**
     Lookup a Referral Code
     
     Checks if a referral code exists and retrieves information about the code and it's reward.
     
     - parameter referralCode:      The referral code of the user being looked up.
     - parameter tenant:            Identifies which tenant to connect to.
     - parameter token:             The JWT to sign the request.
     - parameter completionHandler: A block object to be executed when the task finishes. This block has no return value.
     
     - SeeAlso: http://docs.referralsaasquatch.com/api/methods
     */
    
    open class func lookupReferralCode(
        _ referralCode: String,
        forTenant tenant: String,
        withToken token: String?,
        completionHandler: @escaping (_ userInfo: AnyObject?, _ error: NSError?) -> Void) {
        
        let url = baseURL.appendingPathComponent("/\(tenant)/open/code/\(referralCode)")
        let request = NSMutableURLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if (token != nil) {
            request.setValue(token, forHTTPHeaderField: "X-SaaSquatch-User-Token")
        }
        
        let dataTask = saasquatchDataTaskStatusOKWithRequest(request as URLRequest, withCallback: completionHandler)
        dataTask.resume()
    }
    
    
    /**
     Apply a Referral Code
     
     Applies a referral code to a user's account.
     
     - parameter referralCode: The referral code to be applied.
     - parameter tenant:            Identifies which tenant to connect to.
     - parameter userID:            ID to uniquely track users and let us handle accounts that are shared between users.
     - parameter accountID:         ID to link a group of users together.
     - parameter token:             The JWT to sign the request.
     - parameter completionHandler: A block object to be executed when the task finishes. This block has no return value.
     
     - SeeAlso: http://docs.referralsaasquatch.com/api/methods
     */
    
    open class func applyReferralCode(
        _ referralCode: String,
        forTenant tenant: String,
        toUserID userID: String,
        toAccountID accountID: String,
        withToken token: String?,
        completionHandler: @escaping (_ userInfo: AnyObject?, _ error: NSError?) -> Void) {
        
        
        
        
        let url = baseURL.appendingPathComponent("/\(tenant)/open/code/\(referralCode)/account/\(accountID)/user/\(userID)")
        let request = NSMutableURLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if token != nil {
            request.setValue(token, forHTTPHeaderField: "X-SaaSquatch-User-Token")
        }
        
        
        request.httpMethod = "POST"
        //request.httpBody = NSString(string: "{}").data(using: String.Encoding.utf8)
        request.httpBody = "{}".data(using: .utf8)
        //request.httpBody = String("{}").data(using: String.Encoding.utf8)
        
        let dataTask = saasquatchDataTaskStatusOKWithRequest(request as URLRequest, withCallback: completionHandler)
        dataTask.resume()
    }
    
    
    /**
     List Referrals
     
     Returns the list of referrals for the tenant with options for filtering.
     
     - parameter tenant:            Identifies which tenant to connect to.
     - parameter token:             The JWT to sign the request.
     - parameter accountID:         ID to link a group of users together.
     - parameter userID:            ID to uniquely track users and let us handle accounts that are shared between users.
     - parameter datePaid:          When included, filters the results either to the exact timestamp if only one value is given, or a range if devided by a comma.
     - parameter dateEnded:         When included, filters the results either to the exact timestamp if only one value is given, or a range if devided by a comma.
     - parameter referredStatus:    When included, filters the result to only include referred users with that status. Statuses that are accepted: PENDING, APPROVED or DENIED.
     - parameter referrerStatus:    When included, filters the result to only include referrers with that status. Statuses that are accepted: PENDING, APPROVED or DENIED.
     - parameter limit:             A limit on the number of results returned. Defaults to 10.
     - parameter offset:            When included offsets the first result returns in the list. Use this to paginate through a long list of results. Defaults to 0.
     - parameter completionHandler: A block object to be executed when the task finishes. This block has no return value.
     
     - SeeAlso: http://docs.referralsaasquatch.com/api/methods
     */
    
    open class func listReferralsForTenant(
        _ tenant: String,
        withToken token: String?,
        forReferringAccountID accountID: String?,
        forReferringUserID userID: String?,
        beforeDateReferralPaid datePaid: String?,
        beforeDateReferralEnded dateEnded: String?,
        withReferredModerationStatus referredStatus: String?,
        withReferrerModerationStatus referrerStatus: String?,
        withLimit limit: NSString?,
        withOffset offset: NSString?,
        completionHandler: @escaping (_ userInfo: AnyObject?, _ error: NSError?) -> Void) {
        
        var urlString = "\(baseURL)/\(tenant)/open/referrals"
        
        let queryParams: NSMutableArray = []
        if (accountID != nil) {
            let queryParam = "referringAccountId=\(accountID!)"
            queryParams.add(queryParam)
        }
        if (userID != nil) {
            let queryParam = "referringUserId=\(userID!)"
            queryParams.add(queryParam)
        }
        if (datePaid != nil) {
            let queryParam = "dateReferralPaid=\(datePaid!)"
            queryParams.add(queryParam)
        }
        if (dateEnded != nil) {
            let queryParam = "dateReferralEnded=\(dateEnded!)"
            queryParams.add(queryParam)
        }
        if (referredStatus != nil) {
            let queryParam = "referredModerationStatus=\(referredStatus!)"
            queryParams.add(queryParam)
        }
        if (referrerStatus != nil) {
            let queryParam = "referrerModerationStatus=\(referrerStatus!)"
            queryParams.add(queryParam)
        }
        if (limit != nil) {
            let queryParam = "limit=\(limit!)"
            queryParams.add(queryParam)
        }
        if (offset != nil) {
            let queryParam = "offset=\(offset!)"
            queryParams.add(queryParam)
        }
        var first = true
        for param in queryParams {
            if first {
                urlString = (urlString + "?") + (param as! String)
                first = false
            } else {
                urlString = (urlString + "&") + (param as! String)
            }
        }
        
        let url = URL(string: urlString)
        if (url == nil) {
            let userInfo: [AnyHashable: Any] = [NSLocalizedDescriptionKey: "A URL cannot be formed from the parameters"]
            let error = NSError(domain: "Malformed URL", code: 0, userInfo: userInfo)
            completionHandler(nil, error)
            return
        }
        
        let request = NSMutableURLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if token != nil {
            request.setValue(token, forHTTPHeaderField: "X-SaaSquatch-User-Token")
        }
        
        let dataTask = saasquatchDataTaskStatusOKWithRequest(request as URLRequest, withCallback: completionHandler)
        dataTask.resume()
    }
    
    
    /**
     
     Get Share Links
     
     Allows customers to request share links for a particular engagement medium
     
     - parameter tenant:            Identifies which tenant to connect to.
     - parameter token:             The JWT to sign the request.
     - parameter accountID:         ID to link a group of users together.
     - parameter userID:            ID to uniquely track users and let us handle accounts that are shared between users.
     - parameter engagementMedium:  [OPTIONAL] Identifies which medium to return. Can be one of [NOCONTENT, EMBED, HOSTED, MOBILE, POPUP, DEMO_EMBED, DEMO, EMPTY, EMAIL]
     - parameter shareMedium:       [OPTIONAL] Identifies which sharelink to return. Can be one of [FACEBOOK, TWITTER, EMAIL, DIRECT, LINKEDIN, SMS, FBMESSENGER, WHATSAPP, REMINDER, UNKNOWN]
     - parameter completionHandler: A block object to be executed when the task finishes. This block has no return value.
     
     - SeeAlso: https://docs.referralsaasquatch.com/api/methods
     */
    
    open class func getSharelinks(
        _ tenant: String,
        forReferringAccountID accountID: String,
        forReferringUserID userID: String,
        withEngagementMedium engagementMedium: String?,
        withShareMedium shareMedium: String?,
        withToken token: String?,
        completionHandler: @escaping (_ userInfo: AnyObject?, _ error: NSError?) -> Void) {
        
        var urlString: String = self.urlString
        urlString = urlString.appending("/\(tenant)" + "/open/account" + "/\(accountID)" + "/user" + "/\(userID)" + "/shareurls")
        
        
        let queryParams: NSMutableArray = []
        if (engagementMedium != nil) {
            let queryParam = "engagementMedium=\(engagementMedium!)"
            queryParams.add(queryParam)
        }
        if (shareMedium != nil) {
            let queryParam = "shareMedium=\(shareMedium!)"
            queryParams.add(queryParam)
        }
        
        var first = true
        for param in queryParams {
            if first {
                urlString = (urlString + "?") + (param as! String)
                first = false
            } else {
                urlString = (urlString + "&") + (param as! String)
            }
        }
        
        let url = URL(string: urlString)
        
        let request = NSMutableURLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if token != nil {
            request.setValue(token, forHTTPHeaderField: "X-SaaSquatch-User-Token")
        }
        
        let dataTask = saasquatchDataTaskStatusOKWithRequest(request as URLRequest, withCallback: completionHandler)
        dataTask.resume()
        
    }
    
    
    // This function handles the get requests.
    fileprivate class func saasquatchDataTaskStatusOKWithRequest(_ request: URLRequest, withCallback completionHandler: @escaping (_ userInfo: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if (error != nil) {
                completionHandler(nil, error as NSError?)
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            
            var encoding = String.Encoding.utf8
            if let textEncodingName = response?.textEncodingName {
                let cfStringEncoding = CFStringConvertIANACharSetNameToEncoding(textEncodingName as CFString!)
                encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(cfStringEncoding))
            }
            
            if httpResponse?.statusCode == 200 {
                let userInfo: AnyObject?
                do {
                    userInfo = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject] as AnyObject?
                } catch let error as NSError {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(userInfo, nil)
                return
                
            } else {
                let errorString = NSString(data: data!, encoding: encoding.rawValue)
                let userInfo: [AnyHashable: Any] = [NSLocalizedDescriptionKey: errorString!]
                let error = NSError(domain: "HTTP error", code: (httpResponse?.statusCode)!, userInfo: userInfo)
                completionHandler(nil, error)
                return
            }
        })
    }
}
