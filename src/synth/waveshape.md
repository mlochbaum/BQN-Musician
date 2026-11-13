# Wave shaping

Not everyone uses "wave shaping" to mean the same thing, so I'll lay out a definition here: it's a synthesis technique that works by applying the same function to each individual audio sample representing a sound. It is perhaps not surprising that I'd define it this way, because that's exactly how arithmetic primitives work in BQN. Wave-shaping is the best possible fit for array programming!

On this page I'll stick to continuous functions, although a function with a big jump or two might be good for a grainy digital distortion effect and I sometimes use very discontinuous ones to add noise in a way that responds to the input. Perhaps I should also point out that simply multiplying by a constant for a volume change *is* arithmetic; it's not interesting as a form of wave-shaping on its own, but it's common to adjust volume before or after real wave-shaping, and it could be helpful to view these together as one function.

Wave-shaping is generally thought of as a technique for distortion, so I'd like to begin by showing that this is not necessarily the case. Sure, if you take a sine wave as your starting point that's the only way to go, but the least distorted tone possible is a bit of an edge case. When the initial sound is harsh at the edges, a curvy function that blends them into the rest of the waveform can smooth it out.

In fact, every one of our [oscillators](oscillators.md) can be framed as wave-shaping applied to a sawtooth wave! A sawtooth's value at a given (modular) phase is that phase, times a constant. So a purely periodic signal, which is to say a function of the phase, is a function of the sawtooth as well.

        rate ← 44100
        phase ← 1 | 277 × ↕⊸÷ rate
        saw ← ¯1 + 2 × phase
        Play saw  # yikes
        Play •math.Sin π×saw  # yawn

