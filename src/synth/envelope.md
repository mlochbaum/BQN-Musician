# Envelopes

The envelope of a sound is how its volume changes as it's played, a sort of overall contour. A typical way to make a synthesized note is to multiply a continuous tone (whether an [oscillator](oscillator.md) or something more complicated) by an envelope signal. To avoid changing that tone, the envelope shouldn't have any audible content—the volume should change gradually enough that it doesn't really contain frequencies above 20Hz. But the right envelope affects how the sound is perceived to a surprising degree, and can help a track sound more natural and compelling. This matters more in a dense mix: if one line just isn't fitting in, adjusting the envelope is something to try.

        s ← 44100  # Samples in one second
        tone ← •math.Sin (2×π) × 440 × ↕⊸÷ s
        # The pure tone
        Play tone
        # With some sample envelopes applied
        Play ∾˜ {0.999⋆↕≠𝕩}⊸× tone
        Play ∾˜ {0.9999⋆↕≠𝕩}⊸× tone
        Play ∾˜ {i←↕≠𝕩⋄(i÷300)⌊(⌽0⌈4-˜i÷2e3)⌊÷1+2e¯4×i}⊸× tone

(One comment on composition: silence is a big deal! The riffs that really land often have rests where you'd expect a note, or a carefully placed stacatto. Is that one change you're searching for to add, or to take away?)

## Decay

Like a sine wave is the most basic oscillator, I think of exponential decay as the most basic envelope. They're pretty closely related: a perfect oscillator gives you a sine wave, but one with friction gives you a sine with exponential decay.

<!--GEN
Pa ← "path"At"stroke=currentColor|"⊸∾
Path ← (Pa"stroke-width=2") Elt "d"⊸⋈
dim ← 256‿64
gr ← "text-anchor=middle|fill=none"
base ← (Pa"stroke-width=1|stroke-dasharray=5 7") Elt "d"⋈'M'⌾⊑∾⥊ ⍉"L "∾¨ FmtNum dim×∨⌜˜↕2
Plot ← {
  (⥊-˜`¯30‿¯30≍30‿4+dim+20) SVG gr Ge ⟨
    ("text" Attr "fill"‿"currentColor"∾Pos ⟨⊑dim÷2,¯10⟩) Enc 𝕨
    Path 'M'⌾⊑∾⥊ ⍉"L "∾¨ FmtNum dim×¬⌾(1⊸⊏)𝕩
    base
  ⟩
}
"Exponential decay" Plot (⊢ ≍ 0.05⊸⋆) ↕⊸∾⊸÷40
-->

        Play (0.99994 ⋆ ↕4×s) × (4×s) ⥊ tone

The start is too sharp to match anything real (we'll get to that), but eventually it starts to sound like a tuning fork, or maybe some sort of chime. These are very nearly perfect oscillators with friction!

The envelope `0.99994 ⋆ ↕4×s` simply starts at one and decreases by a factor of `0.99994` each time. But that constant isn't very nice to work with, because counting nines is no fun. What I do instead of changing the base of the exponent is to use a fixed base and multiply the exponential part. This is equivalent to changing the base because `b⋆c×i` is `(b⋆c)⋆i`. Another thing I'll do while I'm cleaning up the code is avoid repeating the length. I'll make a function to compute the envelope from the signal being enveloped, and then apply it with `Env⊸×`. Since the [hook](https://mlochbaum.github.io/BQN/doc/hook.html) `Env⊸× s` means `(Env s) × s`, this multiplies the signal by its envelope.

        ⋆⁼ 0.99994
        ⟨0.99994⋆0.4, ⋆(⋆⁼0.99994)×0.4⟩  # Same thing!

        #    (⋆ ¯6e¯5 ×↕4×s) × (4×s) ⥊ tone
        Play {⋆ ¯6e¯5 × ↕≠𝕩}⊸× (4×s) ⥊ tone

Exponential decay gives a very clean, polite sound. If I'm trying to put more emphasis on a sound I go for something that lingers longer. One way is actually a sum of two or more exponentials with different bases, because the shorter one gives an initial impact and then the longer one keeps going. More aggressive is to take a function that falls off with `÷i` (or `i⋆¯1`) instead of `⋆-i`. Hear how it starts with less power but just keeps going.

<!--GEN
"1/t decay" Plot (⊢ ≍ ·÷1+6×⊢) ↕⊸∾⊸÷40
-->

        Play {÷1+1e¯3×↕≠𝕩}⊸× (4×s) ⥊ tone
