import Data.List
import Foreign.C.Types (CLong)
import System.Exit (exitSuccess)
import XMonad
import XMonad.Actions.OnScreen
import XMonad.Actions.UpdatePointer
import XMonad.Config.Desktop (desktopLayoutModifiers)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FloatConfigureReq
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Place
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)
import XMonad.Util.SpawnOnce
import qualified Data.Map as M
import qualified XMonad.StackSet as W

main :: IO ()
main = xmonad $ withUrgencyHookC BorderUrgencyHook { urgencyBorderColor = "#cc9393" } def { suppressWhen = Focused } $ ewmhFullscreen . ewmh $ docks $ def
    { modMask            = mod4Mask
    , terminal           = "st"
    , keys               = myKeys
    , mouseBindings      = myMouseBindings
    , borderWidth        = 2
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , workspaces         = myWorkspaces
    , layoutHook         = desktopLayoutModifiers
                           (avoidStruts $ smartBorders $
                             onWorkspaces ["chat", "internets"] (myTabsLayout ||| myTiledLayout) $
                             (myTiledLayout ||| myTabsLayout))
    , manageHook         = myManageHook <+> placeHook myPlacement <> manageDocks
    , handleEventHook    = myEventHook
    , logHook            = myLogHook
    , startupHook        = myStartupHook
    }

myKeys conf@(XConfig {modMask = modKey}) = M.fromList $
    [ ((modKey .|. shiftMask, xK_Print ), spawn "sleep 1; scrot -d 1 -s -e 'mv $f ~/Images/screenshots/ 2>/dev/null'")
    , ((modKey .|. shiftMask, xK_c     ), kill)
    , ((modKey .|. shiftMask, xK_j     ), windows W.swapDown)
    , ((modKey .|. shiftMask, xK_k     ), windows W.swapUp)
    , ((modKey .|. shiftMask, xK_m     ), windows W.swapMaster)
    , ((modKey .|. shiftMask, xK_q     ), io exitSuccess)
    , ((modKey .|. shiftMask, xK_r     ), spawn "xmonad --recompile; xmonad --restart")
    , ((modKey,               xK_Escape), spawn "dunstctl close")
    , ((modKey,               xK_Print ), spawn "scrot -e 'mv $f ~/Images/screenshots/ 2>/dev/null'")
    , ((modKey,               xK_Return), spawn $ XMonad.terminal conf)
    , ((modKey,               xK_b     ), spawn "~/bin/block-screen.sh")
    , ((modKey,               xK_comma ), sendMessage (IncMasterN 1))
    , ((modKey,               xK_e     ), spawn "pcmanfm-qt")
    , ((modKey,               xK_h     ), sendMessage Shrink)
    , ((modKey,               xK_j     ), windows W.focusDown)
    , ((modKey,               xK_k     ), windows W.focusUp)
    , ((modKey,               xK_l     ), sendMessage Expand)
    , ((modKey,               xK_m     ), windows W.focusMaster)
    , ((modKey,               xK_period), sendMessage (IncMasterN (-1)))
    , ((modKey,               xK_q     ), spawn "emacs")
    , ((modKey,               xK_r     ), spawn "rofi -show run -run-list-command $HOME/.zsh/aliases.sh -run-command \"/bin/zsh -i -c '{cmd}'\" -fuzzy -levenshtein-sort -cache-dir $HOME/.local/share/rofi")
    , ((modKey,               xK_space ), sendMessage NextLayout)
    , ((modKey,               xK_t     ), withFocused $ windows . W.sink)
    , ((modKey,               xK_w     ), spawn "qutebrowser")
    ]
    ++
    [((m .|. modKey, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_5]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++
    [((m .|. modKey, k), screenWorkspace sc >>= flip whenJust (windows . f))
        | (k, sc) <- zip [xK_bracketleft, xK_bracketright] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    , ((modm, button8), (\w -> windows W.swapDown))
    , ((modm, button9), (\w -> windows W.swapUp))
    ]

button6     =  6 :: Button
button7     =  7 :: Button
button8     =  8 :: Button
button9     =  9 :: Button
button10    = 10 :: Button
button11    = 11 :: Button
button12    = 12 :: Button
button13    = 13 :: Button
button14    = 14 :: Button
button15    = 15 :: Button


myNormalBorderColor  = "#3f3f3f"
myFocusedBorderColor = "#f5deb3"

myWorkspaces = ["default", "chat", "coding", "internets", "todo"]

myTiledLayout = Tall nmaster delta ratio
  where
    nmaster = 1
    ratio   = 5/7
    delta   = 1/100

myTabsLayout = tabbed shrinkText def
    { fontName = "xft:FuturaBookC Regular:size=12"
    }

myPlacement = fixed (0.5, 0.5)

myManageHook = composeAll
    [ checkDialog                   --> doCenterFloat
    , className =? "Xmessage"       --> doFloat
    , className =? "Display"        --> doFloat
    , className =? "mpv"            --> doFloat
    , className =? "vlc"            --> doFloat
    , className =? "Pavucontrol"    --> doCenterFloat
    , className =? "Yad"            --> doCenterFloat
    , className =? "Emacs"          --> doShift "coding"
    , className =? "qutebrowser"    --> doShift "internets"
    , className =? "obs"            --> doShift "internets"
    , className =? "Gsimplecal"     --> placeHook (fixed (1, 0.98))
    , resource  =? "desktop_window" --> doIgnore
    , isFullscreen                  --> doFullFloat
    , (className =? "zoom") <&&> shouldFloat <$> title --> doFloat
    , (className =? "zoom") <&&> shouldSink <$> title  --> doSink
    ]
    where
      role = stringProperty "WM_WINDOW_ROLE"
      zoomTileTitles =
        [ "Zoom - Free Account", -- main window
          "Zoom", -- meeting window on creation
          "Zoom Meeting" -- meeting window shortly after creation
        ]
      shouldFloat title = title `notElem` zoomTileTitles
      shouldSink title = title `elem` zoomTileTitles
      doSink = (ask >>= doF . W.sink) <+> doF W.swapDown

myEventHook = mconcat
    [ fixSteamFlicker ]

myLogHook = whenX (gets windowset >>=
                   \ws -> pure $ (maybe 0 W.focus . W.stack . W.workspace . W.current) ws
                          `M.notMember`
                          W.floating ws) $
  updatePointer (0.5,0.5) (0,0)

getProp :: Atom -> Window -> X (Maybe [CLong])
getProp a w = withDisplay $ \dpy -> io $ getWindowProperty32 dpy a w

checkAtom name value = ask >>= \w -> liftX $ do
          a <- getAtom name
          val <- getAtom value
          mbr <- getProp a w
          case mbr of
            Just [r] -> return $ elem (fromIntegral r) [val]
            _ -> return False

checkDialog = checkAtom "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_DIALOG"

myStartupHook = do
  windows (greedyViewOnScreen 0 "coding")
  windows (greedyViewOnScreen 1 "internets")
  spawn "~/.fehbg"
  spawn "xset r rate 190 25"
  spawn "xsetroot -cursor_name left_ptr"
  spawnOnce "polybar top"
  spawnOnce "dex -a -e xmonad"
  spawnOnce "xfce4-screensaver"
  spawnOnce "sleep 1; polybar bottom"
  spawnOnce "sleep 1; polybar bottom2"
