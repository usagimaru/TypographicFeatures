//
//  TypographicFeatures.swift
//  TypographicFeatures
//
//  Created by usagimaru on 2023/04/22.
//
//  Font feature registry:
//  https://developer.apple.com/fonts/TrueType-Reference-Manual/RM09/AppendixF.html
//
//  Layout defines:
//  "CoreText/SFNTLayoutTypes.h"
//
//  Syntax for OpenType features in CSS:
//  https://helpx.adobe.com/fonts/using/open-type-syntax.html
//  https://helpx.adobe.com/jp/fonts/using/open-type-syntax.html (JP)
//
//  Character variants / Stylistic set:
//  https://learn.microsoft.com/en-us/typography/opentype/spec/features_ae#tag-cv01--cv99
//  https://learn.microsoft.com/en-us/typography/opentype/spec/features_pt#ssxx

import Foundation

#if os(macOS)
import Cocoa
public typealias FontDescriptor = NSFontDescriptor
#elseif os(iOS)
import UIKit
public typealias FontDescriptor = UIFontDescriptor
#endif


public struct FontFeatures {
	typealias TrueTypeFeatureTuple = (type: Int, selector: Int)
	private(set) var _features = [TrueTypeFeatureTuple]()
	
	mutating func removeFeature(_ pair: TrueTypeFeatureTuple) {
		_features.removeAll { feature in
			feature == pair
		}
	}
	
	mutating func addFeature(type: Int, selector: Int) {
		let newValue = (type: type, selector: selector)
		removeFeature(newValue)
		_features.append(newValue)
	}
	
	
	// More layout info: SFNTLayoutTypes.h
	
	mutating func caseSensitive(_ isOn: Bool) {
		let selector = isOn ? kCaseSensitiveLayoutOnSelector : kCaseSensitiveLayoutOffSelector
		addFeature(type: kCaseSensitiveLayoutType, selector: selector)
	}
	
	mutating func numberSpacingMonoDigit() {
		addFeature(type: kNumberSpacingType, selector: kMonospacedNumbersSelector)
	}
	
	mutating func numberSpacingProportionalDigit() {
		addFeature(type: kNumberSpacingType, selector: kProportionalNumbersSelector)
	}
	
	mutating func textSpacingMonoText() {
		addFeature(type: kTextSpacingType, selector: kMonospacedTextSelector)
	}
	
	mutating func textSpacingProportionalText() {
		addFeature(type: kTextSpacingType, selector: kProportionalTextSelector)
	}
	
	mutating func textSpacingHalfWidthText() {
		addFeature(type: kTextSpacingType, selector: kHalfWidthTextSelector)
	}
	
	mutating func extrasSlashedZero(_ isOn: Bool) {
		let selector = isOn ? kSlashedZeroOnSelector : kSlashedZeroOffSelector
		addFeature(type: kTypographicExtrasType, selector: selector)
	}
	
	mutating func contextualAlternates(_ isOn: Bool) {
		let selector = isOn ? kContextualAlternatesOnSelector : kContextualAlternatesOffSelector
		addFeature(type: kContextualAlternatesType, selector: selector)
	}
	
	mutating func SFPro_verticallyCenteredColon(_ isOn: Bool) {
		// SFProの"Vertically centered colon"の有効化は Type: 35, Selector: 6 なので、それと値が一致するのは以下と思われる
		let selector = isOn ? kStylisticAltThreeOnSelector : kStylisticAltThreeOffSelector
		addFeature(type: kStylisticAlternativesType, selector: selector)
	}
	
	
	// MARK: -
	
	func featureSettings() -> [[FontDescriptor.FeatureKey : Int]] {
		let features = _features.reduce(into: [[FontDescriptor.FeatureKey : Int]]()) { partialResult, tuple in
			// Store type-selector pair into one dictionary, result is array of dictionaries.
			var newPair = [FontDescriptor.FeatureKey : Int]()
			
#if os(macOS)
			newPair[FontDescriptor.FeatureKey.typeIdentifier] = tuple.type
			newPair[FontDescriptor.FeatureKey.selectorIdentifier] = tuple.selector
#elseif os(iOS)
			newPair[FontDescriptor.FeatureKey.type] = tuple.type
			newPair[FontDescriptor.FeatureKey.selector] = tuple.selector
#endif
			
			partialResult.append(newPair)
		}
		return features
	}
	
}