A variant on the sine that I like is to replace it with a cubic polynomial with zeroes in the same places (within the domain). `saw-saw⋆3` is zero where `saw` is equal to its cube, that is, at -1, 0, and 1. In order to write it in sequence with other processing I use `-⟜(⋆⟜3) saw` with [Before](https://mlochbaum.github.io/BQN/doc/hook.html), which expands to `saw-(⋆⟜3)saw`. This function's shape is a lot like the sine, but it brings in some slight harmonics where the sine has none. The "quick and dirty synthesis" [over here](../theory/outerscriabin.md) pushes the exponent up from 3 to 7. This is more like the original sawtooth but still smooths out the harshness.

        Play 2 × -⟜(⋆⟜3) saw
        Play     -⟜(⋆⟜7) saw

<!--GEN
dim ← 20+128‿32
gr ← "text-anchor=middle|fill=none|font-family=BQN,monospace|font-size=10"
Pw ← "path" Attr "stroke-width"⋈FmtNum
Pd ← {"d"⋈'M'⌾⊑∾⥊ ⍉"L "∾¨FmtNum𝕩}
clcur ← {
  gr⇐"stroke=currentColor"
  t⇐"fill=currentColor|stroke=none"
}
clgry ← {gr‿t⇐𝕩⋄gr∾˜↩"opacity=0.5|"} clcur
ClassStyle ← {gr⇐∾"class="‿𝕩‿"|style=fill:none"⋄t⇐""}
clred‿clpur‿clblu ← ClassStyle¨ "red"‿"purple"‿"bluegreen"
LabLine ← { xv‿m‿tp‿t‿sty‿x:
  XY ← m × ⊢ ≍ -∘(•BQN t) ⋄ l ← XY x
  sty.gr Ge ⟨
    (Pw 0.5) Elt Pd l≍˘ tp- ÷⟜(÷⟜(5+÷⟜6)⊢´)tp-l
    (Pw {⟨sw⟩:sw;1.5}sty) Elt Pd XY xv
    (("text" At sty.t) Attr Pos tp) Enc t
  ⟩
}
WS0 ← LabLine ⟨-⟜¬↕⊸∾⊸÷100, 64⟩∾{⟨30⋈54-20×𝕨⟩∾𝕩}
(⥊¯1‿2×⌜dim+0‿20) SVG gr Ge (↕≠)⊸(WS0¨) ⟨
  "•math.Sin π⊸×"‿clgry‿¯0.2
  "2×-⟜(⋆⟜3)"    ‿clblu‿¯0.12
  "-⟜(⋆⟜7)"      ‿clpur‿ 0.2
⟩
-->

One reason wave-shaping isn't often used this way is that it interacts strangely with the signal's volume. With our saw perfectly tuned so the extremes are sent to zero, it erases the sawtooth jump. It won't do the same at higher *or* lower volumes, which is unusual—normally only louder sounds become harsh.

        Play -⟜(⋆⟜3) saw × 2 × ⋆¯6e¯5×↕≠saw  # exponential envelope

## Clipping

The clipping that happens when you play a sound too loud in most programs is also a kind of wave shaping. There's always a maximum range for your signal, and when a volume setting would put it outside of that range, the closest you can get is one of the boundaries. In BQN I use a range from -1 to 1, so clipping a signal `𝕩` would be `¯1⌈1⌊𝕩`. Because of the sharp boundary between not-clipped and clipped, this "hard clipping" makes a distinct popping or crackling sound when active.

Hard clipping is the best you can do if you only change samples from `𝕩` that are out of range, which for most user audio is reasonable—you wouldn't want to mess with the normal case where nothing is loud enough to clip. When mixing you'll often have the loud parts of a few sounds overlap, so large values appear but only very rarely. A "soft clipping" function can clamp these down more subtly, by applying only slight distortion to smaller values. We can derive one like this: rewrite `¯1⌈1⌊𝕩` as `𝕩÷1⌈|𝕩`, that is, if `1≥|𝕩` it's `𝕩÷1` or `𝕩`, but otherwise, we get `𝕩÷|𝕩` or `×𝕩`, which is `¯1` or `1` as appropriate. Now let's replace `1⌈|𝕩` with a smoother function, `√1+𝕩⋆2`. When `𝕩=0` it's 1, and as we get further from 0 it tends towards `|𝕩`: dividing by `|𝕩`, we get the ratio `√1+÷𝕩⋆2` which heads to 1. So the function `{𝕩÷√1+𝕩⋆2}` is one way to soft clip.

        v ← ⟨¯5,¯2,¯0.5,0,0.5,2,5⟩

        [v, 1⌈|v, v÷1⌈|v]  # Hard clip
        {⌊0.5+𝕩}⌾(100⊸×) [v, √1+v⋆2, v÷√1+v⋆2]  # Soft clip

The first one was too hard, and what if that one's too soft? There's not just one baby bear's bed in between but a whole continuum, by varying the exponent. Take `{𝕩÷4√1+𝕩⋆4}`: it blends between 1 and `|𝕩` as before but the denominator at `𝕩=1` is `4√2` instead of `√2`, which is much closer to `1⌈|𝕩`'s value of 1.

        {⌊0.5+𝕩}⌾(100⊸×) [v, 4√1+v⋆4, v÷4√1+v⋆4]

As a general form we have `{𝕩÷𝕗√1+(|𝕩)⋆𝕗}` with exponent `𝕗`, where the `|` is needed when `𝕗` isn't an even integer (fans of [Under](https://mlochbaum.github.io/BQN/doc/under.html) will note that `{𝕩÷1⊸+⌾(⋆⟜𝕗)|𝕩}` is another spelling). I find that an integer exponent is actually too much granularity and make the exponent `2⋆k` instead, where I use integer `k` values mostly from 1 to 4.

<!--GEN
x99 ← 3×-⟜¬↕⊸∾⊸÷99
WS1 ← LabLine {⟨⊑𝕩,32,⟨38-14×0=𝕨,42-18×𝕨⟩⟩∾1↓𝕩}
(⥊(0≍˘⋈⟜-12)+¯1‿2×⌜dim) SVG gr Ge (↕≠)⊸(WS1¨) ⟨
  (⌽∘-⊸∾1‿3)‿"¯1⌈1⌊⊢"     ‿clred‿¯0.8
  x99       ‿"{𝕩÷4√1+𝕩⋆4}"‿clpur‿¯0.51
  x99       ‿"{𝕩÷2√1+𝕩⋆2}"‿clblu‿ 0.6
⟩
-->

Clipping does very different things depending on what you apply it to, and it's hard to show the effects with a simple synthesis. [Scanned synthesis](granular.md#scanned-synthesis) makes a complex sound that at least has some reaction, though it's not nearly as clear as recorded voice or instruments would be.

        ScanSynth ← { len 𝕊 init:
          n ← ⌈ len ÷ ≠init
          Force ← {(¯1⌽𝕩)+(1⌽𝕩) - 2.1×𝕩}
          Update ← {𝕩 + 3e¯2 × ⌽ Force⌾⊏ 𝕩}
          len ↑ ∾ ⊏¨ Update⍟(↕n) init≍0¨init
        }
        sound ← (2×rate) ScanSynth 4 × ¬⊸× 1|3.2×↕⊸÷300

        (⌊´⋈⌈´) sound  # barely in range

        Play sound

By design the original signal doesn't clip, so we multiply by two before applying a clipping function, and divide by two to preserve the original volume, minus what clipping takes away. A hard clip has a harsh buzziness here that soft clipping avoids.

        Play 2÷˜ ¯1⌈1⌊ 2×sound
        Play 2÷˜ {𝕩÷√1+𝕩⋆2} 2×sound

### Sigmoid distortion

Discreetly trimming loud parts of a generally quiet track isn't the only use for soft clipping: it can also be pushed with a loud input to create a distortion effect. If this is what I'm after, I'm more likely to reach for something slightly different, the hyperbolic tangent `•math.Tanh`. I call it the *sigmoid* function which I believe is the typical name in audio; elsewhere "[logistic function](https://en.wikipedia.org/wiki/Logistic_function)" may be more common, and "sigmoid" may be used for other curves. The sigmoid follows the soft clipping template in that for small arguments it approximates `𝕩` and for large ones it approaches asymptotes of `¯1` and `1`.

<!--GEN
(⥊(0≍˘⋈⟜-12)+¯1‿2×⌜dim) SVG gr Ge (LabLine ⟨x99,32⟩⊸∾)¨ ⟨
  ⟨12,40⟩‿"{𝕩÷3√1+(|𝕩)⋆3}"‿{gr‿t⇐clpur ⋄ sw⇐2.5}‿¯0.6
  ⟨46, 4⟩‿"•math.Tanh"    ‿clcur                ‿ 0.82
⟩
-->

The hyperbolic tangent doesn't have crazy periodic asymptotes like the ordinary tangent function, in fact it's shaped more like the inverse tangent (which if you'll pardon the *tangent* makes a very soft clip if scaled like `•math.Tan⁼⌾(×⟜(π÷2))`). Its shape is closest to an exponent of about 3 in last section's variable soft clipping function, but it starts distorting a little earlier while still running harder against `¯1` and `1` as the input gets louder. It's not exactly easy to hear but doesn't it sound more present in the following test? I also found it thumpier than soft clipping in my [kick drum](drumtips.md#kick-drum) example.

        Play 2÷˜ 3{𝕩÷𝕗√1+(|𝕩)⋆𝕗} 12×sound  # Soft clip
        Play 2÷˜ •math.Tanh 12×sound

I'm in the habit of writing `1(-÷+)⋆¯2×𝕩` for this function, except that instead of the `¯2×` I adjust whatever volume I was applying to `𝕩` anyway, often dropping the `¯` because I don't normally care if my signal gets flipped. It looks cool but it's got various minor issues like returning NaN if `𝕩≤¯400` or so and not being invertible, and having the sign wrong *does* matter if you want to mix it with the original signal or a different effect. However, understanding why this computes the hyperbolic tangent is a good way to get some insight into the function.

Here's how the math works out (presumably if you wish to avoid such things you've learned to regard the following highlight spatter as warning coloration). Starting with the common definitions of `•math.Sinh 𝕩` as `2÷˜(⋆𝕩)-(⋆-𝕩)` and `•math.Cosh 𝕩` as `2÷˜(⋆𝕩)+(⋆-𝕩)`, we see that the factor of 2 cancels when we divide to give `(⋆𝕩)(-÷+)⋆-𝕩`. Relatedly, suppose I multiply both exponentials by `k`, that is `(⋆𝕩)(-÷+)○(k⊸×)⋆-𝕩`. This multiplies the result of the addition by `k`, because the distributive property says `+○(k⊸×)` is `k×+`, and same goes for the subtraction. `k×` cancels just like `2÷˜` did. It's somewhat more convenient here to add to the exponent than multiply the exponential, so let `k` be `⋆a`. Then `k×⋆𝕩` is `(⋆a)×⋆𝕩` or `⋆a+𝕩`, which transforms `𝕩(-÷+)○(k×⋆)-𝕩` into `(a+𝕩)(-÷+)○⋆a-𝕩`. Setting `a←𝕩`, we have `(𝕩+𝕩)(-÷+)○⋆0` or `(⋆2×𝕩)(-÷+)1`, while `a←-𝕩` gives `1(-÷+)⋆-2×𝕩` (applying `-` to the argument of either one and the other's result nicely shows `-Tanh` is `Tanh-`). To find the behavior at large `𝕩`, we note that `-÷+` is `(+-2×⊢)÷+` or `1-2×⊢÷+`; plugging into `(⋆2×𝕩)(-÷+)1` gives `1-2×1÷1+⋆2×𝕩`. As `𝕩` increases the rightmost `1+` quickly becomes irrelevant approximating an exponential falloff `1-2÷⋆2×𝕩` towards 1. From symmetry we know the other side approaches -1 in the same way.

## Symmetric shaping

The examples so far have been naturally *symmetric*, that is, they shape the positive and negative parts of a wave in the same way. Or maybe we'd say that negating the argument to a function like this has the effect of negating its result: `Shape - 𝕩` is `- Shape 𝕩` (an "odd" function, to mathematicians). I usually work with symmetric functions because I find them easier to understand. The level `|𝕩` of the input controls the level of the result `| Shape 𝕩`. With asymmetric effects the sign matters too, but unlike the magnitude it's something with hardly any audible effect. So without symmetry, the tiny input change of `𝕩` to `-𝕩` might give very different results `Shape 𝕩` and `Shape -𝕩`.

What do you do if you have a function where one side is good, but the other isn't symmetric to it? It's easy enough make a symmetric function by reflecting the positive side. Given `F`, we want `{(×𝕩)×F|𝕩}`, that is, apply `F` to the non-negative `|𝕩`, then restore the sign `×` after. dzaima/BQN actually lets you write this as `F⌾|`, as an analogy to structural Under (though negative results from `F` wouldn't be allowed if it was a strict analogy). But it's also a good use case for a train `(××F∘|)`, which expands to `(×𝕩)×(F∘|𝕩)` when applied to `𝕩`.

Maybe you tried changing the exponent in the opening `-⟜(⋆⟜3) saw` example and found that `-⟜(⋆⟜4) saw` doesn't remove the buzz any more. This is because `(-𝕩)⋆4` is `(¯1⋆4)×𝕩⋆4`, or `𝕩⋆4`, not `-𝕩⋆4`. That means `(⊢-⋆⟜4) saw` subtracts a symmetric part `⊢` and an asymmetric part `⋆⟜4`, so to regain symmetry overall we can either use the `(××F∘|)` pattern on the whole thing, or just fix `⋆⟜4` so we're subtracting two symmetric parts.

        Play -⟜(⋆⟜4) saw  # ouch
        Play (-⟜(⋆⟜4)∘|××) saw  # fixed
        Play -⟜(××|⋆4˙) saw  # also fixed

<!--GEN
Path ← ((Pw 1.5) At "stroke=currentColor"){(𝕨⊢⊘(At˜)𝕗) Elt Pd 𝕩}
Texc ← ("text" Attr "fill"‿"currentColor"∾Pos)⊸Enc
(⥊(0≍˘12‿4)+¯1‿2×⌜dim) SVG gr Ge ⟨
  "opacity=0.5" Ge ⟨
    "stroke-dasharray=6 4" Path 64×≍⟜-⟜(-⟜(⋆⟜4)) (-⌽↕15)÷20
    ¯14‿56 Texc "-⟜(⋆⟜4)"
  ⟩
  Path 64×≍⟜-⟜(-⟜(××|⋆4˙)) -⟜¬↕⊸∾⊸÷80
  ¯32‿¯14 Texc "-⟜(××|⋆4˙)"
⟩
-->

The hard clipping function `¯1⌈1⌊𝕩` also breaks down as the symmetric form of `1⌊𝕩`. Instead of including `¯1` explicitly, `(××1⌊|)𝕩` flips negative values before and after clamping. It's more complex, but easier to fiddle with. One variation is a trick I use if I *want* to reduce a signal to crackling and popping, such as for a handclap effect. I'll subtract the clipped signal from the original, so on the posive side that's `𝕩-1⌊𝕩` which is `(𝕩-1)⌈𝕩-𝕩` or `0⌈𝕩-1`. That gives `(××0⌈1-˜|)` when I make it symmetric again, and allows me to reduce the `1` to a small constant around `0.1` so it can take a smaller input without zeroing it all out.

<!--GEN
(⥊(0≍˘14‿¯18)+¯1‿2×⌜dim) SVG gr Ge ⟨
  Path 32 × ≍⟜-⟜(××0⌈1-˜|) ⌽∘-⊸∾1‿2
  (0‿1×dim-9) Texc "(××0⌈1-˜|)"
⟩
-->

## Example: Fender-Rhodes

In BQN Musician's theory section, [this page](../theory/tertian.md) uses an unassuming synthesized keyboard sound to illustrate scales. The way this came about is that I searched how I might imitate a [Fender Rhodes](https://en.wikipedia.org/wiki/Rhodes_piano) and eventually found a video of someone applying wave shaping in a modular synthesizer; I borrowed the arithmetic with only small tweaks. Here's the function for a single note that you'll find in the [source file](../src/theory/keys.bqn):

    Key ← {
      d ← ¯2e¯4×1-4÷√𝕩
      k ← ÷ 10 × 0.2 + ×˜ 0.17 + (2⋆d×↕𝕨) × 0.25 o.Sine 𝕩×1+÷4+8÷˜↕𝕨
      (⌽↕⊸÷300) m.Fadeback 10 f.Hp2 8‿4000 f.Hshelf (↕⊸÷10) m.Fadefront k
    }

The arguments are length `𝕨` and frequency `𝕩`. There *is* a lot of junk I added like a decay `d` that shortens as `𝕩` rises, and an adjustment `1+÷4+8÷˜↕𝕨` to make the actual pitch start high and quickly fall into place. But the core is the wave shaping in `k`, computing `÷ 10 × 0.2 + ×˜ 0.17 + wave`. This is far removed from the symmetric functions we've been considering!

<!--GEN
(⥊(0≍˘0‿¯30)+¯1‿2×⌜dim) SVG (gr∾"|stroke=currentColor") Ge ⟨
  (Pw 0.25) Elt "d"⋈ ∾⥊ ("M "⊸∾˘"HVVV")∾¨FmtNum 64 × ∾⟨
    ¯1‿0‿1×1.5, 0∾¯1‿0+÷4, ∾⟜⟨0,÷¯32⟩˘¯1‿1
  ⟩
  (Pw 1.5) Elt Pd 64 × ≍⟜-⟜{÷ 2 + 10 × ×˜ 0.17 + 𝕩} x99÷2
⟩
-->

This function is a transformation of the base shape `÷ 0.2 + ×˜ 𝕩`, with `0.17 +` shifting it slightly to the left and `10 ×` acting as a constant multiple. How does the base shape work? When `𝕩=0`, we get `÷ 0.2` or `5`, but as `𝕩` moves away from the center in either direction, `×˜ 𝕩` increases and the function falls off like `÷ ×˜ 𝕩`. The range of 0 to 5 is far too large, which is why we have the factor of 10 to reduce the top to 0.5. But it's still a weird transformation: high in the middle, and low to both sides? Applying that to an oscillator causes it to reach those low values twice per cycle, effectively doubling the frequency.

This is where the offset of `0.17`, which prevents the peak from being exactly centered, comes in. Larger oscillations still pass the peak and fold over to get this frequency-doubling effect—a second harmonic. But smaller ones won't get that far and will primarily see the gentle negative slope around the origin, more like a sign flip and light distortion. The same imbalance works at larger amplitudes to keep the fundamental frequency around, even if it's relatively less powerful. Since the input is a [decaying](envelope.md) sine wave, what we get is an added second harmonic that's strong at the start but fades out more quickly than the fundamental (along with, of course, the typical harmonic distortion any significant wave-shaping will produce). Here's some simplified code:

        Key ← {
          c ← •math.Cos (𝕩 × 2×π÷rate) × ↕𝕨
          k ← c × 2 ⋆ ¯2e¯4 × ↕𝕨
          ÷ 10 × 0.2 + ×˜ 0.17 + k
        }
        Play 3e4 Key 277

Most likely you hear a click at the end of that one. Our wave-shaping function applied to 0 doesn't give 0, so we end on a constant offset! My full synthesis had a high-pass filter `f.Hp2`, which reduces low-frequency sound, eliminating the offset as it's the lowest possible frequency (and *then* there's a short fadeout with `m.Fadeback` to avoid clicking for shorter notes that haven't died out yet). But in place of this we can compute the required offset directly. We need to subtract the value of our wave-shaping function at 0, a task which [Over](https://mlochbaum.github.io/BQN/doc/compose.html#over) (`○`) handles perfectly. With this done, we're also better off with a sine to start at 0, rather than our cosine that started at one extreme before.

        KeyClean ← {
          c ← •math.Sin (𝕩 × 2×π÷rate) × ↕𝕨
          k ← c × 2 ⋆ ¯2e¯4 × ↕𝕨
          k -○{÷ 10 × 0.2 + ×˜ 0.17 + 𝕩} 0
        }
        Play 3e4 KeyClean 277
