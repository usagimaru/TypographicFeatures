//
//  ViewController.swift
//  TypographicFeatures
//
//  Created by usagimaru on 2024/01/23.
//

import Cocoa

class ViewController: NSViewController {

	@IBOutlet var label_sf_69: NSTextField!
	@IBOutlet var label_sf_4: NSTextField!
	@IBOutlet var label_sf_0: NSTextField!
	@IBOutlet var label_sf_1: NSTextField!
	@IBOutlet var label_sf_IJ: NSTextField!
	@IBOutlet var label_sf_l: NSTextField!
	@IBOutlet var label_sf_a: NSTextField!
	@IBOutlet var label_sf_colon: NSTextField!
	@IBOutlet var label_sf_dollarsign: NSTextField!
	@IBOutlet var label_sf_openCurrencies: NSTextField!
	@IBOutlet var label_sf_sample: NSTextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		label_sf_sample.setMonospacedDigitSystemFont()
	}

	@IBAction func switchSFFeatures(_ sender: NSSwitch) {
		if sender.state == .on {
			label_sf_69.setSFFeatures(Set([.straightSided_6_9]))
			label_sf_4.setSFFeatures(Set([.open_4]))
			label_sf_0.setSFFeatures(Set([.slashed_0]))
			label_sf_1.setSFFeatures(Set([.seriffedDigit_1]))
			label_sf_IJ.setSFFeatures(Set([.seriffedCapital_I, .seriffedCapital_J]))
			label_sf_l.setSFFeatures(Set([.tailedLowercase_l]))
			label_sf_a.setSFFeatures(Set([.oneStorey_a]))
			label_sf_colon.setSFFeatures(Set([.verticallyCenteredColon]))
			label_sf_dollarsign.setSFFeatures(Set([.smallDollarSign]))
			label_sf_openCurrencies.setSFFeatures(Set([.openCurrencies]))
			
			label_sf_sample.setSFFeatures(Set([
				.straightSided_6_9,
				.open_4,
				.slashed_0,
				.seriffedDigit_1,
				.seriffedCapital_I,
				.seriffedCapital_J,
				.oneStorey_a,
				.verticallyCenteredColon,
				.smallDollarSign,
				.openCurrencies,
				.monospacedDigit,
			]))
			
			var atts = FontAttributes()
			atts.alternateHalfWidths(true)
			label_sf_sample.font = label_sf_sample.font?.addingFontAttributes(atts)
		}
		else {
			label_sf_69.setDefaultSystemFont()
			label_sf_4.setDefaultSystemFont()
			label_sf_0.setDefaultSystemFont()
			label_sf_1.setDefaultSystemFont()
			label_sf_IJ.setDefaultSystemFont()
			label_sf_l.setDefaultSystemFont()
			label_sf_a.setDefaultSystemFont()
			label_sf_colon.setDefaultSystemFont()
			label_sf_dollarsign.setDefaultSystemFont()
			label_sf_openCurrencies.setDefaultSystemFont()
			
			label_sf_sample.setMonospacedDigitSystemFont()
		}
		
		// Print font attributes
		label_sf_sample.font?.fontDescriptor.printLocalizedAttributes()
	}
	
}

extension NSTextField {
	
	func setSFFeatures(_ features: Set<NSFont.SFProFeatures>) {
		font = font!.systemFontWithSFProFeatures(features)
	}
	
	func setDefaultSystemFont() {
		font = NSFont.systemFont(ofSize: font!.pointSize, weight: font!.weight)
	}
	
	func setMonospacedDigitSystemFont() {
		font = NSFont.monospacedDigitSystemFont(ofSize: font!.pointSize, weight: font!.weight)
	}
	
}
