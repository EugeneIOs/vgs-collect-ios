//
//  FormInteractionMetricsCollector.swift
//  VGSCollectSDK
//
//  Created on 12.03.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation

internal struct FeildInteractionEvent {
	let name: String
	let timestamp: Int

	var json: JsonData {
		return [
			"timestamp" : timestamp,
			"name" : name
		]
	}
}

internal class VGSFieldInteractionMetricsCollector {
 	fileprivate var events: [FeildInteractionEvent] = []

	fileprivate var eventsJSON: [JsonData] {
		return events.map({return $0.json})
	}

	func trackMetric(_ metric: VGSFormInteractionMetric) {
		let timestamp = Int(Date().timeIntervalSince1970 * 1000)
		let event = FeildInteractionEvent(name: metric.name, timestamp: timestamp)
		events.append(event)
	}

	func clearMetrics() {
		events = []
	}

	func jsonForField(fieldName: String, fieldType: FieldType) -> JsonData {
		return [
			"\(fieldName)" : [
				"field_type" : fieldType.stringIdentifier,
				"metrics" : eventsJSON
			]
		]
	}
}

