//
//  CustomTextView.swift
//  NGTextViewCustomBackgroundDrawingExample
//
//  Created by Noah Gilmore on 9/26/19.
//  Copyright © 2019 Noah Gilmore. All rights reserved.
//

import Foundation
import AppKit

extension NSAttributedString.Key {
    static let displayRedBackground = NSAttributedString.Key(rawValue: "com.noahgilmore.displayRedBackground")
}

//final class CustomTextContainer: NSTextContainer {
//    override func lineFragmentRect(forProposedRect proposedRect: NSRect, sweepDirection: NSLineSweepDirection, movementDirection: NSLineMovementDirection, remaining remainingRect: NSRectPointer?) -> NSRect {
//        return super.lineFragmentRect(forProposedRect: proposedRect, sweepDirection: sweepDirection, movementDirection: movementDirection, remaining: remainingRect)
//    }
//}

//final class CustomTypesetter: NSATSTypesetter {
//    override func setLocation(_ location: NSPoint, withAdvancements advancements: UnsafePointer<CGFloat>!, forStartOfGlyphRange glyphRange: NSRange) {
//        print("CAlling setLocation with glyph range: \(glyphRange)")
//        if glyphRange.location == 12 {
//            super.setLocation(NSPoint(x: location.x + 10, y: location.y), withAdvancements: advancements, forStartOfGlyphRange: glyphRange)
//        } else {
//            super.setLocation(location, withAdvancements: advancements, forStartOfGlyphRange: glyphRange)
//        }
//    }
//}

extension NSRectArray {
    func enumerateRects(count: Int, _ block: (NSRect) -> Void) {
        for i in 0..<count {
            block(self[i])
        }
    }
}

extension NSLayoutManager {
    func lineFragmentRects(forGlyphRange range: NSRange, in textContainer: NSTextContainer) -> [NSRect] {
        var results: [NSRect] = []

        self.enumerateEnclosingRects(forGlyphRange: range, withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0), in: textContainer, using: { rect, stop in
            results.append(rect)
        })

        return results
    }
}

final class CustomTextView: NSTextView {
//    private let customTextContainer: CustomTextContainer

    init() {
        let initialized = NSTextView(frame: .zero)
        let textContainer = CustomTextContainer()
//        self.customTextContainer = textContainer
        super.init(frame: .zero, textContainer: initialized.textContainer)
//        self.setTextCon
        self.replaceTextContainer(textContainer)

        self.isEditable = true
        self.isSelectable = true
        self.textContainerInset = .zero
        self.textContainer?.widthTracksTextView = true
        self.textColor = NSColor.labelColor
//        self.layoutManager!.typesetter = CustomTypesetter()

        self.textStorage?.append(NSAttributedString(string: "Hello world", attributes: [
            NSAttributedString.Key.foregroundColor: NSColor.labelColor,
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 20),
        ]))

        self.textStorage?.append(NSAttributedString(string: " ", attributes: [
            NSAttributedString.Key.foregroundColor: NSColor.labelColor,
            NSAttributedString.Key.kern: 6,
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 20),
        ]))

        self.textStorage?.append(NSAttributedString(string: "this should be red", attributes: [
            NSAttributedString.Key.foregroundColor: NSColor.labelColor,
            NSAttributedString.Key.font: NSFont(name: "Courier New", size: 20)!,
            NSAttributedString.Key.displayRedBackground: true
        ]))

        self.textStorage?.append(NSAttributedString(string: ",", attributes: [
            NSAttributedString.Key.foregroundColor: NSColor.labelColor,
            NSAttributedString.Key.font: NSFont(name: "Courier New", size: 20)!,
            NSAttributedString.Key.displayRedBackground: true,
            NSAttributedString.Key.kern: 6
        ]))

        self.textStorage?.append(NSAttributedString(string: " and now this should not", attributes: [
            NSAttributedString.Key.foregroundColor: NSColor.labelColor,
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 20),
        ]))

