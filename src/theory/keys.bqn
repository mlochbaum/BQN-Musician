⟨Keys⟩ ← {
load ← •Import "../../BQNoise/load.bqn"
f‿s‿m‿o ← Load¨ "filter"‿"scale"‿"mix"‿"oscillator"
fr ← 44100

Key ← {
  d ← ¯2e¯4×1-4÷√𝕩
  k ← ÷ 10 × 0.2 + ×˜ 0.17 + (2⋆d×↕𝕨) × 0.25 o.Sine 𝕩×1+÷4+8÷˜↕𝕨
  (⌽↕⊸÷300) m.Fadeback 10 f.Hp2 8‿4000 f.Hshelf (↕⊸÷10) m.Fadefront k
}

notes ← ∾"0a"+⟜↕¨10‿26
Keys ⇐ {
  root ← s.Note"A2"
  m ← ¬ 𝕩∊"{}"
  beat ← ⌊ (fr÷4) × 2 ⋆ m / +`-˜˝"{}"=⌜𝕩
  t ← (≠notes) > n ← notes ⊐ m/𝕩
  ∾ ⟨0⥊˜⊑t⟩ ∾ ((+´beat)⊸«⊸-t/+`»beat) Key¨ (t/n) s.Trans root
}
}
