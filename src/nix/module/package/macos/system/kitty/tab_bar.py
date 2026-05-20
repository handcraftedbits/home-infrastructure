import os
import socket
import subprocess

from kitty.boss import get_boss
from kitty.fast_data_types import Screen
from kitty.tab_bar import (DrawData, ExtraData, TabBarData, TabAccessor, as_rgb)

# Constants

# Powerline glyphs
LEFT_ARROW = "\uE0B2"
RIGHT_ARROW = "\uE0B0"
RIGHT_ARROW_THIN = "\uE0B1"

# Palette
BG_ACTIVE = 0x000000
BG_BAR = 0x5F87AF
BG_HOST = 0xAFAF87
FG_HOST = 0x080808
FG_TEXT = 0xDADADA

HOSTNAME = socket.gethostname().split(".")[0]

def draw_hostname(screen: Screen) -> None:
    label = f" {HOSTNAME} "

    # Width: arrow + 2 black cells + arrow + label
    block_width = 1 + 2 + 1 + len(label)
    target_col = screen.columns - block_width

    if target_col <= screen.cursor.x:
        return

    # Pad with bar background up to the wedge
    set_text_attributes(screen, BG_BAR, BG_BAR)
    screen.draw(" " * (target_col - screen.cursor.x))

    # First arrow: blue -> black wedge starts
    set_text_attributes(screen, BG_ACTIVE, BG_BAR)
    screen.draw(LEFT_ARROW)

    # Two solid black cells — widens the wedge to match tmux
    set_text_attributes(screen, BG_ACTIVE, BG_ACTIVE)
    screen.draw("  ")

    # Second arrow: black wedge -> cream pill
    set_text_attributes(screen, BG_HOST, BG_ACTIVE)
    screen.draw(LEFT_ARROW)

    # Cream pill with hostname
    set_text_attributes(screen, FG_HOST, BG_HOST)
    screen.draw(label)

def draw_session_pill(screen: Screen, index: int) -> None:
    if index != 1:
        return

    label = f" {session_label()} "

    # Cream pill
    set_text_attributes(screen, FG_HOST, BG_HOST)
    screen.draw(label)

    # Right arrow: cream -> blue
    set_text_attributes(screen, BG_HOST, BG_BAR)
    screen.draw(RIGHT_ARROW)

def draw_tab(draw_data: DrawData, screen: Screen, tab: TabBarData, before: int, max_title_length: int, index: int, is_last: bool,
             extra_data: ExtraData) -> int:
    # Leading session pill (first tab only)
    draw_session_pill(screen, index)

    is_active = tab.is_active
    bg = BG_ACTIVE if is_active else BG_BAR
    fg = FG_TEXT

    # If we just drew the session pill and this tab is active, we need a bar->black transition arrow first. Otherwise just continue.
    if index == 1 and is_active:
        set_text_attributes(screen, BG_BAR, BG_ACTIVE)

        # We're already on blue from the session pill's trailing arrow.
        # Need to transition blue -> black for the active tab.
        set_text_attributes(screen, BG_BAR, BG_ACTIVE)
        screen.draw(RIGHT_ARROW)

    # Tab body: " N › label "
    set_text_attributes(screen, fg, bg)
    screen.draw(f" {index - 1} ")
    set_text_attributes(screen, fg, bg)
    screen.draw(RIGHT_ARROW_THIN)
    set_text_attributes(screen, fg, bg)
    screen.draw(f" {tab_label(tab)} ")

    # Separator to next segment
    if is_last:
        if is_active:
            set_text_attributes(screen, bg, BG_BAR)
            screen.draw(RIGHT_ARROW)

        draw_hostname(screen)
    else:
        next_tab = extra_data.next_tab
        next_active = next_tab.is_active if next_tab is not None else False
        next_bg = BG_ACTIVE if next_active else BG_BAR

        if bg == next_bg:
            set_text_attributes(screen, fg, bg)
            screen.draw(RIGHT_ARROW_THIN)
        else:
            set_text_attributes(screen, bg, next_bg)
            screen.draw(RIGHT_ARROW)

    return screen.cursor.x

def foreground_process(tab: TabBarData) -> str:
    try:
        kt = get_boss().tab_for_id(tab.tab_id)

        if kt is None:
            return ""

        w = kt.active_window

        if w is None or w.child is None:
            return ""

        fg_pgid = os.tcgetpgrp(w.child.child_fd)

        if fg_pgid <= 0:
            return ""

        return process_name(fg_pgid)
    except Exception:
        return ""

def is_manually_titled(tab: TabBarData) -> bool:
    try:
        kt = get_boss().tab_for_id(tab.tab_id)

        if kt is None:
            return False

        # When user runs set_tab_title, kitty stores it on the tab's `name` attr and uses it in preference to the active window's title.
        return bool(getattr(kt, "name", "").strip())
    except Exception:
        return False

def process_name(pid: int) -> str:
    try:
        out = subprocess.run(["ps", "-o", "args=", "-p", str(pid)], capture_output=True, text=True, timeout=0.2)
        parts = out.stdout.strip().split()

        if not parts:
            return ""

        name = parts[0].rsplit("/", 1)[-1]

        if name == "kitten" and len(parts) > 1:
            return parts[1].rsplit("/", 1)[-1]

        return name
    except Exception:
        return ""

def session_label() -> str:
    try:
        boss = get_boss()
        # Find which OS window we're in by walking tab managers
        for i, tm in enumerate(boss.os_window_map.values()):
            if tm is boss.active_tab_manager:
                return str(i)
    except Exception:
        pass

    return "0"

def set_text_attributes(screen: Screen, fg: int, bg: int) -> None:
    screen.cursor.fg = as_rgb(fg)
    screen.cursor.bg = as_rgb(bg)
    screen.cursor.bold = False
    screen.cursor.italic = False

def tab_label(tab: TabBarData) -> str:
    # Check for manual rename first
    if is_manually_titled(tab):
        try:
            kt = get_boss().tab_for_id(tab.tab_id)
            name = (getattr(kt, "name", "") or "").strip()

            if name:
                return name
        except Exception:
            pass

    # Otherwise, foreground process detection as before
    name = foreground_process(tab)

    if not name:
        try:
            name = (TabAccessor(tab.tab_id).active_exe or "").rsplit("/", 1)[-1]
        except Exception:
            name = ""

    if name.startswith("-"):
        name = name[1:]

    name = name.split()[0] if name else ""

    return name or "sh"
