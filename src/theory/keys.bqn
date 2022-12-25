⟨Keys⟩ ← {
load ← •Import "../../BQNoise/load.bqn"
f‿s‿m ← Load¨ "filter"‿"scale"‿"mix"
fr ← 44100

Rand ← 1-˜2×{𝕩 (•MakeRand 1).Range 0}
Pink ← {÷⟜(⌈´|) +` 𝕩 ↑ ⥊∘⍉∘≍´⌽ -⟜«∘Rand¨ (1⌈↕∘⌈)⌾(2⋆⁼⊢)2⌈𝕩}∘≠
Pluck ← { len 𝕊 f: # Karplus-Stong
  p ← ⌊fr÷f
  w ← ∾ ((2⋆-1+÷10×f⋆0.2)×1⊸⌽⊸+)⍟(↕⌈len÷p) Pink p⥊0
  (¬×˜↕⊸÷200) m.Fadeback len ↑ w
}

KF ← 3 × 80 f.Hp1 ¯4‿1000 f.Hshelf 180 f.Lp1 ⊢
notes ← ∾"0a"+⟜↕¨10‿26
Keys ⇐ {
  root ← s.Note"A2"
  beat ← fr÷4
  t ← (≠notes) > n ← notes ⊐ 𝕩
  KF ∾ ⟨0⥊˜⊑t⟩ ∾ (beat×(≠𝕩)⊸«⊸-/t) Pluck¨ (t/n) s.Trans root
}
}
