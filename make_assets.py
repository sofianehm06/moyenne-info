# -*- coding: utf-8 -*-
"""Génère les assets Play Store pour Odisef Moyenne — philosophie « Studious Ascent »."""
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter

FONTS = (r"C:\Users\pc\AppData\Roaming\Claude\local-agent-mode-sessions\skills-plugin"
         r"\57df7728-3e2d-44dd-b599-81bc08040128\91f0aa80-ee39-47c5-9527-4023548aee05"
         r"\skills\canvas-design\canvas-fonts")

def font(name, size):
    return ImageFont.truetype(f"{FONTS}\\{name}", size)

# Palette
TEAL   = (11, 61, 46)      # #0B3D2E
EMER_D = (5, 150, 105)     # #059669
EMER   = (16, 185, 129)    # #10B981
SPRING = (52, 211, 153)    # #34D399
PAPER  = (245, 247, 242)   # #F5F7F2
GOLD   = (232, 199, 107)   # #E8C76B

def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))

def vgrad(size, top, bot):
    w, h = size
    img = Image.new("RGB", size)
    px = img.load()
    for y in range(h):
        c = lerp(top, bot, y / (h - 1))
        for x in range(w):
            px[x, y] = c
    return img

def radial_glow(size, center, radius, color, max_alpha):
    """Soft radial light overlay (RGBA)."""
    w, h = size
    g = Image.new("L", size, 0)
    gd = ImageDraw.Draw(g)
    steps = 60
    for i in range(steps, 0, -1):
        r = radius * i / steps
        a = int(max_alpha * (1 - i / steps))
        gd.ellipse([center[0]-r, center[1]-r, center[0]+r, center[1]+r], fill=a)
    glow = Image.new("RGBA", size, color + (0,))
    glow.putalpha(g)
    return glow

def smooth_curve_points(pts, samples=24):
    """Catmull-Rom spline through pts."""
    out = []
    p = [pts[0]] + list(pts) + [pts[-1]]
    for i in range(1, len(p) - 2):
        p0, p1, p2, p3 = p[i-1], p[i], p[i+1], p[i+2]
        for s in range(samples):
            t = s / samples
            t2, t3 = t*t, t*t*t
            x = 0.5*((2*p1[0]) + (-p0[0]+p2[0])*t +
                     (2*p0[0]-5*p1[0]+4*p2[0]-p3[0])*t2 +
                     (-p0[0]+3*p1[0]-3*p2[0]+p3[0])*t3)
            y = 0.5*((2*p1[1]) + (-p0[1]+p2[1])*t +
                     (2*p0[1]-5*p1[1]+4*p2[1]-p3[1])*t2 +
                     (-p0[1]+3*p1[1]-3*p2[1]+p3[1])*t3)
            out.append((x, y))
    out.append(pts[-1])
    return out

def draw_cap(d, cx, cy, scale, board_col, base_col, btn_col, tassel_col,
             tassel_hang=58):
    """Mortarboard graduation cap centered at (cx, cy)."""
    hw = 138 * scale   # board half width
    hh = 64 * scale    # board half height (perspective)
    # cap base (head) — trapezoid behind/under board
    bw_top = 56 * scale
    bw_bot = 78 * scale
    base_top = cy + 6 * scale
    base_bot = cy + 60 * scale
    d.polygon([
        (cx - bw_top, base_top), (cx + bw_top, base_top),
        (cx + bw_bot, base_bot), (cx - bw_bot, base_bot)
    ], fill=base_col)
    # rounded bottom of base
    d.ellipse([cx - bw_bot, base_bot - 20*scale, cx + bw_bot, base_bot + 20*scale],
              fill=base_col)
    # mortarboard (diamond)
    d.polygon([
        (cx, cy - hh), (cx + hw, cy), (cx, cy + hh), (cx - hw, cy)
    ], fill=board_col)
    # center button
    d.ellipse([cx - 13*scale, cy - 13*scale, cx + 13*scale, cy + 13*scale],
              fill=btn_col)
    # tassel: from center to right corner, then a short clean hang
    tx, ty = cx + hw * 0.66, cy + hh * 0.34
    d.line([(cx, cy), (tx, ty)], fill=tassel_col, width=int(8*scale))
    d.line([(tx, ty), (tx, ty + tassel_hang*scale)], fill=tassel_col,
           width=int(8*scale))
    # tassel knot + short fringe
    kny = ty + tassel_hang*scale
    d.ellipse([tx - 10*scale, kny - 2*scale, tx + 10*scale, kny + 18*scale],
              fill=tassel_col)
    for k in range(-2, 3):
        d.line([(tx, kny + 12*scale), (tx + k*5*scale, kny + 34*scale)],
               fill=tassel_col, width=int(4*scale))

