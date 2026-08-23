# Drum tips

Synthesizing melodic instruments is fairly intuitive. Sure, you might not like your timbre but the important thing is that it plays the right note. Percussion is different, and you can get into the weeds very quickly trying to make something that resembles a drum at all. This page collects a few tricks that I've found myself repeating because they're easy to use and make decent drum sounds. I'm showing simple versions for illustration, but they can usually be improved with more tweaking! Also note that you can click to run these in BQN's web REPL, where you can `•Plot` as well as `•Play` the various parts.

Despite the special tricks, most of the code is taken up by standard synth techniques. The flow is always some variation of the following steps:

- Generate some sort of tone, often using [oscillators](oscillator.md)
- Apply an exponential [envelope](envelope.md) so it fades naturally
- Use a pointwise wave-shaping function to give it more complexity and sustain
- And apply an EQ filter to emphasize the right frequencies.

On that note, we'll use several different kinds of filter and I'm not going to explain how the math for those works here (as if I even remember it). I'm going to collapse them out of sight instead.

<details><summary>Filter implementation</summary>

        Filter ← {
          a‿b ← 0×𝕨 ⋄ c ← ∾𝕨
          {a«˜↩𝕩 ⋄ r←+´c×a∾b ⋄ b«˜↩r ⋄ r}¨ 𝕩
        }
        Ph ← (2×π÷44100)⊸×  # frequency to phase

        Hp1 ← ((-⊸⋈ ⋈ ⋈) 1÷∘+Ph)⊸Filter

        Hp2q ← { 𝕊 f‿q:  # frequency and Q factor
          c‿s ← (•math.Cos ⋈ (2×q)÷˜•math.Sin) Ph f
          ⟨2‿¯1‿2÷˜1+c, [s-1,2×c]⟩ ÷ 1+s
        }⊸Filter

        Peak ← { 𝕊 g‿f‿q:  # gain, frequency, Q factor
          k ← •math.Tan 2÷˜Ph f
          ab ← (¯2×¬×˜k) ∾ (1+×˜k) + ∾⟜- k × (10⋆0⌈-⊸≍g÷20) ÷ q
          3 (↑ ⋈ -∘↓) (4‿0‿2‿3‿0⊸⊏ ÷ 1⊸⊑) ab
        }⊸Filter

</details>

## Kick drum

I'll start off with the kick drum and the observation that you can and should try making your own kicks in whatever way occurs to you. What makes a kick sound is a bit of noisy click as the beater hits the drum head, a low-frequency fundamental, and some boominess at slightly higher frequencies that fades out more quickly. Because the noise is fast and the rest is deep, we don't hear a lot of detail from either. Anything that gets in the right neighborhood will be a serviceable kick.

But the method I want to show off does all three simultaneously, and makes a hard-hitting techno sound. The core idea is to apply a high-pass filter *with resonance* many times to an initial impulse. The initial sound isn't hugely important, but triangle waves are a good fit for kick drums, and we'll pair a 36Hz one with a quick decay. This is a super quiet sound, before we run a bunch of filters over it (the name is `Hp2q`: high-pass, 2-pole, with an additional Q parameter controlling the resonant peak sharpness). These have two effects: the first is straightforward, increasing the resonant frequency of 23Hz which is deep into the sub-bass. The second is, nominally, to reduce frequencies below this. We don't care about them as they hardly even touch the audible range, but the filter produces quite a bit of higher-frequency ringing in its efforts to cancel them out. Which as it turns out sounds pretty drum-like.

        kick ← {
          i ← ↕1e4
          s ← -⟜¬|-⟜¬ (÷4) + i×36÷44100  # triangle wave
          e ← ⋆ ¯14e¯3 × i               # exponential decay
          k ← 23‿0.81 Hp2q⍟16 e×s        # filter (kind of slow)
          0.4 × 1(-÷+)⋆ 500×k            # sigmoid distortion
        }
        Play kick

Even after, we need `40×` amplification or so to get to a reasonable level, and to give it more of a punch (but reduce the realism) I pass it through a sigmoid function, which has exponential-shaped asymptotes on both sides. You can slap a huge multiplier in front of a sigmoid and it always ends up between `¯1` and `1`. This function is just great for giving more presence to bass sounds without harshness—try it on your bass guitars too. One thing to watch out for is that the short version is actually a *negative* sigmoid. If staying in phase matters, use `(-˜÷+)` or stick a `-` before or after applying it.

