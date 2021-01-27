//
//  VGSCollectAssetsBundle.swift
//  
//

import Foundation

public final class VGSCollectAssetsBundle {
	public static var main = VGSCollectAssetsBundle()
	public var iconBundle: Bundle?

	public init() {
			// Identify bundle for SPM.

			#if SWIFT_PACKAGE
			iconBundle = Bundle.module
			#endif

			// Return if bundle is found.
			guard iconBundle == nil else {
				return
			}

			let containingBundle = Bundle(for: VGSCollectAssetsBundle.self)

			// Look for CardIcon bundle (handle CocoaPods integration).
			if let bundleURL = containingBundle.url(forResource: "CardIcon", withExtension: "bundle") {
				iconBundle = Bundle(url: bundleURL)
			} else {
				// Icon bundle matches containing bundle (Carthage integration).
				iconBundle = containingBundle
			}
		}
}