//        let leadingParagraphStyle = NSMutableParagraphStyle()
//        leadingParagraphStyle.paragraphSpacing = 20
//        self.textStorage?.append(NSAttributedString(string: "\n", attributes: [
//            NSAttributedString.Key.foregroundColor: NSColor.labelColor,
//            NSAttributedString.Key.paragraphStyle: leadingParagraphStyle
//        ]))
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.headIndent = 20
//        paragraphStyle.firstLineHeadIndent = 20
//        paragraphStyle.tailIndent = -20
//        paragraphStyle.lineSpacing = 20
//        paragraphStyle.paragraphSpacingBefore = 20
//        paragraphStyle.paragraphSpacing = 20
//        self.textStorage?.append(NSAttributedString(string: "This should be red jl; dfsh; sal jk dsajkl flk dasjlkn asdf ljk nas dl jknasd  lkas d as    jks;jkla fkjn fsanksadf jnsad fljknsad lnksad njlks adflnjk adfsnkl afsdkln\n\n kl;dsa  ds afnkl; afklsa kl;sad  kl;sadklads   adsnjklas dfnjlk sadfnls dfal\n", attributes: [
//            NSAttributedString.Key.foregroundColor: NSColor.labelColor,
//            NSAttributedString.Key.displayRedBackground: true,
//            NSAttributedString.Key.paragraphStyle: paragraphStyle,
////            NSAttributedString.Key.
//        ]))
//        self.textStorage?.append(NSAttributedString(string: "\nNo more red", attributes: [
//            NSAttributedString.Key.foregroundColor: NSColor.labelColor
//        ]))
//        self.typingAttributes = [.foregroundColor: NSColor.labelColor]

        self.layoutManager?.delegate = self

//        self.textStorage!.addAttribute(.font, value: NSFont.systemFont(ofSize: 20), range: NSRange(location: 0, length: self.textStorage!.length))
//        self.layoutManager?.removeTextContainer(at: 0)
//        self.layoutManager?.addTextContainer(textContainer)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawBackground(in rect: NSRect) {
        super.drawBackground(in: rect)

        guard let context = NSGraphicsContext.current?.cgContext else { return }
//        let context = graphicsContext as! CGContext
        context.saveGState()
        defer { context.restoreGState() }

//        print("Drawing in rect: \(rect)")

        self.textStorage!.enumerateAttribute(.displayRedBackground, in: NSMakeRange(0, self.textStorage!.length), options: [], using: { value, range, stop in
            if let value = value {
                context.setStrokeColor(NSColor.green.cgColor)
                context.setFillColor(NSColor.red.cgColor)

                for (index, rect) in self.layoutManager!.lineFragmentRects(forGlyphRange: range, in: self.textContainer!).enumerated() {
                    let rectToDraw = NSRect(x: rect.origin.x - 6, y: rect.origin.y, width: rect.size.width + 3, height: rect.size.height)
                    context.fill(rectToDraw)
                    context.stroke(rectToDraw)
                }
//                let boundingRect = self.layoutManager!.boundingRect(forGlyphRange: range, in: self.textContainer!)
//                print(".. Found the attribute at this exact rect: \(boundingRect) (range \(range))")
//                context.setStrokeColor(NSColor.green.cgColor)
//                context.setFillColor(NSColor.red.cgColor)
//                let rect = NSRect(x: boundingRect.origin.x - 6, y: boundingRect.origin.y, width: boundingRect.size.width + 3, height: boundingRect.size.height)
//                context.fill(rect)
//                context.stroke(rect)
            }
        })

        // https://stackoverflow.com/questions/34504031/control-spacing-around-custom-text-attributes-in-nslayoutmanager ???
    }
}

extension CustomTextView: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<NSRect>, lineFragmentUsedRect: UnsafeMutablePointer<NSRect>, baselineOffset: UnsafeMutablePointer<CGFloat>, in textContainer: NSTextContainer, forGlyphRange glyphRange: NSRange) -> Bool {
//        print("Asking about glyphRange \(glyphRange), line fragment rect: \(lineFragmentRect.pointee)")
        return false
    }
}
