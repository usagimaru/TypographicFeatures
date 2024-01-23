//
//  NSFont.swift
//
//  Created by usagimaru on 2023/04/22.
//

#if os(macOS)

import Cocoa

public extension NSFont {
	
	var traits: [NSFontDescriptor.TraitKey : Any] {
		fontDescriptor.object(forKey: .traits) as? [NSFontDescriptor.TraitKey : Any] ?? [:]
	}
	
	var weight: NSFont.Weight {
		if let weightValue = traits[.weight] as? CGFloat {
			return NSFont.Weight(weightValue)
		}
		return .regular
	}
	
	var supportedLanguages: [String] {
		CTFontCopySupportedLanguages(self) as? [String] ?? []
	}
	
	func addingFontFeatures(_ features: FontFeatures) -> NSFont? {
		let newDescriptor = fontDescriptor.addingFontFeatures(features)
		return NSFont(descriptor: newDescriptor, size: pointSize)
	}
	
	func addingFontAttributes(_ attributes: FontAttributes) -> NSFont? {
		let newDescriptor = fontDescriptor.addingFontAttributes(attributes)
		return NSFont(descriptor: newDescriptor, size: pointSize)
	}
	
}

public extension NSFont {
	
	enum SFProFeatures {
		case monospacedDigit
		case straightSided_6_9
		case open_4
		case slashed_0
		case seriffedCapital_J
		case seriffedCapital_I
		case verticallyCenteredColon
		case tailedLowercase_l
		case oneStorey_a
		case smallDollarSign
		case seriffedDigit_1
		case openCurrencies
		case highLegibility
		case calculator
	}
	
	static func systemFontWithCapitalForms(ofSize size: CGFloat, weight: NSFont.Weight) -> NSFont {
		let systemFont = NSFont.systemFont(ofSize: size, weight: weight)
		
		var features = FontFeatures()
		features.caseSensitive(true)
		
		let descriptor_capitalForms = systemFont.fontDescriptor.addingFontFeatures(features)
		
		return NSFont(descriptor: descriptor_capitalForms, size: size) ?? systemFont
	}
	
	static func systemFont(ofSize size: CGFloat, weight: NSFont.Weight = .regular, features: Set<SFProFeatures>) -> NSFont {
		let systemFont = NSFont.systemFont(ofSize: size, weight: weight)
		var atts = FontAttributes()
		
		if features.contains(.monospacedDigit) {
			atts.tabularFigures(true)
		}
		if features.contains(.straightSided_6_9) {
			atts.SFPro_straightSided_6_9()
		}
		if features.contains(.open_4) {
			atts.SFPro_open_4()
		}
		if features.contains(.slashed_0) {
			atts.SFPro_slashed_0()
		}
		if features.contains(.seriffedCapital_J) {
			atts.SFPro_seriffedCapital_J()
		}
		if features.contains(.seriffedCapital_I) {
			atts.SFPro_seriffedCapital_I()
		}
		if features.contains(.verticallyCenteredColon) {
			atts.SFPro_verticallyCenteredColon()
		}
		if features.contains(.tailedLowercase_l) {
			atts.SFPro_tailedLowercase_l()
		}
		if features.contains(.oneStorey_a) {
			atts.SFPro_oneStorey_a()
		}
		if features.contains(.smallDollarSign) {
			atts.SFPro_smallDollarSign()
		}
		if features.contains(.seriffedDigit_1) {
			atts.SFPro_seriffedDigit_1()
		}
		if features.contains(.openCurrencies) {
			atts.SFPro_openCurrencies()
		}
		if features.contains(.highLegibility) {
			atts.SFPro_highLegibility()
		}
		if features.contains(.calculator) {
			atts.SFPro_calculator()
		}
		
		let newFontDescriptor = systemFont.fontDescriptor.addingFontAttributes(atts)
		
		return NSFont(descriptor: newFontDescriptor, size: size) ?? systemFont
	}
	
	func systemFontWithSFProFeatures(_ features: Set<SFProFeatures>) -> NSFont {
		NSFont.systemFont(ofSize: self.pointSize, weight: self.weight, features: features)
	}
	
}

#endif
