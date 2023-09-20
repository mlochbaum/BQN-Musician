# Tertian scales

[Tertian](https://en.wikipedia.org/wiki/Tertian) sounds a lot like "Martian". Sorry about that one—these scales are definitely used on Earth, and include all our most common ones like major and minor. All it means is "built out of thirds". I would have used "third scale" but this gets confusing when I want to talk about a few scales and the third one comes up.

Oliver Prehn (NewJazz) calls these "scales of harmonies" and presents them all in [this video](https://www.youtube.com/watch?v=Vq2xt2D3e3E) and [this pdf](https://newjazz.dk/Compendiums/scales_of_harmonies.pdf). The video goes into more detail than the audio examples here.

## What are they?

The problem at hand: there are too many [scales](scale.md). Also lots of them are terrible. Listing all possible scales by brute force, there are `2⋆11` in total, and 351 different classes if we consider rotations to be equivalent.

        ≠ allScales ← 1⊸∾¨ ⥊↕11⥊2

        Normalize ← { ⊑ ∨ ⌽⟜𝕩¨ ↕≠𝕩 }
        ≠ ⍷ Normalize¨ allScales

So we'll define a *tertian scale* to be one where two adjacent intervals—cyclically, so the last interval is adjacent to the first—always add to 3 or 4 semitones or steps. In theory terms, every scale third is either a minor third (3 steps) or major third (4 steps). And there are much fewer of these. We can list all of them by testing each scale to see if it satisfies our required condition. `Int` finds the sizes of all `𝕨`-note intervals and `IsTertian` tests if all 2-note intervals are 3 or 4 steps.

        Int ← { 12 | (𝕨⌽𝕩) - 𝕩 }
        IsTertian ← { ∧´ (2 Int /𝕩) ∊ 3‿4 }

        ≠ tertianScales ← IsTertian¨⊸/ allScales

        ≠ ⍷ Normalize¨ tertianScales

In such a scale, two thirds together always make one of the tertian chords: diminished (3/3), minor (3/4), major (4/3), or augmented (4/4). Why aren't other sizes good? They still form or imply chords, but the root of the chord is almost never the bottom note. For example, a 3/5 pair of intervals forms a major chord, starting on the last note (it splits an octave in 3-5-4, which rotates to 4-3-5), and 2/4 implies a dominant chord, sitting on the second (4-3-3-2, after rotation). It might sound wild that a listener would do all this work to force a strange scale into a familiar shape, but after listening to so much music by writers who intentionally apply these sorts of rearrangements, it's just impossible not to!

We might also try to form chords based on larger or smaller scale intervals instead of thirds. This often works, but yields chords that overlap in unusual ways, so that each scale would require its own little theory to understand. With one chord on each note, a common harmonic theory can be used across many scales.

This approach works well for many kinds of music, especially more harmonically complicated ones like jazz and progressive rock. But pentatonic and blues scales aren't tertian scales, since they have 2-step and 3-step intervals next to each other. When musicians use these scales, they always play over chords with notes from outside the scale, so these scales have a different purpose than tertian ones in some sense.

## What are they really?

So we have 33 scales, which form 7 classes if you put scales that are rotations of one another in the same class. Well, 7 sounds like a manageably small number. But this brute-force approach isn't very enlightening. The tertian scales can be analyzed with very little casework, it turns out.

A comment about intervals is worth making even though we won't need it: an interval in any scale is at least one step, because a scale can't feature the same note twice, and in a tertian scale it's at most three steps. That's because, when added to an adjacent interval, the total is at most four steps.

In a tertian scale, the total number of steps in all the thirds is 24. This is because the total size of all the intervals is 12 (it's an octave scale), and each interval appears in exactly two thirds: the one that begins at its lower note and the one that ends at its upper note. So if there are `a` 3-step intervals and `b` 4-step ones, we know that

    24 = (3×a) + 4×b
       = (3 × a+b) + b
       = (3×n) + b

where `n ← a+b` is the number of notes in the scale. Since `0≤b≤n`, we find that

    24 ≤ 3×n  →  8 ≤ n
    24 ≥ 4×n  →  6 ≥ n

So `n` can be 6, 7, or 8. Given `n`, it's easy to solve the equation `24 = (3×n) + b` for `b`, and then `a = n - b`. Let's write a function to compute `a` and `b` for us.

        Composition ← { b←24-3×𝕩 ⋄ a←𝕩-b ⋄ a‿b }
        Composition 6

When `n=6`, this tells us `a=0` and `b=6`: every third in the scale has length 4. As a result, notes 0, 2, and 4 occupy positions 0, 4, and 8, that is, they form an augmented chord. The remaining notes also form an augmented chord, but can start at position 1, 2, or 3. The following bit of code shows how to use Table (`⌜`) to make the scale for position 1, and then puts all possibilities in one array.

        0‿4‿8 +⌜ 0‿1

        > { ⥊ 0‿4‿8 +⌜ 0‿𝕩 }¨ 1‿2‿3

<!--GEN ring.bqn
ring.DrawTertianRow 1‿2‿3 {⥊0‿4‿8+⌜0‿𝕩}⊸((12↑/⁼∘⊣)<⊸∾Fmt⊸⋈)¨ ⟨
  "Inverse augmented"
  "Whole tone"
  "Augmented"
⟩
-->

<!--GEN keys.bqn
Fig ← "figure" Enc Play∘Keys⊸⋈⟜("figcaption"⊸Enc)´
Samples ← ("div"At"class=wrap") Enc Fig¨
Samples ⟨
  "0-105498c-{98}51{85}40--"‿"Inverse augmented"
  "0246ca82048aca62--"‿"Whole tone"
⟩
-->

The scales corresponding to 1 and 3, which are modes of each other, are called augmented scales. They're strange and disorienting, certainly the weirdest tertian scales. However, the very symmetrical scale with note 1 at 2 is a famous construct called the whole tone scale, which can sound elegant, ethereal, and beautiful. Unfortunately, Debussy has used up this scale, and it's no longer possible to make original music with it.

        Composition 8

When `n=8`, `a=8` and `b=0`, so every third is 3 steps. In a similar pattern to the 6-note scales, each splits into two rings of four (each ring is now a diminished seventh). Now there are only two possibilities, as note 1 can start on 1 or 2, but position 3 is occupied by note 2.

        > { ⥊ (3×↕4) +⌜ 0‿𝕩 }¨ 1‿2

<!--GEN
ring.DrawTertianRow 1‿2 {⥊(3×↕4)+⌜0‿𝕩}⊸((12↑/⁼∘⊣)<⊸∾Fmt⊸⋈)¨ ⟨
  "Octatonic"
  "Other octatonic"
⟩
-->

<!--GEN
Samples ⟨
  "0369-a674173a{{-676}}--"‿"Octatonic"
  "02359865bc96305--"‿"Other octatonic"
⟩
-->

These scales are modes of each other and are fittingly called octatonic (eight tone) scales. They're a bit creepy sounding, as well as unstable in that they "want" to resolve to some other scale. So they're most often used in a transient way, moving between chords or adding character in jazz improvization and late classical music.

### The seven-note case

The interesting case is `n=7`. We've shown 3 scales with `n=6` and 2 with `n=8`, so `33-5 ←→ 28` scales must fit into this case. It's no coincidence that this number is a multiple of 7: a 7-note scale can't display any symmetry at all, so that each has 7 modes. So we should expect 4 distinct classes here.

        Composition 7

We see that every 7-note scale contains 3 4-note thirds and 4 3-note thirds (each gives us half of the 24 total steps). Just like we can represent a scale by listing all its intervals, we can also represent one with an odd number of notes by listing all its thirds. This goes through the notes in the order shown below, which reaches all of them before returning to the root.

        7 | 2×↕8

An arrangement consists of choosing which 3 of the 7 thirds should be larger, an instance of the [combination](https://en.wikipedia.org/wiki/Combination) function. To count them, we can pick the large thirds one by one: there are 7 options for the first choice, 6 for the second, and 5 for the third. But this counts each option 6 times, because for any combination we could have selected the intervals in 6 different orders.

        (7×6×5) ÷ 3×2×1

        7 •math.Comb 3

Too many scales! But we can generate the normalized classes according to this scheme to see what goes wrong.

        ≠ patterns ← (24=+´)¨⊸/ 3 + ⥊↕7⥊2
        uniq ← > ⍷∨ Normalize¨ patterns

        unum ← (∧12|+`)˘uniq  # As note numbers
        uint ← 12|1⊸⌽⊸-˘unum  # Interval sizes

        ⟨uniq, unum, uint⟩

The first of these classes is not a real scale: it contains the root note twice, so it only has six distinct notes and these don't qualify as a tertian scale.

        12 | +` 4‿4‿4‿3‿3‿3‿3

        12↑/⁼ 12 | +` 4‿4‿4‿3‿3‿3‿3

So, once that case is stricken, there are four classes of 7-note tertian scales, accounting for 28 total.

### Four seven-note classes

Let's dig into the 7-note scale classes we've identified above. I'll go ahead and break the suspense by giving each a name. Below, I've reordered the intervals to give the best-known example of each scale, and also placed the classes in a more logical order, musically speaking. Now the scales form a loop where each is only one changed note away from the next! This sort of one-note change reveals a rich structure to the 7-note scales, described in the page on [tertian modulations](modulation.md).

*No, I will not be writing "ascending melodic minor".*

<!--GEN
"table" Enc (⟨"th"⟩»"td"¨)⊸(("tr"Enc(At⟜"class=nopad"⌾(¯1⊸⊑)<⊸(⊣¨))Enc¨⊢)¨) ⟨
  "Thirds"       ‿"Intervals"    ‿"Name"
  "4 3 4 3 4 3 3"‿"2 2 1 2 2 2 1"‿"Major"
  "4 4 3 3 4 3 3"‿"2 1 2 2 2 2 1"‿"Melodic minor"
  "4 4 3 3 3 4 3"‿"2 1 2 2 1 3 1"‿"Harmonic minor"
  "4 4 3 4 3 3 3"‿"2 2 1 2 1 3 1"‿"Harmonic major"
⟩ ∾⟜<¨ Play∘Keys¨⌾(1⊸↓) ⟨"Audio"
  "024579bc--cc2{-4}7450295{-2}7b7{42}0-"
  "023579bc--c{-b}c-79{{5757}30}259{cb}c53{{232323232323}}0--"
  "023578bc--c-{78b8}7-5-3-{2373}2-0--"
  "024578bc--c{{-8b8}}7452487{{-454}}247-b-c--"
⟩
-->

<!--GEN
ring.DrawTertianRow {i‿n:⟨12↑/⁼0∾+`i-'0',n⟩}¨ ⟨
  "2212221"‿"Major"
  "2122221"‿"Melodic minor"
  "2122131"‿"Harmonic minor"
  "2212131"‿"Harmonic major"
⟩
-->

The first set of scales are the diatonic modes, including major (ionian) and minor (aeolian) as well as some less well-known but still very common scales such as dorian and lydian. They're way more common than the other kinds, and that modulations page gives some good reasons for this.

Every class other than that one has two 4-step thirds in a row, which form an augmented chord. Perhaps because this chord isn't found in diatonic scales, it sounds spacey and eerie. It's also ambiguous, because it splits the octave in 4-4-4, so rearranging the notes gives another augmented chord with a different root. But within a 7-note scale the root can always be identified, because two of the 4-step intervals are scale thirds, while the last is made up of 3 scale intervals and not 2. Similarly, the harmonic minor and major scales both have three 3-step thirds in a row, making up a diminished seventh chord that splits the octave 3-3-3-3. It's another sound that's not found in a diatonic scale, and often comes across as hungry or sour. Both of these chords are great ways to transition between different scales or harmonic frameworks, because their symmetry makes them free for reinterpretation and they readily resolve into "nicer" chords.

The definition of a tertian scale works either ascending or descending, so if we invert a tertian scale we get another tertian scale. Here's what that does to our four classes of scales:

        {𝕩 ⋈ Normalize∘⌽˘ 𝕩} 4‿2‿3‿1 ⊏ uniq

A diatonic scale inverts to give another diatonic scale, as does a mode of melodic minor. But minor and major harmonic scales invert to give each other. Musically speaking, inversion isn't really a relationship you'd want to use in a work. But it does tell us that minor harmonic and major harmonic have similarities in overall tonality, because they feature the same intervals. In particular they both have that distinctive 1-3-1 pattern, which harmonic minor and harmonic major in particular place at the end.

## Loose tertian scales

A few occasionally-used scales aren't quite tertian because the starting and ending intervals are both a single step, so that they add up to a 2-step third, which is too small. We can find all of these scales by changing the handling of the last interval from `IsTertian`:

        IsLooseTertian ← { i←2 Int /𝕩 ⋄ (2=¯1⊑i) ∧ ∧´(¯1↓i)∊3‿4 }

        > IsLooseTertian¨⊸/ allScales

Two of them just add a note to an augmented scale (which to be fair is a cool idea), and there are three different octatonic scales that start with one inversion (1 1 0…1 0) and end with another (1 0 1…0 1), switching over in different places. Three of the four remaining scales are known, and the other one certainly seems like it should be, as a reasonable variation of the major scale, but I haven't seen it before.

<!--GEN
ring.DrawTertianRow ('0'-˜⊏)⊸∾¨ ⟨
  "110011010101"‿"Ionian ♭2?"
  "110011011001"‿"Double harmonic"
  "110101010101"‿"Neapolitan major"
  "110101011001"‿"Neapolitan minor"
⟩
-->

The octatonic scales are also fairly interesting. In each of these, the notes next to the root have just one empty space next to them, because otherwise there would have to be a group of three notes in the middle.

        > (8=+´)¨⊸/ IsLooseTertian¨⊸/ allScales

This means that taking out the root leaves us with a [rootless](modulation.md#going-off-root) tertian scale, which we can classify according to the system above. The removed note is the middle of a sequence of three 2-step intervals, so we end up with all the scales that feature this pattern: the diatonic scale has it once, and the melodic scale has two that overlap. The whole-tone scale also has it, and because it has only 6 notes it gives the Neapolitan major scale (7 notes) instead of an octatonic one.

<!--GEN
ring.DrawTertianRow ('0'-˜⊏)⊸∾¨ ⟨
  "010101101101"‿"Offset melodic"
  "010110101101"‿"Offset diatonic"
  "010110110101"‿"Offset melodic"
  "010101010101"‿"Offset whole-tone"
⟩
-->