public struct FontAttributes {
	typealias Attribute = [String : Any]
	private(set) var _attributes = [Attribute]()
	
	func isContained(_ tag: String) -> Bool {
		for feature in _attributes {
			if feature[tag] != nil {
				return true
			}
		}
		return false
	}
	
	func settings() -> [String : [Attribute]] {
		var featureSettings = [String : [Attribute]]()
		featureSettings[kCTFontFeatureSettingsAttribute as String] = _attributes
		return featureSettings
	}
	
	mutating func removeFeature(tag: String) {
		_attributes.removeAll { feature in
			feature[tag] != nil
		}
	}
	
	mutating func addOpenTypeFeature(tag: String, value: Int) {
		removeFeature(tag: tag)
		
		var att = Attribute()
		att[kCTFontOpenTypeFeatureTag as String] = tag
		att[kCTFontOpenTypeFeatureValue as String] = value
		_attributes.append(att)
	}
	
	
	// MARK: - Standard features
	
	/// Enabled by default
	mutating func commonLigatures(_ isOn: Bool) {
		addOpenTypeFeature(tag: "liga", value: isOn ? 1 : 0)
		addOpenTypeFeature(tag: "clig", value: isOn ? 1 : 0)
	}
	
	mutating func discretionaryLigatures(_ isOn: Bool) {
		addOpenTypeFeature(tag: "dlig", value: isOn ? 1 : 0)
	}
	
	/// Enabled by default
	mutating func contextualAlternates(_ isOn: Bool) {
		addOpenTypeFeature(tag: "calt", value: isOn ? 1 : 0)
	}
	
	mutating func smallCaps(_ isOn: Bool) {
		addOpenTypeFeature(tag: "smcp", value: isOn ? 1 : 0)
	}
	
	mutating func capitalsToSmallCaps(_ isOn: Bool) {
		addOpenTypeFeature(tag: "c2sc", value: isOn ? 1 : 0)
	}
	
	mutating func swashes(_ isOn: Bool) {
		addOpenTypeFeature(tag: "swsh", value: isOn ? 1 : 0)
	}
	
	mutating func stylisticAlternates(_ isOn: Bool) {
		addOpenTypeFeature(tag: "salt", value: isOn ? 1 : 0)
	}
	
	mutating func liningFigures(_ isOn: Bool) {
		addOpenTypeFeature(tag: "lnum", value: isOn ? 1 : 0)
	}
	
	mutating func oldStyleFigures(_ isOn: Bool) {
		addOpenTypeFeature(tag: "onum", value: isOn ? 1 : 0)
	}
	
	mutating func proportionalFigures(_ isOn: Bool) {
		addOpenTypeFeature(tag: "pnum", value: isOn ? 1 : 0)
	}
	
	mutating func tabularFigures(_ isOn: Bool) {
		addOpenTypeFeature(tag: "tnum", value: isOn ? 1 : 0)
	}
	
	mutating func fractions(_ isOn: Bool) {
		addOpenTypeFeature(tag: "frac", value: isOn ? 1 : 0)
	}
	
	mutating func ordinals(_ isOn: Bool) {
		addOpenTypeFeature(tag: "ordn", value: isOn ? 1 : 0)
	}
	
	mutating func proportionalWidths(_ isOn: Bool) {
		addOpenTypeFeature(tag: "pwid", value: isOn ? 1 : 0)
	}
	
	mutating func proportionalAlternateWidths(_ isOn: Bool) {
		addOpenTypeFeature(tag: "palt", value: isOn ? 1 : 0)
	}
	
	mutating func fullWidths(_ isOn: Bool) {
		addOpenTypeFeature(tag: "fwid", value: isOn ? 1 : 0)
	}
	
	mutating func halfWidths(_ isOn: Bool) {
		addOpenTypeFeature(tag: "hwid", value: isOn ? 1 : 0)
	}
	
	mutating func alternateHalfWidths(_ isOn: Bool) {
		addOpenTypeFeature(tag: "halt", value: isOn ? 1 : 0)
	}
	
