//
//  VGSFormInteractionMetric.swift
//  VGSCollectSDK
//
//  Created on 12.03.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation

internal enum VGSFormInteractionMetric {
	case copyPaste
	case onFocus
	case deletion

	internal var name: String {
		switch self {
		case .copyPaste:
			return "copy_paste"
		case .onFocus:
			return "on_focus"
		case .deletion:
			return "deletion"
		}
	}
}

