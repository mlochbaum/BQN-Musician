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

        Round ← {⌊0.5+𝕩}⌾(100⊸×)  # Nearest hundredth, for display

        Round 2⋆1|2⋆⁼ (3÷2)⋆↕13

At step 12, we arrive at a frequency that's very nearly in the same pitch class as the starting `1`. This is because that `3÷2` ratio is close to `2⋆7÷12`. Using that value instead we arrive back at the start exactly.

        Round 2⋆1|2⋆⁼ (2⋆7÷12)⋆↕13

We can stop at 12 notes to get an octave scale; [sorting](https://mlochbaum.github.io/BQN/doc/order.html#sort) the frequencies reveals that they follow a very regular distribution, as each note is a factor of `2⋆÷12` (or `12√2`) larger than the previous.

        Round ∧ 2⋆1|2⋆⁼ (2⋆7÷12)⋆↕12

        Round           (2⋆ ÷12)⋆↕12

The step `2⋆÷12` is called a "semitone" and `2⋆7÷12`, approximating `3÷2`, is called a "fifth", again for very bad reasons in both cases. Below you can trace how the larger step jumps around to hit every semitone, a path known as the "circle of fifths".

<!--GEN
pts ← 80×(•math.Sin ≍˘ ·-•math.Cos) (2×π) × ↕⊸÷12
_pae ← { "path"⊸At⊸Elt⟜("d"⋈𝕗∾˜·'M'⌾⊑ ·∾·⥊ "L "˘ ∾¨ FmtNum) }
Pa ← "z"_pae
pc ← "fill=none|stroke-linejoin=round|stroke-width=2"
Lab ← "text-anchor=middle|fill=currentColor" Ge Pos⊸Text¨⟜FmtNum
(⥊¯1‿2×⌜300‿105) SVG ⟨
  pc Ge ⟨
    "class=lilac" Pa pts
    "stroke=currentColor" Pa (12|7×↕12)⊏pts
  ⟩
  (1.3‿1.15⊸×¨<˘pts) Lab (⌊0.5⊸+)⌾(100⊸×) 2⋆1|2⋆⁼ (2⋆÷12)⋆↕12
⟩
-->

This octave scale is called the *chromatic scale*. But it's still not something anyone but Schoenberg would be proud to use! Carry on!

## Musical scales

The scales that most musicians work with are subsets of the 12-tone chromatic scale. To have a concrete example, let's take the *major scale*, which can be constructed by taking a seven-note section of the circle of fifths:

<!--GEN
maj ← (12|7×1-˜↕7)⊏pts
(⥊¯1‿2×⌜300‿105) SVG ⟨
  pc Ge ⟨
    "class=lilac" Pa pts
    "stroke=currentColor" ""_pae maj
  ⟩
  (1.2×<˘pts) Lab ↕12
  (("circle"At"class=red") Elt "r"‿"cx"‿"cy"≍˘·FmtNum 6⊸∾)¨ <˘maj
⟩
-->

In this diagram I've relabelled the notes starting at 0, instead of using relative frequencies. When numbering like this, we'll call 0 the "root note", so that a note's number is how many semitones it takes to get there from the root (but officially the name's "tonic"). Generally we'll display a scale with a simpler diagram like the one below, which just shows the notes included in the scale.

<!--GEN ring.bqn
ring.DrawRow ⟨⟨12↑/⁼12|7×1-˜↕7,"The major scale"⟩⟩
-->