# ─────────────────────────────────────────────────────────────────────────
# ASSET 1 — ICON 512×512
# ─────────────────────────────────────────────────────────────────────────
def build_icon(path):
    SS = 3
    S = 512 * SS
    img = vgrad((S, S), TEAL, EMER_D)
    # glow from lower center
    glow = radial_glow((S, S), (S*0.5, S*0.62), S*0.55, SPRING, 90)
    img = Image.alpha_composite(img.convert("RGBA"), glow)
    d = ImageDraw.Draw(img, "RGBA")

    cx, cy = S*0.5, S*0.36

    # graduation cap (hero) — short tassel so nothing collides below
    draw_cap(d, cx, cy, SS, PAPER, lerp(PAPER, TEAL, 0.12), EMER_D, GOLD,
             tassel_hang=52)

    # ascending curve crossing the 10/20 threshold — bottom zone, well clear
    base_y = S*0.80
    pts = [(S*0.18, base_y+S*0.015), (S*0.36, base_y-S*0.01),
           (S*0.54, base_y-S*0.03), (S*0.70, base_y-S*0.075),
           (S*0.83, base_y-S*0.125)]
    curve = smooth_curve_points(pts)
    # threshold dashed line (the implicit 10/20)
    ty = base_y - S*0.052
    x = S*0.15
    while x < S*0.86:
        d.line([(x, ty), (x+S*0.024, ty)], fill=PAPER+(65,), width=int(3*SS))
        x += S*0.044
    d.line(curve, fill=GOLD, width=int(13*SS), joint="curve")
    ex, ey = curve[-1]
    d.ellipse([ex-14*SS, ey-14*SS, ex+14*SS, ey+14*SS], fill=PAPER)
    d.ellipse([ex-7*SS, ey-7*SS, ex+7*SS, ey+7*SS], fill=GOLD)

    img = img.convert("RGB").resize((512, 512), Image.LANCZOS)
    img.save(path)
    print("icon ->", path)

# ─────────────────────────────────────────────────────────────────────────
# ASSET 2 — FEATURE GRAPHIC 1024×500
# ─────────────────────────────────────────────────────────────────────────
def build_feature(path):
    SS = 2
    W, H = 1024*SS, 500*SS
    img = vgrad((W, H), TEAL, EMER_D)
    glow = radial_glow((W, H), (W*0.30, H*0.55), H*1.05, SPRING, 70)
    img = Image.alpha_composite(img.convert("RGBA"), glow)
    d = ImageDraw.Draw(img, "RGBA")

    # faint grid (notebook ledger)
    for gx in range(0, W, 46*SS):
        d.line([(gx, 0), (gx, H)], fill=PAPER+(10,), width=1*SS)
    for gy in range(0, H, 46*SS):
        d.line([(0, gy), (W, gy)], fill=PAPER+(10,), width=1*SS)

    # left emblem: cap + curve
    ex, ey = W*0.165, H*0.40
    base_y = H*0.78
    pts = [(W*0.04, base_y+H*0.03), (W*0.11, base_y-H*0.02),
           (W*0.19, base_y-H*0.05), (W*0.27, base_y-H*0.16),
           (W*0.31, base_y-H*0.27)]
    curve = smooth_curve_points(pts)
    ty = base_y - H*0.075
    x = W*0.03
    while x < W*0.31:
        d.line([(x, ty), (x+W*0.013, ty)], fill=PAPER+(60,), width=int(2*SS))
        x += W*0.026
    d.line(curve, fill=GOLD, width=int(9*SS), joint="curve")
    cxp, cyp = curve[-1]
    d.ellipse([cxp-9*SS, cyp-9*SS, cxp+9*SS, cyp+9*SS], fill=PAPER)
    d.ellipse([cxp-5*SS, cyp-5*SS, cxp+5*SS, cyp+5*SS], fill=GOLD)
    draw_cap(d, ex, ey, SS*0.78, PAPER, lerp(PAPER, TEAL, 0.12), EMER_D, GOLD)

    # wordmark
    f_brand = font("BricolageGrotesque-Bold.ttf", 96*SS)
    f_mono  = font("JetBrainsMono-Regular.ttf", 24*SS)
    f_by    = font("BricolageGrotesque-Regular.ttf", 26*SS)

    tx = W*0.36
    d.text((tx, H*0.20), "Moyenne", font=f_brand, fill=PAPER)
    d.text((tx, H*0.20 + 100*SS), "Info", font=f_brand, fill=GOLD)
    # byline éditeur
    bb_info = d.textbbox((0, 0), "Info", font=f_brand)
    d.text((tx + (bb_info[2]-bb_info[0]) + 22*SS, H*0.20 + 138*SS),
           "par Odisef", font=f_by, fill=lerp(PAPER, EMER, 0.25))

    # tagline — auto-fit so it never overflows the right edge
    tagline = "Calcule ta moyenne — Licence · Master · Ingéniorat"
    avail = (W * 0.975) - tx
    fs = 34*SS
    while fs > 16*SS:
        f_sub = font("BricolageGrotesque-Regular.ttf", int(fs))
        bb = d.textbbox((0, 0), tagline, font=f_sub)
        if (bb[2] - bb[0]) <= avail:
            break
        fs -= 1*SS
    d.text((tx, H*0.20 + 214*SS), tagline, font=f_sub,
           fill=lerp(PAPER, EMER, 0.10))

    # marginalia (top-right, clinical) — glyphes sûrs uniquement
    marks = ["Σ", "x / 20", "≥ 10", "30 crédits"]
    mx = W*0.965
    my = H*0.12
    for m in marks:
        bb = d.textbbox((0, 0), m, font=f_mono)
        w = bb[2] - bb[0]
        d.text((mx - w, my), m, font=f_mono, fill=PAPER+(115,))
        my += 36*SS

    img = img.convert("RGB").resize((1024, 500), Image.LANCZOS)
    img.save(path)
    print("feature ->", path)

build_icon(r"D:\moyenne\play_icon_512.png")
build_feature(r"D:\moyenne\play_feature_1024x500.png")
print("DONE")
