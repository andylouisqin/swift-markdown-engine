//
//  NativeTextViewCoordinator+Notifications.swift
//  MarkdownEngine
//
//  Created by Luca Chen on 16.03.26.
//
//  Bus-notification handlers wired up by `subscribeToBusNotifications`.
//  These translate embedder-posted requests (apply bold / italic / heading
//  level) into the corresponding ContextMenu actions, and refresh styling
//  when the syntax highlighter signals an appearance change.
//

import AppKit

extension NativeTextViewCoordinator {
    /// Bus formatting requests are broadcast with no addressee; only the
    /// editor the user is actually typing in may act. Without this, a
    /// shortcut pressed while some OTHER field has focus (a title bar, a
    /// find field) would still rewrite this editor's document around its
    /// last selection.
    private var editorIsFirstResponder: Bool {
        guard let tv = textView else { return false }
        return tv.window?.firstResponder === tv
    }

    @objc func handleBoldNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        didMarkdownBold(nil)
    }

    @objc func handleItalicNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        didMarkdownItalic(nil)
    }

    @objc func handleHighlightNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        didMarkdownHighlight(nil)
    }

    @objc func handleHeadingNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        guard let level = notification.userInfo?["level"] as? Int else { return }
        let item = NSMenuItem()
        item.tag = level
        didMarkdownHeading(item)
    }

    @objc func handleStrikethroughNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        didMarkdownStrikethrough(nil)
    }

    @objc func handleInlineCodeNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        didMarkdownInlineCode(nil)
    }

    @objc func handleBlockquoteNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        didMarkdownBlockquote(nil)
    }

    @objc func handleUnorderedListNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        didMarkdownUnorderedList(nil)
    }

    @objc func handleOrderedListNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        didMarkdownOrderedList(nil)
    }

    @objc func handleLinkNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        didMarkdownLink(notification)
    }

    @objc func handleCodeBlockNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        didMarkdownCodeBlock(nil)
    }

    @objc func handleHorizontalRuleNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        didMarkdownHorizontalRule(nil)
    }

    @objc func handleImageNotification(_ notification: Notification) {
        guard editorIsFirstResponder else { return }
        didMarkdownImage(notification)
    }

    @objc func handleAppearanceChange(_ notification: Notification) {
        guard let tv = textView else { return }
        // Only react if the notification came from our own text view or from nil (system-wide)
        if let sender = notification.object as? NSTextView, sender !== tv {
            return
        }
        let fullRange = NSRange(location: 0, length: (tv.string as NSString).length)
        restyleTextView(tv, paragraphCandidates: [fullRange])
    }
}