So, one way to identify the major scale is with this note list `0‿2‿4‿5‿7‿9‿11`. There are two other representations that might be useful in computing various properties of the scale. One is a list with an entry for each note in the chromatic scale, marking the notes included in the scale with a 1 and leaving a 0 elsewhere. The [Indices](https://mlochbaum.github.io/BQN/doc/replicate.html) function would turn this representation *back* into the list of notes. To go the other way, we want [its inverse](https://mlochbaum.github.io/BQN/doc/replicate.html#inverse) `/⁼`. Note how the pattern of 1s and 0s corresponds to filled and empty circles going clockwise above.

        ⊢ maj ← ∧12|7×1-˜↕7  # Constructed by the circle of fifths

        12↑/⁼ maj

        (↕12) ∊ maj  # An alternate approach

We also make sure exactly 12 notes are represented with `12↑`. If we leave this off, scales that don't include note 11 will end up short. The other representation we might use lists the intervals in the scale, that is, how many semitones does it take to go from each note to the next? To get it, we [shift](https://mlochbaum.github.io/BQN/doc/shift.html) our scale up a step up and then subtract an unshifted copy. A somewhat interesting feature of the major scale is that every interval is one or two semitones. We shift in note 12 at the top end because it's equivalent to 0, and greater than the last note.

        {(12«𝕩)-𝕩} maj

Each of these alternate representations—I'll call them the "boolean" and "interval" representations—includes the total number of possible notes as part of its construction. For the boolean representation, it's the length of the list, and for the interval representation, it's the sum. The total could also be built into the note-list representation by adding a trailing 12, duplicating the note 0.

### Counting

Okay, once we've narrowed things down to subsets of the chromatic scale, we end up for the first time with a finite number of scales. How many? With the boolean representation this is pretty easy to answer. Every length-12 boolean list defines a scale, and every (12-tone octave) scale can be defined this way. There are 2 choices for each note (in or out), and they're all independent, so the total number of choices is the product of twelve twos.

        2⋆12

A common requirement is for the scale to include the root note, since the root is usually treated as a basis or home for the scale. In that case one of the choices is already made, leaving 11 to make.

        2⋆11

Nonetheless, quite a lot of choices. Much of scale theory is ultimately trying to decrease this number further!

## Modes

Okay, the root note. So, which note is it? Well, the way we've defined things I guess it'll be the pitch class of 1 Hz, so… 256 Hz? 512 Hz? This is a silly way to do things, and these pitches don't even fall in the standard chromatic scale, which is defined to have one of its notes at 440 Hz. The truth is that *any* note in the chromatic scale can serve as the root, and it's pretty common to change keys so that a different note is perceived as the root (setting aside the issue that there may not *be* a single clear root note).

One thing we're very interested in as part of scale theory is what happens if we keep our scale—that is, just the collection of notes—the same, and change the root. The root isn't really part of the scale, but it affects how we interpret it, since we numbered everything starting at the root. What if we wanted to renumber so that, say, the note currently labelled 2 becomes 0? We'd subtract 2, of course.

        maj

        maj - 2

But it's not useful to have `¯2` as a label: we'd rather have everything in the same range as before. Modulus (`|`) does this for use, adding or subtracting 12 until each number is at least 0 and less than 12 itself. We're basically doing [modular arithmetic](https://en.wikipedia.org/wiki/Modular_arithmetic), which is the natural way to work with pitch classes. And while we're at it let's sort the notes again, since they've gotten out of order.

        12 | maj - 2

        ∧ 12 | maj - 2

If we just look at this scale in isolation, it's certainly a different scale from the major scale: it's called the dorian scale.

<!--GEN
modes ← ((∧⌽¨·<12↑/⁼)12|7×1-˜↕7)⋈¨⟨
  "Ionian (major)","Dorian","Phrygian","Lydian"
  "Mixolydian","Aeolian (minor)","Locrian"
⟩
ring.DrawRow "Major"⌾(1⊑⊑) 2↑modes
-->

But that's moving all the notes to put the "new" root back where the old one was! If we don't do this then the two scales coincide exactly, so they're closely related. We call these scales "modes" of each other. In a shocking twist, this is a great name—it comes from the same Latin root as "modulus"! I think the mathematical term may have actually been derived from the musical one, explaining the apparent coincidence.

Every note of the major scale can be the basis of a new mode; they're all shown below along with their Greek names. These may not be the easiest to memorize but I like them. They have a consistent form and all sound fairly distinct (the first syllables are all different, and make nice abbreviations).

<!--GEN
(∾(-⊸⋈0.5)⋈˜¨¨(↕+¬÷2˙)¨4‿3) ring.DrawRow modes
-->

Other scales have their own modes, although this group, the "diatonic modes" (yes, we're firmly back in the realm of names that make no sense) is by far the most important in Western music. The major scale is asymmetric, so that all its modes are different from each other. This is pretty common, but there are also a [handful of scales](symmetric.md) where starting on a non-root note can give the same scale. So these scales have fewer modes than notes. This is possible because 12 is a composite number `2×2×3`, allowing 2-fold, 3-fold, 4-fold, or 6-fold symmetry. And of course, the chromatic scale has 12-fold symmetry, so it only has one mode!

<!--GEN
ring.DrawRow (⋈ 12↑/⁼)∘{⥊0‿4‿8+⌜0‿𝕩}¨ 1‿3
-->
