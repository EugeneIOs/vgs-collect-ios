//
//  VGSDeviceConnectionUtils.swift
//  VGSCollectSDK
//
//  Created on 12.03.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation
import SystemConfiguration
import CoreTelephony

internal class VGSDeviceConnectionUtils {

	static func getConnectionType() -> String {
		guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com") else {
			return "uknown"
		}

		var flags = SCNetworkReachabilityFlags()
		SCNetworkReachabilityGetFlags(reachability, &flags)

		let isReachable = flags.contains(.reachable)
		let isWWAN = flags.contains(.isWWAN)

		if isReachable {
			if isWWAN {
				let networkInfo = CTTelephonyNetworkInfo()
				if #available(iOS 12.0, *) {
					let carrierType = networkInfo.serviceCurrentRadioAccessTechnology
					guard let carrierTypeName = carrierType?.first?.value else {
						return "uknown"
					}

					switch carrierTypeName {
					case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
						return "2G"
					case CTRadioAccessTechnologyLTE:
						return "4G"
					default:
						return "3G"
					}
				} else {
					return "uknown"
				}
			} else {
				return "wifi"
			}
		} else {
			return "no_connection"
		}
	}

	static func getCarrierName() -> String? {
		let networkInfo = CTTelephonyNetworkInfo()
		let carrier = networkInfo.subscriberCellularProvider

		return carrier?.carrierName
	}

	static func getIPAddress() -> String {
			var address: String?
			var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
			if getifaddrs(&ifaddr) == 0 {
					var ptr = ifaddr
					while ptr != nil {
							defer { ptr = ptr?.pointee.ifa_next }

							guard let interface = ptr?.pointee else { return "" }
							let addrFamily = interface.ifa_addr.pointee.sa_family
							if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

									// wifi = ["en0"]
									// wired = ["en2", "en3", "en4"]
									// cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

									let name: String = String(cString: (interface.ifa_name))
									if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
											var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
											getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
											address = String(cString: hostname)
									}
							}
					}
					freeifaddrs(ifaddr)
			}
			return address ?? ""
	}
}