<!--GEN
Path ← ("path"At"stroke-width=2|stroke=currentColor") Elt "d"⊸⋈
dim ← 128‿32
gr ← "text-anchor=middle|fill=none|font-family=BQN,monospace"
Plot ← {
  (⥊(-˜`¯30‿0≍30‿15)+¯1‿2×⌜dim+20) SVG gr Ge ⟨
    Path 'M'⌾⊑∾⥊ ⍉"L "∾¨ FmtNum 64×1‿¯1×𝕩
    ("text" Attr "fill"‿"currentColor"∾Pos 0‿1×20+dim) Enc 𝕨
  ⟩
}
"1(-÷+)⋆𝕩" Plot 2÷˜ ≍⟜(1(-÷+)⋆) 4× -⟜¬↕⊸∾⊸÷100
-->

## High hat (attempted)

On to the high hat, a classic trick for making these is to filter some white noise. In theory, `•rand` is the perfect white noise generator. But short bursts of random numbers are unreliable: the envelope usually makes the first few samples a lot louder than the rest, and if they happen to not have enough variation, you end up with a weak drum hit. Deterministic arithmetic avoids this, and it also gives you the ability to make not-quite-white noise with an audible "flavor" to it. See the snare section for that. But if a white noise sound is what you want, I've found that an exponent of `π` makes a surprisingly nice one.

        Play 1-2|π⋆˜↕2e4

That's it, integers to the `π`th power, taken modulo 2 and centered. I think it's just a coincidence, but `π` worked better than many other exponents I tried, and it's quick to type. Note that 2e4 is about as far as it goes: by `4e4⋆π` there's a significant loss of precision and a little after `1e5⋆π` it collapses to one value so the "noise" is just a stream of 1s. We can multiply it by another exponential envelope and send it through a high-pass filter with the knee way up at 12kHz. Hardly any frequencies are high enough to pass through such a thing, but lower ones get cut more the further they are from 12kHz, so we get a strong tilt towards brighter hissing sounds. `Hp1` is a 1-pole filter which is the least steep drop we can do; `Hp2q` before needed 2 poles because 1-pole filters are very limited in shape and can't make a resonant peak.

        Play {(⋆¯1e¯3×𝕩) × 1-2|π⋆˜𝕩} ↕5e3

        Play 12e3 Hp1 {(⋆¯1e¯3×𝕩) × 1-2|π⋆˜𝕩} ↕5e3

This sort of thing can be nice as a component of cymbals and snares, but it's not doing so well on its own. Next section's trick makes a metallic sound that's good for cymbals specifically, and by shortening it we can get a better high-hat synthesis.

## Cymbal

Remember the basic idea of a sawtooth wave? Take `k × ↕len`, modulo some number, and center it. By extending this to a multiplication table `ks ×⌜ ↕len` we can make many sawtooth waves at once, one per row.

        ⌊⌾(1000⊸×) 3√25+×˜↕10  # some coefficients

        ⌊⌾(100⊸×) (3√25+×˜↕4) ×⌜ ↕10  # first four, expanded to sequences

        # Lots of arithmetic; will take several seconds in the web REPL
        Play (+˝÷√∘≠) ¬ 2| (3√25+×˜↕50) ×⌜ ↕4e4

In the last line we've done a sort of average: the numerator is `+˝` to sum everything, but the denominator is `√∘≠` instead of `≠`. This is because the waves all have different frequencies and cancel to some degree, so the average volume ends up growing with the square root of the count (much like a random walk).

<!--GEN
"3√25+×˜↕50" Plot [-⟜¬49÷˜↕50, 0.5-˜÷⟜(⌈´)-⟜(⌊´)3√25+×˜↕50]
-->

We get some sort of harsh circular saw thing, which is sort of like a motorized cymbal, right? Just putting a decay on it will give us a passable cymbal, but we can do better by giving each wave its own decay factor, using the same multiplication table. This also gives a purpose to the somewhat weird set of coefficients used: with the sawtooth's `2|`, 2.924 may as well be 0.924, but the envelope doesn't take any modulus. The result is that most waves die off quickly but a few linger a while, so the sound cleans up as time goes on. It's a subtle increase in realism; you can check what it sounds like without that by replacing `t` with ``⊣`t`` or maybe ``⊣`10⌽t`` below.

        ride ← 0.4 × 7500 Hp1 {
          t ← (3√25+×˜↕30) ×⌜ ↕3e4
          s ← ¬ 2|t        # sawtooth
          e ← ⋆ ¯2e¯5 × t  # envelope
          (+˝÷√∘≠) e×s     # average
        }
        Play ride

But I've already hinted that I just wanted a better high hat sound. Fortunately all I really have to do is to shorten the envelopes, but I'm going to go a tiny bit further and add an [onset](envelope.md#onset) to each one as well. I change `⋆` to `(⋆⌊¯2⊸×)` to put a rise before each exponential's fall-off. Both parts depend on that particular wave's coefficient, so some waves rise and fall quickly and the ones that linger a while also rise slower.

        hihat ← 0.4 × 7500 Hp1 {
          t ← (3√25+×˜↕80) ×⌜ ↕1e4
          s ← ¬ 2|t               # sawtooth
          e ← (⋆⌊¯2⊸×) ¯8e¯5 × t  # envelope
          (+˝÷√∘≠) e×s            # average
        }
        Play hihat

## Snare

I'll admit that I don't have any _good_ snare tricks, but we need one. A snare is more or less a tom that's got these wires underneath to make it noisier, and it's super hard to imitate because there are so many interacting parts. We can get some of this not-really-noise complexity with a not-really-random arithmetic generator. This one is sort of a sine wave with rapidly changing frequency. If you play with the `7.05` parameter a bit you'll find that it's balanced between a few weird wobbling sounds.

        Play •math.Sin +`(2×π)|(↕2e4)÷7.05

We'll apply the usual exponential envelope, followed by `(××0.4⌊3√×˜)` for wave-shaping compression. This train follows the pattern `××Fn∘|`, which expands to `{(×𝕩)×Fn|𝕩}`: we apply some function `Fn` to the absolute value of `𝕩` to get a positive result, then multiply by the sign of `𝕩` to restore the sign it had originally. The function `3√×˜` could also be written `⋆⟜(2÷3)` except that by squaring first the absolute value is built in. This amplifies smaller values, while `0.4⌊` clamps down the bigger ones. The rough and twisty shape adds a little more complexity than a smoother one would.

<!--GEN
"(××0.4⌊3√×˜)" Plot ≍⟜(××0.4⌊3√×˜) -⟜¬↕⊸∾⊸÷100
-->

Finally we apply a peaking filter for a big boost at an energetic 350Hz. Depending on the kind of snare tone you're after, a frequency in the 250Hz to 400Hz range is useful to bring out that snare impact.

        snare ← 0.5 × 8‿350‿1.1 Peak {
          i ← ↕2e4
          s ← •math.Sin +`(2×π)|i÷7.05
          e ← ⋆ ¯1e¯3×i
          (××0.4⌊3√×˜) e×s
        }
        Play snare

Listening more isn't going to fix it, it'll just keep sounding more papery and fake.

## Sequencing

A good beat with the right swing and variations in volume can make an engaging groove even if the samples are atrocious. This is not the page where that happens. But a *passable* up-tempo beat… well, it's grating but you'll have to admit it has some party in it. First we'll define the length of a sixteenth note and a quarter note, at a lively 138 beats per minute. With Reshape (`⥊`) we can loop an eighth-note high hat for one measure.

        s ← ⌊44100×60÷4×138  # sixteenth note
        q ← 4 × s            # quarter note

        hh ← (4×q) ⥊ (q÷2) ↑ hihat
        Play hh

The snare is traditionally played every other quarter note, that is, there's a quarter note of silence followed by a quarter-note snare `q ↑ snare`. There's a quick way to write this: the function `0¨` applied to the snare changes every value to `0` giving silence, so that `0¨⊸∾` joins silence in front of the original value. Then reshaping brings us to the full length again.

        Play hh + (4×q) ⥊ 0¨⊸∾ q ↑ snare

There's not a lot happening with one instrument to go, so it's time for a real busy kick line. Since a kick fits well enough in a sixteenth note (at least, cutting this one off there isn't very audible), we'll use a simple method where each sixteenth note either has one or is silent. To do this, we make a boolean list that's 1 where the kick should play, and multiply it by the kick with Table (`⌜`), so that each boolean is multiplied by the entire kick. Deshape (`⥊`) flattens that into a sequence.

        ('.'=".. .") ×⌜ 1‿2‿3

        Play ⥊ ('.'=".   .  ..   . . ") ×⌜ s ↑ kick

Actually I want a slight variation in the second measure: I can get it with another symbol, then a scan so the second row has a `1` where either `'.'` or `'?'` appeared. This gives a new, longer boolean sequence.

        ".?" =⌜ ".?  .  ..   . . "

        ∨` ".?" =⌜ ".?  .  ..   . . "

Here's `16×q` or four measures with it all together, extend that for as long as you like!

        Play +´ (16×q)⊸⥊¨ ⟨
          (q÷2) ↑ hihat
          0¨⊸∾ q ↑ snare
          ⥊ (∨`".?"=⌜".?  .  ..   . . ") ×⌜ s ↑ kick
        ⟩
