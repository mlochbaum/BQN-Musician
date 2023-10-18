# Oscillators

An oscillator is a simple repeating signal. In synthesizers they're the starting point for the sound—an oscillator on its own sounds terrible, but after some filtering, combining, and other transformations you might have something nice. Another use is as a sort of control value: one oscillator might set the frequency of another (like a vibrato) or its volume (tremolo).

## The basic oscillators

There's sort of a standard collection of oscillators that are easy to generate and provide a variety of tones. They're defined in BQNoise's [oscillator.bqn](https://github.com/mlochbaum/BQNoise/blob/master/oscillator.bqn); we'll walk through our own versions here.

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

        Play •math.Sin 40÷˜↕1e5

A sine wave is a pure tone, meaning it has only one frequency. It's the sound of an oscillator that, when displaced, pushes back with force proportional to the distance to its resting spot. A tuning fork comes close to this behavior. We hear by separating sound into these tones—hair cells function as oscillators with each resonating at a particular frequency—which makes a sine the simplest oscillator in terms of its harmonic content.

The sine of any arithmetic progression, such as `40÷˜↕1e5`, will give *some* sine wave, but usually we want to specify the frequency. For this we need to know the sample rate, which on this site is 44.1kHz or 44100 samples per second. Suppose we want an A, 440 cycles per second. We can make a 1-second signal that goes from 0 to 1 with `(↕rate)÷rate`, or, using a [hook](https://mlochbaum.github.io/BQN/doc/hook.html), `↕⊸÷ rate`. Multiplying by 440 makes it go from 0 to 440, so it's increasing at 440 (no unit!) per second. But the sine function is defined to repeat at intervals of 2π, so to turn this into a 440Hz tone we should multiply by 2π and then take the sine.

        rate ← 44100
        phase ← 440 × ↕⊸÷ rate
        Play •math.Sin (2×π) × phase

The `phase` value indicates how many cycles of the oscillator we've been through. The rule for an oscillator, as opposed to just any random function, is that it only depends on the fractional part of the phase—it repeats every time the phase increases by 1. Given this, the simplest oscillator in mathematical terms is just the fractional part of the phase, `1 | phase` ("phase modulo 1"). However, this gives a wave that spans 0 to 1 when it should be using the balanced range from -1 to 1. Transforming with `{(2×𝕩)-1}` fixes this. A quick way I might write this function is `-⟜¬`, since `-⟜¬x` is `x-¬x`, or `x-1-x`, which gives `(2×x)-1` after working out the subtraction.

<!--GEN
"Sawtooth wave" Plot [-⟜¬4÷˜/1‿2‿0‿2‿1,0‿1‿¯1‿1‿¯1‿0]
-->

        Center ← {(2×𝕩)-1}
        Play Center 1 | phase

It's called a sawtooth or saw for its appearance, and it's a pretty abrasive sound, with the most higher-frequency content of any of the oscillators we'll see here. It's nearly always used with low-pass filters or some other way to damp it down for this reason.

If we take the absolute value of a sawtooth wave, the jumps from 1 to -1 are no longer jumps and we get a wave that goes up and down. But once again it only spans 0 to 1, so we need to center it.

<!--GEN
"Triangle wave" Plot [-⟜¬8÷˜/1‿1‿0‿1‿0‿1‿0‿1‿1,0‿1‿¯1‿1‿¯1‿0]
-->

        Play Center | Center 1 | 0.25 + phase

The result is called a triangle wave, and it's a pretty mellow sound, much closer to a sine wave.

Finally, a square wave is what we get if we always max out the amplitude in one direction or the other. We can do this by comparing the fractional part of the phase to a half and then centering: for the first half of the wave, the comparison is false, giving `¯1`, and for the second half, the comparison is true and we get `1`. This results in a very loud wave, so I'll cut it in half here (which undoes `Center`'s doubling: `0.5 × Center` could also be written `-⟜0.5`).

<!--GEN
"Square wave" Plot [-⟜¬1↓¯1↓2/↕⊸∾⊸÷4, 2/4⥊¯1‿1]
-->

        Play 0.5 × Center 0.5 < 1 | phase

