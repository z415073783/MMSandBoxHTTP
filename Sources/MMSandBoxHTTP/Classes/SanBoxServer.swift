//
//  SanBoxServer.swift
//  MMSanBoxHTTP
//
//  Created by 曾亮敏 on 2020/5/6.
//  Copyright © 2020 曾亮敏. All rights reserved.
//

import Foundation
import MMLibrary
// swiftlint:disable function_body_length
@objc public class SanBoxServer: NSObject {
    static let shared = SanBoxServer()
    var server: HttpServer?
    
    public var ipAddress: String {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first ?? "0.0.0.0"
    }
    
    @objc public class func server() {
        let port = 8080 // ProcessInfo.processInfo.processIdentifier
        
        print(" port = \(port), ip = \(shared.ipAddress)")
        
        let server = HttpServer()
        do {
            try server.start(in_port_t(port), forceIPv4: false, priority: DispatchQoS.QoSClass.userInitiated)
//            try server.start(in_port_t(port))
        } catch {
            
        }
        
        shared.server = server
        guard let dir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first?.path else { return }
        print("dir = \(dir)")

        server.GET["/"] = scopes {
            html {
                body {
                    form {
                        method_ = "POST"
                        action = "/download"
                        enctype = "multipart/form-data"
                        meta {
                            charset = "utf-8"
                        }
                        button {
                            type = "submit"
                            inner = "下载日志"
                        }
                    }
                }
            }
        }
        server.POST["/download"] = { request in
            let path = MMLogArchive.getAllLogZip()
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return HttpResponse.ok(.data(data))
            } catch  {
                print("操作失败 error = \(error)")
            }
            return HttpResponse.notFound
        }
    }
}
