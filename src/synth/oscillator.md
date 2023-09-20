# Oscillators

An oscillator is a simple repeating signal. In synthesizers they're the starting point for the sound—an oscillator on its own sounds terrible, but after some filtering, combining, and other transformations you might have something nice. Another use is as a sort of control value: one oscillator might set the frequency of another (like a vibrato) or its volume (tremolo).

        Play •math.Sin 40÷˜↕1e5

<!--GEN
Path ← ("path"At"stroke-width=2|stroke=currentColor") Elt "d"⊸⋈
dim ← 128‿32
gr ← "text-anchor=middle|fill=none"
Plot ← {
  (⥊(-˜`¯30‿¯30≍30‿4)+¯1‿2×⌜dim+20) SVG gr Ge ⟨
    ("text" Attr "fill"‿"currentColor"∾Pos 0‿¯1×20+dim) Enc 𝕨
    Path 'M'⌾⊑∾⥊ ⍉"L "∾¨ FmtNum dim×1‿¯1×𝕩
  ⟩
}
"Sine wave" Plot (-⟜¬ ≍ ·•math.Sin(4×π)⊸×) ↕⊸÷100
-->

A sine wave is a pure tone, meaning it has only one frequency. It's the sound of an oscillator that, when displaced, pushes back with force proportional to the distance to its resting spot. A tuning fork comes close to this behavior. We hear by separating sound into these tones—hair cells function as oscillators with each resonating at a particular frequency—which makes a sine the simplest oscillator in terms of its harmonic content.

The sine of any arithmetic progression, such as `40÷˜↕1e5`, will give *some* sine wave, but usually we want to specify the frequency. For this we need to know the sample rate, which on this site is 44.1kHz or 44100 samples per second. Suppose we want an A, 440 cycles per second. We can make a 1-second signal that goes from 0 to 1 with `(↕rate)÷rate`, or, using a [hook](https://mlochbaum.github.io/BQN/doc/hook.html), `↕⊸÷ rate`. Multiplying by 440 makes it go from 0 to 440, so it's increasing at 440 (no unit!) per second. But the sine function is defined to repeat at intervals of 2π, so to turn this into a 440Hz tone we should multiply by 2π and then take the sine.

        rate ← 44100
        phase ← 440 × ↕⊸÷ rate
        Play •math.Sin (2×π) × phase

The `phase` value indicates how many cycles of the oscillator we've been through. The rule for an oscillator, as opposed to just any random function, is that it only depends on the fractional part of the phase—it repeats every time the phase increases by 1. Given this, the simplest oscillator in mathematical terms is just the fractional part of the phase, `1 | phase` ("phase modulo 1"). However, this gives a wave that spans 0 to 1 when it should be using the balanced range from -1 to 1. Transforming with `{(2×𝕩)-1}` fixes this.

        Center ← {(2×𝕩)-1}
        Play Center 1 | phase

<!--GEN
"Sawtooth wave" Plot [-⟜¬4÷˜/1‿2‿0‿2‿1,0‿1‿¯1‿1‿¯1‿0]
-->

It's called a sawtooth or saw for its appearance, and it's a pretty abrasive sound, with the most higher-frequency content of any of the oscillators we'll see here.

If we take the absolute value of a sawtooth wave, the jumps from 1 to -1 are no longer jumps and we get a wave that goes up and down. But once again it only spans 0 to 1, so we need to center it.

        Play Center | Center 1 | 0.25 + phase

<!--GEN
"Triangle wave" Plot [-⟜¬8÷˜/1‿1‿0‿1‿0‿1‿0‿1‿1,0‿1‿¯1‿1‿¯1‿0]
-->