The sound is similar to a triangle wave, but sharper. Changing the value `0.5` here gives a family of waves called pulse waves, that spend more time at the top or bottom. I don't know what these are good for, but then I don't use square waves a lot either.

## Harmonics

A way to get some insight into how the basic oscillators sound is to split each one into its harmonics. An oscillator that repeats exactly at frequency `f` is always composed of sine waves that also repeat at this frequency. This includes the sine wave with frequency `f`, but also the one at `2×f` and `3×f` as these simply repeat multiple times in a cycle (there could also be a constant offset, frequency `0×f`, but we've centered things precisely to remove this). The table below shows which harmonics each oscillator has and how loud the harmonic with frequency `n×f` is relatively.

| Wave     | Harmonics | Amplitude
|----------|-----------|-----------
| Sine     | None      | 0
| Triangle | Odd       | `÷n⋆2`
| Square   | Odd       | `÷n`
| Saw      | All       | `÷n`

This explains the relationship between triangle and square: with the same set of harmonics they have some tonal similarity, but the square is more tilted towards high frequencies.

Why does nothing use only the even harmonics? Well, the odd harmonics are 1, 3, 5, and so on, with the 1 giving the frequency of the oscillator. The even ones 2, 4, 6 are all multiples of 2—this is really an oscillator with all harmonics but at twice the frequency!

## Varying frequency

At this point it's easy enough to make a function that plays particular note for a given number of samples, and [join](https://mlochbaum.github.io/BQN/doc/join.html) together a few of them to make a melody:

        SineNote ← { len 𝕊 freq:
          phase ← freq × (↕len) ÷ rate
          •math.Sin (2×π) × phase
        }
        Play ∾ (rate÷4) SineNote¨ 440 × 2⋆0‿7‿4‿5‿9‿5‿2‿4‿0÷12

With an [envelope](envelope.md) that starts and ends at 0, this would be okay, but here we get clicks between many of the notes (they're not even consistent!). These are caused by sudden jumps in the value: each sine wave starts at 0, but ends wherever it happens to be when the quarter-second is up. To make the changes smooth we should carry the phase over from one note to the next instead of restarting at zero.

A clean way to do this is to work with phase differences instead of jumping to the phase immediately. In `freq × (↕len) ÷ rate`, the difference between any two samples is `freq ÷ rate`. So we can define a function taking an array `freqs` giving the frequency at each sample. It'll compute the corresponding phase differences, then sum to get a continuous phase (to align with `↕len` above starting at 0, it might be more correct to shift right one position, but a 1-sample phase difference doesn't matter at all).

        Sine ← { 𝕊 freqs:
          phase ← +` freqs ÷ rate
          •math.Sin (2×π) × phase
        }
        Play Sine (rate÷4) / 440 × 2⋆0‿7‿4‿5‿9‿5‿2‿4‿0÷12

We use [Replicate](https://mlochbaum.github.io/BQN/doc/replicate.html) (`/`) to compute the array of notes that we want to pass in. This way is a better fit for the array style because it works with one big array instead of a nested one. And like Each (`¨`) before, Replicate can take a list of lengths for its left argument to give the notes different durations.

Now we have complete control of the frequency, down to the sample! This allows us to use dynamic frequencies that slide or wiggle around (portamento, vibrato). To be discussed more in a page on frequency modulation.

The use of a sum that increases forever might be concerning because it eventually loses precision. But in a typical BQN implementation that uses double-precision floats, you have 53 bits of precision which is quite a lot. To get down to 24 bits after the decimal, there need to be about 29 above it. At an upper-treble frequency of 10kHz, the phase increases at `60×60×1e4` per hour, so how long would that take?

        ((2⋆53) ÷ 2⋆24) ÷ (60×60×1e4)

About 15 hours, which is also like, 20 gigabytes of data for a single channel. A waveform with sharp changes, or other processing, could amplify phase imprecisions, but I think there's no need to worry about this problem at practical scales. But if necessary, you could do the sum in segments and apply `1|` to the carried phase in between.
