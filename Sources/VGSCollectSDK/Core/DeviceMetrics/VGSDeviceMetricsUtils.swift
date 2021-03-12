//
//  VGSDeviceMetricsUtils.swift
//  VGSCollectSDK
//
//  Created on 12.03.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation

internal final class VGSDeviceMetricsUtils {
	static func provideDeviceMetrics() -> JsonData {
		var deviceMetrics: JsonData = [:]

		deviceMetrics["os"] = osVersion
		deviceMetrics["is_simulator"] = isSumulator
		deviceMetrics["is_rooted"] = VGSCollect.isJailbroken()
		deviceMetrics["timezone"] = timeZoneOffset
		deviceMetrics["total_ram"] = totalRAM()
		deviceMetrics["muid"] = muid
		deviceMetrics["locale"] = language
		deviceMetrics["connection_type"] = VGSDeviceConnectionUtils.getConnectionType()
		deviceMetrics["ip_address"] = VGSDeviceConnectionUtils.getIPAddress()
		deviceMetrics["total_disk_space"] = VGSDiskStatus.totalDiskSpace
		deviceMetrics["used_disk_space"] = VGSDiskStatus.usedDiskSpace
		deviceMetrics["free_disk_space"] = VGSDiskStatus.freeDiskSpace
		deviceMetrics["device_idiom"] = deviceIdiom
		deviceMetrics["battery_state"] = batteryState
		deviceMetrics["carrier_name"] = VGSDeviceConnectionUtils.getCarrierName()
		deviceMetrics["battery_level"] = String(UIDevice.current.batteryLevel)

		deviceMetrics["app_name"] = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
		deviceMetrics["app_version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
		deviceMetrics["app_bundle_id"] = Bundle.main.bundleIdentifier 

		return deviceMetrics
	}

	// MARK: - Private

	private static var muid: String {
			let muid = UIDevice.current.identifierForVendor?.uuidString
			return muid ?? ""
	}

	private static var language = Locale.current.languageCode

	private static var platform = [deviceModel, osVersion].joined(separator: " ")

	private static var deviceModel: String = {
		var systemInfo = utsname()
		uname(&systemInfo)
		let model = withUnsafePointer(to: &systemInfo.machine) {
			$0.withMemoryRebound(to: CChar.self, capacity: 1) {
				ptr in String.init(validatingUTF8: ptr)
			}
		}
		return model ?? "Unknown"
	}()

	private static var osVersion = UIDevice.current.systemVersion

	private static var screenSize: String {
		let screen = UIScreen.main
		let screenRect = screen.bounds
		let width = screenRect.size.width
		let height = screenRect.size.height
		let scale = screen.scale
		return String(format: "%.0fw_%.0fh_%.0fr", width, height, scale)
	}

	private static var timeZoneOffset: String {
		let timeZone = NSTimeZone.local as NSTimeZone
		let hoursFromGMT = Double(timeZone.secondsFromGMT) / (60 * 60)
		return String(format: "%.0f", hoursFromGMT)
	}

	private static var isSumulator: Bool {
		#if arch(i386) || arch(x86_64)
		return true
		#else
		return false
		#endif
	}

	private static func totalRAM() -> String {
		return "\(Double(ProcessInfo.processInfo.physicalMemory) / (1024.0 * 1024.0 * 1024.0))"
	}

	private static func freeDiskSpace() -> String {
		return "\(Double(ProcessInfo.processInfo.physicalMemory) / (1024.0 * 1024.0 * 1024.0))"
	}

	private static var deviceIdiom: String {
		switch UIDevice.current.userInterfaceIdiom {
		case .carPlay:
			return "carPlay"
		case .mac:
			return "mac"
		case .pad:
			return "pad"
		case .phone:
			return "phone"
		case .tv:
			return "tv"
		case .unspecified:
			return "unspecified"
		@unknown default:
			return "uknown-yet"
		}
	}

	private static var batteryState: String {
		switch UIDevice.current.batteryState {
		case .charging:
			return "charging"
		case .unknown:
			return "unknown"
		case .unplugged:
			return "unplugged"
		case .full:
			return "full"
		@unknown default:
			return "uknown-yet"
		}
	}
}