	mutating func thirdWidths(_ isOn: Bool) {
		addOpenTypeFeature(tag: "twid", value: isOn ? 1 : 0)
	}
	
	mutating func quarterWidths(_ isOn: Bool) {
		addOpenTypeFeature(tag: "qwid", value: isOn ? 1 : 0)
	}
	
	mutating func alternateAnnotationForms(_ isOn: Bool) {
		addOpenTypeFeature(tag: "nalt", value: isOn ? 1 : 0)
	}
	
	mutating func italics(_ isOn: Bool) {
		addOpenTypeFeature(tag: "ital", value: isOn ? 1 : 0)
	}
	
	mutating func kerning(_ isOn: Bool) {
		addOpenTypeFeature(tag: "kern", value: isOn ? 1 : 0)
	}
	
	/// Enabled by default
	mutating func glyphComposition(_ isOn: Bool) {
		addOpenTypeFeature(tag: "ccmp", value: isOn ? 1 : 0)
	}
	
	/// Enabled by default
	mutating func localizedForms(_ isOn: Bool) {
		addOpenTypeFeature(tag: "locl", value: isOn ? 1 : 0)
	}
	
	mutating func superscriptFeature(_ isOn: Bool) {
		addOpenTypeFeature(tag: "sups", value: isOn ? 1 : 0)
	}
	
	mutating func subscriptFeature(_ isOn: Bool) {
		addOpenTypeFeature(tag: "subs", value: isOn ? 1 : 0)
	}
	
	
	// MARK: - Vertical forms
	
	mutating func verticalKerning(_ isOn: Bool) {
		// https://helpx.adobe.com/jp/fonts/using/open-type-syntax.html#vnote
		addOpenTypeFeature(tag: "vkrn", value: isOn ? 1 : 0)
		addOpenTypeFeature(tag: "vpal", value: isOn ? 1 : 0)
	}
	
	/// Enabled by default
	mutating func verticalAlternates(_ isOn: Bool) {
		addOpenTypeFeature(tag: "vert", value: isOn ? 1 : 0)
	}
	
	mutating func proportionalAlternateVrticalMetrics(_ isOn: Bool) {
		addOpenTypeFeature(tag: "vpal", value: isOn ? 1 : 0)
	}
	
	mutating func alternateVerticalHalfMetrics(_ isOn: Bool) {
		addOpenTypeFeature(tag: "vhal", value: isOn ? 1 : 0)
	}
	
	mutating func verticalKanaAlternates(_ isOn: Bool) {
		addOpenTypeFeature(tag: "vkna", value: isOn ? 1 : 0)
	}
	
	
	// MARK: - Support for Japanese
	
	mutating func JIS78Forms(_ isOn: Bool) {
		addOpenTypeFeature(tag: "jp78", value: isOn ? 1 : 0)
	}
	
	mutating func JIS83Forms(_ isOn: Bool) {
		addOpenTypeFeature(tag: "jp83", value: isOn ? 1 : 0)
	}
	
	mutating func JIS90Forms(_ isOn: Bool) {
		addOpenTypeFeature(tag: "jp90", value: isOn ? 1 : 0)
	}
	
	mutating func JIS2004Forms(_ isOn: Bool) {
		addOpenTypeFeature(tag: "jp04", value: isOn ? 1 : 0)
	}
	
	mutating func proportionalKana(_ isOn: Bool) {
		addOpenTypeFeature(tag: "pkna", value: isOn ? 1 : 0)
	}
	
	mutating func horizontalKanaAlternates(_ isOn: Bool) {
		addOpenTypeFeature(tag: "hkna", value: isOn ? 1 : 0)
	}
	
	mutating func rubyNotationForms(_ isOn: Bool) {
		addOpenTypeFeature(tag: "ruby", value: isOn ? 1 : 0)
	}
	
	mutating func NLCKanjiForms(_ isOn: Bool) {
		addOpenTypeFeature(tag: "nlck", value: isOn ? 1 : 0)
	}
	
	
	// MARK: - Support for traditional Kanji
	
	mutating func traditionalForms(_ isOn: Bool) {
		addOpenTypeFeature(tag: "trad", value: isOn ? 1 : 0)
	}
	
	
	// MARK: - CV##
	
	// https://learn.microsoft.com/en-us/typography/opentype/spec/features_ae#tag-cv01--cv99
	
