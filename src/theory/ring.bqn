ring ← {
r ← 60 ⋄ nr ← 12
size ⇐ r+nr+4

Draw ⇐ {
  dir ← r×(•math.Sin ⋈¨ ·-•math.Cos) (2×π) × ↕⊸÷≠𝕩
  ⟨
    "stroke-width=2|stroke=currentColor" Ge ({dir𝕎𝕩}⟜𝕩𝕨)⊢⊘∾⟨
      ("circle"At"fill=none") Elt "r"⋈FmtNum r
      "class=unset"‿"class=set" Ge¨ 𝕩 ⊔ ("circle" Elt "r"‿"cx"‿"cy"≍˘·FmtNum nr⊸∾)¨ dir
    ⟩
    "text-anchor=middle|class=set" Ge 𝕩 / dir Pos⊸Text¨ FmtNum ↕≠𝕩
  ⟩
}

_extDrawRow ← { 𝕨 ext _𝕣 𝕩:
  rp ← 5 + size
  DrawSc ← {
    tc ← "text-anchor=middle|fill=currentColor"
    t ← tc Ge (-∘≠↑(-⊸⋈8+rp)˙)⊸((Pos 0⊸⋈)⊸Text¨) 1↓𝕩
    ("transform=translate("∾(Fmt𝕨)∾")") Ge (ext Draw ⊑𝕩) ∾ <t
  }
  a ← 24×(-2⊸≤)⊸⋈0⌈´1-˜≠¨𝕩
  tr ← ⋈⟜0¨rp×(2×↕)⊸¬w←≠𝕩
  {tr↩2×(rp+12)×𝕩 ⋄ d←⌈´|tr ⋄ w↩1+rp÷˜⊑d ⋄ a+↩¯1‿2×1⊑d } 𝕨
  (⥊(0≍˘a)+¯1‿2×⌜⟨8+rp×3.6⌈w,rp⟩) SVG tr DrawSc¨ 𝕩
}

DrawRow ⇐ ⟨⟩_extDrawRow

DrawTertianRow ⇐ { dir 𝕊 𝕩:
  t ← 2↑(3‿4⊐(≠𝕩)|2⊸⌽⊸-/𝕩)⊔∾¨⟜(2⊸⌽)0.93×𝕩/dir
  P ← {("path"At"class="∾𝕨) Elt "d"⋈ ∾(FmtNum∾¨˜"M L "⥊˜≢) ∾𝕩}
  "opacity=0.8" Ge ⌽"yellow"‿"green" P¨ t
}_extDrawRow
}
