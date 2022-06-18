ring ← {
r ← 60 ⋄ nr ← 12
size ⇐ r+nr+4

Draw ⇐ {
  dir ← r×(•math.Sin ⋈¨ ·-•math.Cos) (2×π) × ↕⊸÷≠𝕩
  ⟨
    "stroke-width=2|stroke=currentColor" Ge ⟨
      ("circle"At"fill=none") Elt "r"⋈FmtNum r
      "class=unset"‿"class=set" Ge¨ 𝕩 ⊔ ("circle" Elt "r"‿"cx"‿"cy"≍˘·FmtNum nr⊸∾)¨ dir
    ⟩
    "text-anchor=middle|class=set" Ge 𝕩 / dir Pos⊸Text¨ FmtNum ↕≠𝕩
  ⟩
}

DrawRow ⇐ {
  rp ← 5 + size
  DrawSc ← {
    tc ← "text-anchor=middle|fill=currentColor"
    t ← tc Ge (-∘≠↑(-⊸⋈8+rp)˙)⊸((Pos 0⊸⋈)⊸Text¨) 1↓𝕩
    ("transform=translate("∾(Fmt𝕨)∾")") Ge (Draw ⊑𝕩) ∾ <t
  }
  a ← ⥊0≍˘24×(-2⊸≤)⊸⋈0⌈´1-˜≠¨𝕩
  (a+⥊¯1‿2×⌜⟨8+rp×3.6⌈≠𝕩,rp⟩) SVG (⋈⟜0¨rp×(2×↕)⊸¬≠𝕩) DrawSc¨ 𝕩
}
}