	mutating func cv01(_ isOn: Bool) {
		addOpenTypeFeature(tag: "cv01", value: isOn ? 1 : 0)
	}
	
	mutating func cv02(_ isOn: Bool) {
		addOpenTypeFeature(tag: "cv02", value: isOn ? 1 : 0)
	}
	
	mutating func cv03(_ isOn: Bool) {
		addOpenTypeFeature(tag: "cv03", value: isOn ? 1 : 0)
	}
	
	mutating func cv04(_ isOn: Bool) {
		addOpenTypeFeature(tag: "cv04", value: isOn ? 1 : 0)
	}
	
	mutating func cv05(_ isOn: Bool) {
		addOpenTypeFeature(tag: "cv05", value: isOn ? 1 : 0)
	}
	
	mutating func cv06(_ isOn: Bool) {
		addOpenTypeFeature(tag: "cv06", value: isOn ? 1 : 0)
	}
	
	mutating func cv07(_ isOn: Bool) {
		addOpenTypeFeature(tag: "cv07", value: isOn ? 1 : 0)
	}
	
	mutating func cv08(_ isOn: Bool) {
		addOpenTypeFeature(tag: "cv08", value: isOn ? 1 : 0)
	}
	
	mutating func cv09(_ isOn: Bool) {
		addOpenTypeFeature(tag: "cv09", value: isOn ? 1 : 0)
	}
	
	mutating func cv10(_ isOn: Bool) {
		addOpenTypeFeature(tag: "cv10", value: isOn ? 1 : 0)
	}
	
	mutating func cv11(_ isOn: Bool) {
		addOpenTypeFeature(tag: "cv11", value: isOn ? 1 : 0)
	}
	
	mutating func cv12(_ isOn: Bool) {
		addOpenTypeFeature(tag: "cv12", value: isOn ? 1 : 0)
	}
	
	
	// MARK: - Support for SFPro
	
	mutating func SFPro_straightSided_6_9(_ isOn: Bool = true) {
		cv01(isOn)
	}
	
	mutating func SFPro_open_4(_ isOn: Bool = true) {
		cv02(isOn)
	}
	
	mutating func SFPro_seriffedCapital_J(_ isOn: Bool = true) {
		cv03(isOn)
	}
	
	mutating func SFPro_verticallyCenteredColon(_ isOn: Bool = true) {
		cv04(isOn)
	}
	
	mutating func SFPro_seriffedCapital_I(_ isOn: Bool = true) {
		cv05(isOn)
	}
	
	mutating func SFPro_tailedLowercase_l(_ isOn: Bool = true) {
		cv06(isOn)
	}
	
	mutating func SFPro_oneStorey_a(_ isOn: Bool = true) {
		cv07(isOn)
	}
	
	mutating func SFPro_slashed_0(_ isOn: Bool = true) {
		cv08(isOn)
	}
	
	mutating func SFPro_smallDollarSign(_ isOn: Bool = true) {
		cv09(isOn)
	}
	
	mutating func SFPro_seriffedDigit_1(_ isOn: Bool = true) {
		cv12(isOn)
	}
	
	mutating func SFPro_openCurrencies(_ isOn: Bool = true) {
		addOpenTypeFeature(tag: "ss04", value: isOn ? 1 : 0)
	}
	
	mutating func SFPro_highLegibility(_ isOn: Bool = true) {
		addOpenTypeFeature(tag: "ss06", value: isOn ? 1 : 0)
	}

	mutating func SFPro_calculator(_ isOn: Bool = true) {
		addOpenTypeFeature(tag: "ss09", value: isOn ? 1 : 0)
	}
}

public extension FontDescriptor {
	
	func addingFontFeatures(_ features: FontFeatures) -> FontDescriptor {
		let newDescriptor = addingAttributes(
			[
				// Set type-selector features as "[[FontDescriptor.FeatureKey : Int]]"
				.featureSettings : features.featureSettings()
			]
		)
		return newDescriptor
	}
	
	func addingFontAttributes(_ attributes: FontAttributes) -> FontDescriptor {
		CTFontDescriptorCreateCopyWithAttributes(self, attributes.settings() as CFDictionary)
	}
	
	
	// MARK: -
	
