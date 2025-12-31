# Day 1 Plan

**Date:** December 31, 2024
**Goal:** Convert app to menubar-only with basic icon and menu
**Time Estimate:** ~8 hours

---

## Definition of Done

Today is complete when:

- [ ] App runs in menubar (no dock icon visible)
- [ ] Menubar icon displays (tomato emoji or placeholder)
- [ ] Clicking icon shows menu with "Quit" option
- [ ] App stays running when all windows closed
- [ ] Menu is clickable and "Quit" works correctly
- [ ] Build: 0 errors, 0 warnings

---

## Tasks

### Task 1: Configure Info.plist for Menubar-Only App
**Estimate:** ~1.5 hours

**What:** Set LSUIElement = YES in Info.plist to hide dock icon and convert to background/menubar app
**Why:** Foundation for menubar-only app - must be done first before any AppKit integration
**Acceptance:**
- [ ] LSUIElement set to YES in Info.plist
- [ ] App builds and runs without showing dock icon
- [ ] App icon removed from Dock when running
- [ ] App still appears in Activity Monitor

---

### Task 2: Create AppDelegate with NSStatusBar
**Estimate:** ~3 hours

**What:** Create AppDelegate.swift with NSStatusBar integration, add menubar icon and basic menu
**Why:** Core menubar functionality - this is the primary UI for the app
**Acceptance:**
- [ ] AppDelegate.swift created with NSApplicationDelegate protocol
- [ ] NSStatusBar item created and visible in menubar
- [ ] Menubar icon displays (tomato emoji "🍅" or SF Symbol)
- [ ] Basic NSMenu with "Quit" menu item created
- [ ] Quit menu item calls NSApplication.shared.terminate()

---

### Task 3: Refactor pomodomoreApp.swift for Menubar Lifecycle
**Estimate:** ~2.5 hours

**What:** Update main app structure to use AppDelegate, remove WindowGroup if not needed, ensure app stays alive
**Why:** SwiftUI app needs to delegate lifecycle to AppKit AppDelegate for menubar behavior
**Acceptance:**
- [ ] pomodomoreApp.swift uses @NSApplicationDelegateAdaptor
- [ ] AppDelegate properly initialized and connected
- [ ] App stays running when no windows are open
- [ ] App lifecycle controlled by menubar (doesn't quit when window closed)
- [ ] Remove or comment out SwiftData boilerplate (Item.swift, modelContainer) if present

---

### Task 4: Manual Testing & Quality Check
**Estimate:** ~1 hour

**What:** Manual testing of menubar functionality and build verification
**Tests:**
- Click menubar icon → menu appears
- Click "Quit" → app terminates cleanly
- Launch app → no dock icon appears
- App runs in background (check Activity Monitor)
- Menu responds to clicks (no lag/crashes)
**Build:**
- Run Product → Clean Build Folder
- Build project: 0 errors, 0 warnings
- Test on current macOS version

---

## Implementation Notes

**Known challenges:**
- SwiftUI + AppKit hybrid: Need @NSApplicationDelegateAdaptor to bridge SwiftUI app to AppKit AppDelegate
- Icon choice: Start with emoji "🍅", can replace with SF Symbol or custom asset later
- Lifecycle: App must not terminate when last window closes (need applicationShouldTerminateAfterLastWindowClosed)

**Architecture:**
- Hybrid approach: SwiftUI app shell + AppKit AppDelegate for menubar
- AppDelegate manages: NSStatusBar, NSMenu, lifecycle
- SwiftUI will be used for timer window (Day 2+)

**Files:**
- **Create:** `AppDelegate.swift` (NSApplicationDelegate, NSStatusBar setup)
- **Modify:** `pomodomoreApp.swift` (add @NSApplicationDelegateAdaptor)
- **Modify:** `Info.plist` (add LSUIElement = YES)
- **Optional cleanup:** Remove/comment `Item.swift` and SwiftData references if present

**Key Code Patterns:**
```swift
// Info.plist
LSUIElement = YES (Boolean)

// AppDelegate.swift structure
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create status bar item
        // Create menu
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false  // Keep app running
    }
}

// pomodomoreApp.swift
@main
struct pomodomoreApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene { ... }
}
```

---

## Execution (Fill During/After Work)

**Start:** 10:00 PM

**Progress:**
- 10:00 PM — Started Task 1: Info.plist configuration
- 10:05 PM — Created Info.plist with LSUIElement = YES
- 10:10 PM — Started Task 2: AppDelegate creation
- 10:25 PM — AppDelegate complete with NSStatusBar and menu
- 10:30 PM — Started Task 3: Refactor pomodomoreApp.swift
- 10:40 PM — Added @NSApplicationDelegateAdaptor, commented out SwiftData
- 10:45 PM — Build successful - 0 errors, 0 warnings
- 10:50 PM — Manual testing complete - all tests passed
- 11:00 PM — Documentation updated

**Actual Time:** ~2 hours (estimate: ~8)

**Tasks:**
- [x] Task 1: Configure Info.plist ✅
- [x] Task 2: Create AppDelegate with NSStatusBar ✅
- [x] Task 3: Refactor pomodomoreApp.swift ✅
- [x] Task 4: Manual Testing & Quality Check ✅

**Quality:**
- ✅ Build: 0 errors, 0 warnings
- ✅ Tests: Manual verification complete
- ✅ Menubar: Icon visible (🍅) and menu functional

**Blockers:** None

**Learnings:**
- SwiftUI + AppKit hybrid is straightforward with @NSApplicationDelegateAdaptor
- LSUIElement = YES successfully hides dock icon
- NSStatusBar API is clean and easy to use
- Task completed much faster than estimated - menubar setup is simpler than anticipated

---

**Complete:** 11:00 PM
