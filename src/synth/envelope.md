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
"Exponential decay" Plot (⊢ ≍ ·⋆¯3×⊢) ↕⊸∾⊸÷40
-->

        Play (0.99994 ⋆ ↕4×s) × (4×s) ⥊ tone

The start is too sharp to match anything real (we'll get to that), but eventually it starts to sound like a tuning fork, or maybe some sort of chime. These are very nearly perfect oscillators with friction!

The envelope `0.99994 ⋆ ↕4×s` simply starts at one and decreases by a factor of `0.99994` each time. But that constant isn't very nice to work with, because counting nines is no fun. What I do instead of changing the base of the exponent is to use a fixed base and multiply the exponential part. This is equivalent to changing the base because `b⋆c×i` is `(b⋆c)⋆i`. Another thing I'll do while I'm tidying up the code is avoid repeating the length. I'll make a function to compute the envelope from the signal being enveloped, and then apply it with `Env⊸×`. Since the [hook](https://mlochbaum.github.io/BQN/doc/hook.html) `Env⊸× s` means `(Env s) × s`, this multiplies the signal by its envelope.

        ⋆⁼ 0.99994
        ⟨0.99994⋆0.4, ⋆(⋆⁼0.99994)×0.4⟩  # Same thing!

        #    (⋆ ¯6e¯5 ×↕4×s) × (4×s) ⥊ tone
        Play {⋆ ¯6e¯5 × ↕≠𝕩}⊸× (4×s) ⥊ tone

Now I can adjust the constant to control the decay time. For example, one that's five times as big gives a signal five times shorter. You could divide by a constant instead (`¯1.6e4 ÷˜` in place of `¯6e¯5 ×` and `¯3e3 ÷˜` for `¯3e¯4 ×`) to have something that scales as a duration if that's easier.

        Play {⋆ ¯3e¯4 × ↕≠𝕩}⊸× (4×s) ⥊ tone

Exponential decay makes for a very clean, polite approach. To put more emphasis on a sound I often try something that sticks around longer. One simple way is to add a small constant to the exponential. This generalizes to two exponentials with different bases—the lower one gives an initial impact and then the higher one sustains, but not necessarily forever like the constant. Or any number of them, but eventually you're basically taking the [Laplace transform](https://en.wikipedia.org/wiki/Laplace_transform) of some function that's not very much like an exponential, and it's better to just use another function. An aggressive choice is a function that falls off with `÷i` (or `i⋆¯1`) instead of `⋆-i`. Hear how it starts with less power but just keeps going.

<!--GEN
"1/t decay" Plot (⊢ ≍ ·÷1+10×⊢) ↕⊸∾⊸÷40
-->

        Play {÷1+1e¯3×↕≠𝕩}⊸× (4×s) ⥊ tone

The `1+` avoids a division by zero, making the level start at 1. And the constant `1e¯3` controls the speed of decay as before. Another option is to take the inverse square instead of just the inverse, or more generally any power. With an exponential this would be equivalent to changing the decay time because `(⋆t)⋆p` is `⋆p×t`. But here, higher powers smooth things out and lower ones make the curve sharper.

<!--GEN
"1/t² decay" Plot (⊢ ≍ ·÷·×˜1+2×⊢) ↕⊸∾⊸÷40
-->

        Play {÷×˜1+2e¯4×↕≠𝕩}⊸× (4×s) ⥊ tone

You also have to decrease the constant for larger powers to keep the overall sound similar. As the exponent increases, this formula gets closer to an exponential: one definition for `⋆t` is the limit as `p` goes to `∞` of `(1+t÷p)⋆p`, so by inverting and scaling `t` we find that `⋆-k×t` or `÷⋆k×t` is the limit of `÷(1+(k÷p)×t)⋆p`. This also suggests that when multiplying the exponent by a factor `f` the decay constant should be divided by roughly `f`.

## Onset

In the previous section the notes all started instantly, which is generally not too great. With a sine wave, you can sort of get away with it because the wave itself starts at 0, but if the wave isn't perfectly aligned with the envelope you'll often get a click at this sort of abrupt change.

To have a better idea of how these notes sound I'll repeat each one a few times with `⥊3/≍note`. The idea here is that it adds a length-1 axis to the front with `≍`, repeats it three times, then deshapes to combine those repetitions. Here's our square-reciprocal envelope from before.

        Play ⥊3/≍ {÷×˜1+2e¯4×↕≠𝕩}⊸× (s÷2) ↑ tone

What about a softer onset, that won't poke through a mix as much? One way is to take the minimum of one envelope that increases quickly and another that decays. Since the onset is generally very short, its shape isn't all that important; a linear increase works fine.

<!--GEN
"1/t² with linear onset" Plot (⊢ ≍ 10⊸×⌊·÷·×˜1+2×⊢) ↕⊸∾⊸÷40
-->

        Play ⥊3/≍ {i←↕≠𝕩 ⋄ (2e¯3×i) ⌊ ÷×˜1+2e¯4×i}⊸× (s÷2) ↑ tone

        # Very soft attack
        Play ⥊3/≍ {i←↕≠𝕩 ⋄ (2e¯4×i) ⌊ ÷×˜1+2e¯4×i}⊸× (s÷2) ↑ tone

This does make the loudest point ever so slightly less than 1. Another possibility is to [shift](https://mlochbaum.github.io/BQN/doc/shift.html) an onset curve in with `»`, delaying the start of the decay without making the overall envelope any longer.

        Play ⥊3/≍ {(↕⊸÷500) » ÷×˜1+2e¯4×↕≠𝕩}⊸× (s÷2) ↑ tone

In real instruments there can actually be a lot of noise during the onset. Making a realistic onset for a guitar pluck or saxophone—uh, it's pretty much just spitting—is very hard and a lot of digital instruments use samples instead. But here's an example of a sort of clicky sound added to the previous tone. Even this is enough to make it more physical and present.

        plain ← {(↕⊸÷500) » ÷×˜1+2e¯4×↕≠𝕩}⊸× (s÷2) ↑ tone
        Play ⥊3/≍ plain {𝕨+(≠𝕨)↑𝕩} (100⥊0)∾0.4 × -⟜¬ ↕⊸÷10
