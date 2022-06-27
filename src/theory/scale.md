# Scales

Scales are pretty important in music, and there's a lot of intricate theory describing which scales are useful and how they relate to each other, and to chords. Here we'll just cover the basics: what's a scale and how do you describe it?

Well, music is made of notes, each of which has a particular frequency. I think I'll define a scale as a collection of frequencies and call that enough. 216 Hz, 491 Hz, and 804 Hz? Sure, that's a scale. Every multiple of 111 Hz? Sure. No notes at all? Fine, whatever. Music that's played *in* a scale is music where every note belongs to the scale. That's easy enough to express in BQN using the [Member of](https://mlochbaum.github.io/BQN/doc/search.html#member-of) function, at least for finite scales.

        491‿804‿491‿491 ∊ 216‿491‿804

        ∧´ 491‿804‿491‿491 ∊ 216‿491‿804

Ideally we'd like to find some scales that help us make music, and we're definitely not there yet. Let's carry on.

## Octave scales

The most important harmonic relationship is the *octave*: a factor of two change in frequency (say, 220 to 440 Hz). It's named after the number 8 for very bad reasons; when you read "octave", think "two". It's so important that in a lot of harmonic theory, two frequencies an octave apart are considered to be different versions of the same note, and we'll use this convention in most of our study of scales.

We define an "octave scale" to be one that repeats every octave, or we might say that if it includes a frequency `f`, it also includes `f×2` and `f÷2`. By repeatedly applying the rule we get `f×4` and `f÷4` and so on. The infinite set of all frequencies we get from `f` in this way is an octave scale itself, the smallest one that contains `f`. The proper name for such a set is a "pitch class", but we'll usually just call it a "note" in our scale theory studies.

Taking the base 2 logarithm of a frequency `2⋆⁼f` converts all this multiplying and dividing by 2 to adding or subtracting 1.

        2 ⋆⁼ ⟨3, 3×2, 3÷2⟩

So if we then look at only the fractional part `1|2⋆⁼f`, this is a kind of "signature" that is the same for every note in a pitch class. In theory, applying this before `∊` with [Over](https://mlochbaum.github.io/BQN/doc/compose.html#over), that is, `∊○{1|2⋆⁼𝕩}`, ought to identify membership in an octave scale. Logarithm being computed inexactly means this doesn't quite work, although a variation where we divide by a power of two does.

        491‿804‿201‿200‿432 ∊○{𝕩÷2⋆⌊2⋆⁼𝕩} 216‿491‿804

If we take 2 to the power of our signature, we can see what it's doing a little better: it multiplies or divides by 2 until the frequency falls in the range `1≤f<2`.

        2⋆1|2⋆⁼ 0.4‿3‿5‿7‿8‿9

That specific range is arbitrary (not to mention inaudible), but the important thing is that when the frequency would increase up to `2`, it's reduced to `1` and starts at the bottom again. So our frequencies now form a circle instead of a line. But neither of these are terribly musical shapes (if it were a triangle that would be a different matter). Carry on, once more.

## Twelve-tone

Modern music just about everywhere is now based on dividing the octave into twelve steps. The reason usually given for this is to consider the `3÷2` ratio, the second simplest after the octave, and look at what happens when it's applied repeatedly:

        Round ← (⌊0.5⊸+)⌾(100⊸×)  # Nearest hundredth, for display

        Round 2⋆1|2⋆⁼ (3÷2)⋆↕13

At step 12, we arrive at a frequency that's very nearly in the same pitch class as the starting `1`. This is because that `3÷2` ratio is very close to `2⋆7÷12`. Using that value instead we arrive back at the start exactly.

        Round 2⋆1|2⋆⁼ (2⋆7÷12)⋆↕13

We can stop at 12 notes to get an octave scale; sorting the frequencies reveals that these follow a very regular distribution, as each note is a factor of `2⋆÷12` (or `12√2`) larger than the previous.

        Round ∧ 2⋆1|2⋆⁼ (2⋆7÷12)⋆↕12

        Round           (2⋆ ÷12)⋆↕12

<!--GEN
pa ← "path"At"fill=none|stroke-linejoin=round|stroke=currentColor|stroke-width=2"
pts ← 80×(•math.Sin ≍˘ •math.Cos) (2×π) × 7×↕⊸÷12
(⥊¯1‿2×⌜300‿100) SVG ⟨ pa Elt "d"⋈'z'∾˜'M'⌾⊑ ∾⥊ "L " ∾¨⎉1 FmtNum pts ⟩
-->

This octave scale is called the *chromatic scale*. But it's still not something anyone but Schoenberg would be proud to use! Carry on!