	func printLocalizedAttributes() {
		let attributeArray = localizedAttributes()
		for attributes in attributeArray {
			if let featureTypeIdentifier = attributes[kCTFontFeatureTypeIdentifierKey] as? Int {
				print("Feature Type ID: \(featureTypeIdentifier)")
			}
			if let featureTypeNameID = attributes["CTFeatureTypeNameID" as CFString] as? Int {
				print("Feature Type Name ID: \(featureTypeNameID)")
			}
			if let featureTypeName = attributes[kCTFontFeatureTypeNameKey] as? String {
				print("Feature Type Name: \(featureTypeName)")
			}
			
			if let openTypeFeatureTag = attributes[kCTFontOpenTypeFeatureTag] as? String {
				print("OpenType Feature Tag: \(openTypeFeatureTag)")
			}
			
			if let featureTypeExclusive = attributes[kCTFontFeatureTypeExclusiveKey] as? Bool, featureTypeExclusive == true {
				print("Is exclusive: YES")
			}
			else {
				print("Is exclusive: NO")
			}
			
			if let sampleText = attributes[kCTFontFeatureSampleTextKey] as? String {
				print("Sample: \(sampleText)")
			}
			
			if let featureTypeSelectors = attributes[kCTFontFeatureTypeSelectorsKey] as? CTFontDescriptor.LocalizedAttributeArray {
				print("Feature selectors:")
				
				for selector in featureTypeSelectors {
					if let selectorID = selector[kCTFontFeatureSelectorIdentifierKey] as? Int {
						print("  Selector ID: \(selectorID)")
					}
					if let selectorNameID = selector["CTFeatureSelectorNameID" as CFString] as? Int {
						print("  Selector Name ID: \(selectorNameID)")
					}
					if let selectorName = selector[kCTFontFeatureSelectorNameKey] as? String {
						print("  Selector Name: \(selectorName)")
					}
					if let openTypeFeatureTag = selector[kCTFontOpenTypeFeatureTag] as? String {
						print("  OpenType Feature Tag: \(openTypeFeatureTag)")
					}
					if let openTypeFeatureValue = selector[kCTFontOpenTypeFeatureValue] as? Int {
						print("  OpenType Feature Value: \(openTypeFeatureValue)")
					}
					if let isDefaultSelector = selector[kCTFontFeatureSelectorDefaultKey] as? Bool, isDefaultSelector == true {
						print("  Is default: YES")
					}
					else {
						print("  Is default: NO")
					}
					
					print("\n")
				}
			}
			
			if let tooltip = attributes[kCTFontFeatureTooltipTextKey] as? String {
				print("Tooltip: \(tooltip)")
			}
			
			print("---------------------------")
			
			// kCTFontFeatureSelectorSettingKey の用途が不明
			// https://developer.apple.com/documentation/coretext/kctfontfeatureselectorsettingkey
		}
	}
	
}

public extension CTFontDescriptor {
	
	typealias LocalizedAttributeArray = [[CFString : AnyObject]]
	
	func localizedAttribute(_ langCode: String? = nil) -> LocalizedAttributeArray {
		// Unmanaged<T>の扱い: Core Foundation の値は Swift だと Unmanaged で扱われる
		// http://seeku.hateblo.jp/entry/2014/06/20/205708
		// https://qiita.com/omochimetaru/items/2aa00c7cb0eef4e57999
		
		var languagePtr: UnsafeMutablePointer<Unmanaged<CFString>?>? = nil
		if let langCode {
			let language: Unmanaged<CFString>? = Unmanaged<CFString>.passRetained(langCode as CFString)
			languagePtr = unsafeBitCast(language, to: UnsafeMutablePointer<Unmanaged<CFString>?>.self)
		}
		
		let localizedAttribute = CTFontDescriptorCopyLocalizedAttribute(self, kCTFontFeaturesAttribute, languagePtr)
		return localizedAttribute as? LocalizedAttributeArray ?? LocalizedAttributeArray()
	}
	
}

public extension FontDescriptor {
	
	func localizedAttributes(_ langCode: String? = nil) -> CTFontDescriptor.LocalizedAttributeArray {
		(self as CTFontDescriptor).localizedAttribute(langCode)
	}
}
