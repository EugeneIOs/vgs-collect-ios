//
//  VGSDiskStatus.swift
//  VGSCollectSDK
//
//  Created on 12.03.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation

internal final class VGSDiskStatus {

	// MARK: Formatter MB only
	static func MBFormatter(_ bytes: Int64) -> String {
		let formatter = ByteCountFormatter()
		formatter.allowedUnits = ByteCountFormatter.Units.useMB
		formatter.countStyle = ByteCountFormatter.CountStyle.decimal
		formatter.includesUnit = false
		return formatter.string(fromByteCount: bytes) as String
	}


	// MARK: Get String Value
	static var totalDiskSpace: String {
		get {
			return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file)
		}
	}

	static var freeDiskSpace: String {
		get {
			return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file)
		}
	}

	static var usedDiskSpace: String {
		get {
			return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file)
		}
	}

	// MARK: Get raw value
	static var totalDiskSpaceInBytes: Int64 {
		get {
			do {
				let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
				let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
				return space!
			} catch {
				return 0
			}
		}
	}

	static var freeDiskSpaceInBytes: Int64 {
		get {
			do {
				let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
				let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
				return freeSpace!
			} catch {
				return 0
			}
		}
	}

	static var usedDiskSpaceInBytes: Int64 {
		get {
			let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
			return usedSpace
		}
	}

}
