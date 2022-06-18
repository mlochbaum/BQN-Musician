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
}
