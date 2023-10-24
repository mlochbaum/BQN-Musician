# Granular synthesis

The concept of granular synthesis is to compose a sound from very short "grains" that exactly or almost repeat. Generally this is done by cutting out bits of a sample, and while this can lead to very [cool effects](https://www.youtube.com/watch?v=CKxXJAXFnvg), it's more of a sound processing method than synthesis. But it's also possible to use purely synthesized sections—while this doesn't usually go by the name "granular", I'm using it here as an organizing principle.

The methods here will create a sequence of grains each with length `g` and string them together to get a sound with frequency `rate ÷ g`. At a low-to-medium frequency, a grain contains hundreds of samples, so generating each as an array can make this a good fit for array programming. The simplest thing to try is to keep the grain constant. That's just an [oscillator](oscillator.md) with a specified shape, so it's nothing new, but at least we'll see the mechanics of assembling grains. Here's a sawtooth wave, created granular-style.

        rate ← 44100
        Center ← {(2×𝕩)-1}
        GrainSaw ← { len 𝕊 f:
          g ← ⌊0.5 + rate ÷ f    # Length of a grain
          n ← ⌈len ÷ g           # Number of grains
          grain ← Center (↕g)÷g  # One grain
          ∾ n ⥊ < grain          # Repeated as necessary
        }
        Play rate GrainSaw 220   # A3 for 1 second

The arguments to `GrainSaw` are the total length needed, `len`, and the frequency, `f`. The frequency is rounded here to get a whole number for the grain size `g`. For example the requested frequency of 220Hz is rounded to 220.5, a difference too small to hear in most situations. Higher frequencies can round a lot more, but such small grains aren't as interesting to work with anyway, so I'd probably stick with lower frequencies.

        rate ÷ ⌊ 0.5 + rate÷220   # Off by 4 cents

        rate ÷ ⌊ 0.5 + rate÷1800  # A worse case: 35 cents

For another try at a granular method, we might start with a sine wave at a much lower frequency than our eventual grain size, and move along it: each grain starts one sample later in that wave. This is exactly the [Windows](https://mlochbaum.github.io/BQN/doc/windows.html) (`↕`) primitive. Now we do get a changing timbre, if a harsh one!

        Play ⥊ 400 ↕ •math.Sin 14÷˜↕600

The grain size doesn't have to stay constant, although a fixed size may be easier to work with. For example [Prefixes](https://mlochbaum.github.io/BQN/doc/prefixes.html) (`↑`) gives us an increasing size and thus a falling frequency. Here [Join](https://mlochbaum.github.io/BQN/doc/join.html#join) (`∾`) is essential to combine the differently-sized grains.

        Play ∾ ↑ •math.Sin 14÷˜↕500

## Karplus-Strong pluck simulation

The [Karplus-Strong](https://en.wikipedia.org/wiki/Karplus%E2%80%93Strong_string_synthesis) method is usually expressed as continuously updating a cyclic buffer. But it can also be done by replacing the entire buffer at once, at the cost of getting one input too far in the future. This can be fixed but it's a bit ugly; also the future value hardly differs from the current one and I don't think it makes an audible difference.

What we'll do is to start with a random grain—white noise is traditional but I think it sounds pretty bad so I'll drop in a pink noise generator here—and update it to be quieter and gentler on each iteration. This mimics the way that higher harmonics die off faster when a string is plucked. Here we average each sample with one next to it, and multiply by a constant that's a little less than 1 to damp the value a little more. It's not the only iteration that can be done but it's one of the simplest.

        Rand ← •rand.Range
        Pink ← {÷⟜(⌈´|) +` 𝕩 ↑ ⥊∘⍉∘≍´⌽ -⟜«∘Rand⟜0¨ (1⌈↕∘⌈)⌾(2⋆⁼⊢)2⌈𝕩}

        Pluck ← { 𝕊 f‿len‿att: # Frequency, length, attenuation
          g ← ⌊0.5+rate÷f
          n ← ⌈len÷g
          t ← 2 ⋆ -att÷g  # Constant for attenuation
          len ↑ ∾ {t × (𝕩+1⌽𝕩)÷2}⍟(↕n) Pink g
        }
        Play Pluck 147‿rate‿10

The structure is very similar to `GrainSaw` from above. The one major difference is the way we generate `n` grains. Each grain is produced from the one before with `{t × (𝕩+1⌽𝕩)÷2}`, which uses [Rotate](https://mlochbaum.github.io/BQN/doc/reverse.html#rotate) (`⌽`) as shown below. To get them all, we want the initial grain, then one filtered once, twice, three times, and so on. The tool for this is [Repeat](https://mlochbaum.github.io/BQN/doc/repeat.html) (`⍟`) with an array right operand (0, 1, 2, 3…). Repeat saves its intermediate results, so this takes linear time even though doing each number separately would be quadratic.

        ex ← 1‿0‿0‿5‿0
        1 ⌽ ex

        {𝕩+1⌽𝕩} ex

        {(𝕩+1⌽𝕩)÷2} ex  # Smoothed out a little!

## Scanned synthesis

What if we make our grain into an oscillator, in the sense that it obeys force laws? We'll start simple: we can make a sine-ish wave by using a grain of one sample. To do this, we track the position *and velocity* at each step, because our oscillator needs to have some momentum that keeps it going in the same direction. To make a step, we add a multiple of the velocity to the position, and subtract a multiple of the position from the velocity, to represent a force that pushes back towards position 0. Since the scaling of the velocity doesn't matter, I'll use the same multiple for both updates, just with different signs. To get the sound, we update many times, then take only the positions with `⊑¨`.

        ⋈⟜- 0.04  # Coefficients to use

        {𝕩+(⋈⟜-0.04)×⌽𝕩} 1‿5

        Play 0.01 × ⊑¨ {𝕩+(⋈⟜-0.04)×⌽𝕩}⍟(↕rate) 1‿0  # Loud!

This gets out of control very quickly, because the changes are discrete instead of continuous—the position and velocity should trace out a circle, but they turn late, and spiral outwards instead. I've multiplied by `0.01` and it still clips almost immediately. To fix this, I can multiply by a number slightly less than 1 at every step. And by dampling just a little more than I have to, I get a nice exponential [decay](envelope.md#decay) instead.

        Play ⊑¨ {(1-9e¯4)×𝕩+(⋈⟜-0.04)×⌽𝕩}⍟(↕rate) 1‿0

This a rather inefficient way to make a sine wave, but it's a starting point for a neat method called [scanned synthesis](https://csound.com/docs/manual/SiggenScanTop.html). First, if we make `𝕩` a shape `2‿g` array, we get something that sounds more complex. The frequency is determined by the grain size, `200` here, and the volume oscillates because that's what oscillators do.

        Play ∾ ⊏¨ {(1-9e¯4)×𝕩+(⋈⟜-0.04)×⌽𝕩}⍟(↕400) {𝕩≍0¨𝕩} Pink 200

In scanned synthesis the different components should interact with each other instead of oscillating independently. The physical idea here is that there's some sort of slowly wobbling springy sheet, and a scanner that cycles around it measuring. We get the scanner just by joining grains together, and for the interaction we'll include components based on the two samples next to the one we're updating. The function `Force` gets the direction the current sample is being pushed: slightly towards zero, which is `0.1×0-𝕩`, and strongly towards the values on the left `(¯1⌽𝕩)-𝕩` and right `(1⌽𝕩)-𝕩`. Adding these together gives a total force. It's applied to the position with [Under](https://mlochbaum.github.io/BQN/doc/under.html) First Cell, `⌾⊏` before the reverse which causes it to be added to the velocities.

        ScanSynth ← { len 𝕊 f:
          g ← ⌊0.5+rate÷f
          n ← ⌈len÷g
          Force ← {(¯1⌽𝕩)+(1⌽𝕩) - 2.1×𝕩}
          Update ← {𝕩 + 4e¯3 × ⌽ Force⌾⊏ 𝕩}
          len ↑ ∾ ⊏¨ Update⍟(↕n) [Pink g, g⥊0]
        }
        Play 0.3 × (10×rate) ScanSynth 147

Now we get something with a complex changing tone over time! The overall frequency is still determined by the grain size `g`, but as the samples push each other around, the grain shape changes, changing the timbre with it.
