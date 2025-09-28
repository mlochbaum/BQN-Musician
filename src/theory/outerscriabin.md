# Scriabin's outer poetry

In the years leading up to his untimely death, the mad Russian Alexander Scriabin began to work sophisticated mathematical structures into his compositions. And one hundred and eleven years after its publication, I have found the perfect means to narrow the audience for this website.

Take a listen to the first four bars of the Poème [Opus 71](https://imslp.org/wiki/2_Po%C3%A8mes,_Op.71_(Scriabin,_Aleksandr)), No. 1.

<!--GEN
Figure ← "figure" Enc ⊢⊘("figcaption"⊸Enc⊸(⋈˜))
Score ← FmtNum⊸{i‿w𝕊b‿h:
  t ← ∾"Score for bars "‿b‿" of Scriabin's Opus 71, Number 1"‿h‿"."
  a ← ⟨∾"audio_outerscriabin/im"‿i‿".png", w∾"%", t⟩
  Figure ""Enc˜ "img"∾∾ "src"‿"width"‿"title" {" "∾𝕨∾"="""(∾∾1↓⊣)𝕩}¨ a
}
0‿98 Score "1 to 4"‿""
-->

<!--GEN
⟨Key,Keys⟩ ← {
load ← •Import "../../BQNoise/load.bqn"
f‿s‿m‿o ← Load¨ "filter"‿"scale"‿"mix"‿"oscillator"
fr ← 44100

Key ⇐ {
  d ← ¯1.2e¯4×1-4÷√𝕩
  k ← ÷ 10 × 0.2 + ×˜ 0.17 + (2⋆d×↕𝕨) × 0.25 o.Sine 𝕩×1+÷4+8÷˜↕𝕨
  (⌽↕⊸÷300) m.Fadeback 10 f.Hp2 ¯3‿800 f.Hshelf (↕⊸÷10) m.Fadefront k
}

notes ← ∾"0a"+⟜↕¨10‿26
Keys ⇐ { rhythm‿root 𝕊 𝕩:
  m ← ¬ 𝕩∊⥊br←"{}"≍"[]"
  beat ← ⌊ rhythm × m / ×˝ 2‿3 ⋆ (+`-˜˝)˘ br=⌜𝕩
  t ← (≠notes) > n ← notes ⊐ m/𝕩
  ∾ ⟨0⥊˜+´(¬∨`t)/beat⟩ ∾ ((+´beat)⊸«⊸-t/+`»beat) Key¨ (t/n) s.Trans root
}
}
eighth ← 12600
Chords ← ∾ eighth⊸×⊸{0=≠𝕩?𝕨⥊0 ; +´⥊ 𝕨 Key¨ 110 × 2⋆12÷˜𝕩}´¨
Wrap ← {"div"At"class=wrap|style=padding:"∾¯1↓∾∾⟜"em "¨FmtNum∾⟜3⊸∾´𝕩}⊸Enc
Piano ← ""Enc˜ "audio src=""audio_outerscriabin/p"∾•Repr∾".mp3"" controls"˙

1‿0 Wrap ⟨
  "Struggling pianist" Figure Piano 0
  "Lazy synthesist" Figure Play 2÷˜ +´ ⟨
    1.4 × eighth‿220 Keys "95{-9}8---c89cgh--[5-9cghlost-solhgc9]59c"
    Chords ⟨
      ⟨3, 2-˜⥊0‿15+⌜0‿8⟩, 2‿⟨⟩ ⟩∾(1⋈¨2-˜¯12‿0‿8‿15‿19)∾⟨ 2‿⟨⟩
      ⟨3, 2+7⊸≠⊸/⥊0‿15+⌜0‿7+⌜0‿4⟩, 2‿⟨⟩, 1‿⟨6⟩, 3‿⟨13⟩, ⟨3, 2+0‿7‿11⟩
    ⟩
  ⟩
⟩
-->

What wretched chord could create that spine-tingling arpeggio? Would you believe… D major seventh in root position? Yes, really! The same chord that's usually seen as sweet and maybe a touch wistful, as exposed by more conventional harmony:

<!--GEN
0.5‿0.5 Wrap ⟨
  Figure Piano 1
  Figure Play 2÷˜ +´ ⟨
    1.4 × eighth‿220 Keys ⥊3‿1/[
      "[5-9cghlost-solhgc9]"
      "[-cghlolhghlostsol-]"
    ]
    0.6 × Chords 6⌾(⊑¯1⊸⊑) 7⥊ (6(⊢⋈-)4+÷8) ⋈¨ 5+⟨⥊0‿7+⌜0‿4, 0‿5‿9⟩
  ⟩
⟩
-->

So the _true_ source of the eerie chill is… well actually the left hand is just playing a shell voicing of B (written C flat) major seventh. In root position. Obviously these two mild-natured chords do not get along, and if you know much about harmony it's not such a mystery. A major seventh contains two 4-semitone intervals, and we're shifting it by 3 semitones (plus an octave) to place it on top of itself. This makes for clashing 1-semitone offsets, with most notes even falling into tone clusters like D flat and D against E flat in a lower octave—it'd be a total modernist mess if not for that octave separation. We would also get the harmless shared note of G flat, but this is exactly what's left out of the B chord in the shell voicing.

<!--GEN
KSVG ← {¯100‿(-𝕨)‿512‿128 SVG "fill=currentColor|text-anchor=middle" Ge 𝕩}
Circ ← "circle" Elt "r"‿"cx"‿"cy"≍˘·FmtNum 8∾⋈
Pd ← {"d"⋈ ∾⥊⍉𝕩} ∾⟜Fmt¨
Lines ← "path" Elt {𝕨 ⊢⊘∾ ≍ "ML" Pd 𝕩}
LinesC ← "class"⊸⋈⊸Lines
LinesS ← ("stroke-width"⋈Fmt)⊸Lines
afc ← ∾ (⊢∾¨⟜↓¨∊⟜"CF"↓¨'♭'˙) 'A'+↕7  # Chromatic scale A♭…G
PX ← 23×⊢ ⋄ y ← 0‿46 ⋄ ty ← 32+⊢´y
pts ← y ⋈˜¨ PX⌽+⌜˝3‿4‿7×⌜↕2
_xKeyNotes ← {ky PX _𝕣 k: kf ← 2=≠¨k ⋄ ⟨
  "class=blackKey" Ge {t‿o‿p:t LinesS (ky-18‿o)⋈˜⌜PX p}¨ ⟨
    22‿12‿(/kf)
     1‿ 4‿(0.5+/∧⟜«¬kf)
  ⟩
  "font-size=14" Ge (PX↕≠k) (Pos⋈⟜(⊢´ky))⊸Text¨ k
⟩}
KeyNotes ← PX _xKeyNotes
Maj7 ← {𝕊y: "font-size=18" Ge y (Pos (PX ¯2)⊸⋈)⊸Text¨ "DB"∾¨<"maj⁷"}
24 KSVG ⟨
  ⟨⊑y,ty⟩ KeyNotes 15⥊3⌽afc, Maj7 y
  "stroke-width=3"Ge (3⥊"yellow"‿"green") LinesC⟜{𝕏pts}¨ ⟨⊢, ⍉, 1‿0‿0⍉⌽˘⟩
  "stroke-width=1.75|class=purple" Ge "stroke-dasharray=2 3"⊸Ge⌾⊑ {
    (10↑5≠↕8) ⊔ Circ´¨ (⥊pts)∾(PX 2‿12)⋈¨y
  }
  "class=red|style=fill:none|stroke-width=2" Ge {
    {"path" Elt "MLLL" Pd ∾⟜⌽˝ (PX 𝕩+-⊸⋈1.45) ⋈⌜ ty+4‿12}¨ 3‿11
  }
⟩
-->

<!--GEN
"All in one octave" Figure 1‿0.5 Wrap (Piano 2) ⋈ Play 2÷˜ {
  p ← 220 × 2⋆12÷˜ ∧4+⍷12|2-˜⥊0‿3+⌜0‿7+⌜0‿4
  +´ (400×↕∘≠)⊸(⥊⟜0⊸»¨) (8×eighth) Key¨ p
}
-->

The entire work is practically woven out of this idea, of adding one thing to a transposed copy. In preparation to unravel it, I'd like to dissect one of Scriabin's favorite devices, the octatonic scale. This is the [symmetric scale](symmetric.md) that repeats every 3 semitones, alternating 1-step and 2-step intervals.

<!--GEN ring.bqn
ring.DrawTertianRow ⋈⋈ 12↑/⁼ ⥊+⌜˝0‿1×⌜˜1‿3‿6
-->

As discussed [here](tertian.md#what-are-they-really), an octatonic scale is composed of two diminished seventh chords (and it's the [complement](complement.md) of another). To put this another way, you can get it by taking one diminished seventh, and adding it to itself shifted up 1 semitone—or 4 or 7 (take note!) or -2, because that chord is symmetric at 3 semitones. In BQN we can write this as an addition [table](https://mlochbaum.github.io/BQN/doc/map.html#table), which is good because Outer Product, as APLers call it, is the [only primitive I know](https://mlochbaum.github.io/OuterProduct/commentary.html).

        3×↕4         # Diminished seventh chord

        0‿1 +⌜ 3×↕4  # Two of them gives octatonic

        0‿1 +⌜ 0‿6 +⌜ 0‿3  # It's a cube?

It's less often mentioned that the diminished seventh chord itself can be decomposed this way, into a tritone (6 semitones) plus itself shifted by 3 steps. Or a 3-semitone interval with a 6-step shift: a cool property of `+⌜` is that the arguments can be rearranged any which way and it will only affect the ordering of the axes, not which values appear (this depends on addition being commutative). We can draw this 3-way addition table as a cube. See how the upper cell `[0‿3,6‿9]` matches up with the top face and the other one with the bottom?

<!--GEN
intCol ← (⊢∾1↓⌽) @‿"red"‿@‿"yellow"‿"green"‿"bluegreen"‿"purple"
Cube ← {y0‿dy‿a‿s‿c 𝕊 i:
  pts ← (y0+⌜˝dy×⌜↕2) ⋈˜¨ PX⌽⎉(a-˜=)s+⌜˝i×⌜↕2
  lns ← ⍉⍟(↕=) pts
  ic ← i ⊏ intCol
  ⟨
    "stroke-width=3" Ge {3>≠i ? ic LinesC¨ lns ;
                         (⊢˝⊸∾ic) LinesC¨ 2(↑(¯1⌽∾⟜⌽)·<˘·⍉⁼⊑)lns }
    ("stroke-width=1.75|class="∾c) Ge Circ´¨ ⥊pts
  ⟩
}
28 KSVG {
  y ← 0⋈+´| dy ← 40‿10‿6
  ⟨
    (0‿28+y) KeyNotes 13⥊3⌽afc
    0‿dy‿1‿1‿"bluegreen" Cube 1‿3‿6
  ⟩
}
-->

We'll return to the octatonic scale, but as it turns out, Scriabin's major sevenths are subject to the same trick, just with the intervals 4 and 7 instead of 3 and 6. Together with the 3-step transposition, we have another cube!

        0‿7 +⌜ 0‿4  # The notes of a major seventh chord

<!--GEN
28 KSVG {
  y ← 0⋈+´ dy ← 38‿14‿0
  ⟨
    (0‿28+y) KeyNotes 15⥊3⌽afc, Maj7 y
    0‿dy‿0‿0‿"purple" Cube 3‿4‿7
  ⟩
}
-->

And those morose notes that open the piece are also an addition table! The bass notes G and E flat are separated by 8 steps, as are B flat and G flat above. As with the major sevenths, the distance between these two pairs is 3 steps, plus an octave. If we move G up an octave and G flat down, we get a compact form:

<!--GEN
28 KSVG {
  y ← 0⋈+´ dy ← 38‿14
  ⟨
    (0‿28+y) KeyNotes 13⥊3⌽afc
    0‿dy‿0‿4‿"purple" Cube 3‿4
  ⟩
}
-->

What a familiar shape! To get the major sevenths from these notes you shift one copy down by 4 steps, and another up by 3 steps. But this is not the end of it. The next thing Scriabin does is play the opening again, shifted up by 3 steps: now it begins with an exact subset of the major sevenths! Specifically it takes the upper half of each 7-step interval, leaving D and keeping A, and so on (G flat stays, by virtue of appearing as both a lower and an upper half), with some shuffling between octaves of course.

<!--GEN
OctBrak ← {
  p ← "MLLL"˘⊸(Pd○⥊) ∾⟜⌽˝˘ (PX (1.5+3×𝕨⊣↕6)+⌜-⊸⋈0.95) ⋈⌜ 𝕩+0‿8
  "class=bluegreen|style=fill:none|stroke-width=1.5" Ge "path" Elt p
}
{
h ← (n←4) × y ← 20 +´ dy ← 38‿14‿0
tx ← PX ¯2
C ← {i 𝕊 d‿x: ⟨i×y,d↑dy,0,x,"purple"⟩ Cube d↑3‿4‿7}
¯100‿¯28‿512‿(60+h) SVG "fill=currentColor|text-anchor=middle" Ge ⟨
  (0⋈12+h) KeyNotes 18⥊3⌽afc, OctBrak h+15
  ("font-size"‿"14" ∾ Pos tx‿0)⊸Text "Bars:"
  "font-size=18" Ge (30+y×↕n) (Pos tx⊸⋈)⊸Text¨ ∾⟜"–"⊸∾¨˝˘FmtNum∘‿2⥊1+↕8
  ↕∘≠⊸(C¨) ⥊2‿3⋈¨⎉1 0‿3+⌜4‿0
⟩
}
-->

The skeleton above shows that a fairly small number of notes are changed at each step, not counting the octave shifts (but it's not a complete analysis: there's an important and mysterious F in the first two bars, along with other notes brought in from the major seventh chords to follow). At the bottom I've bracketed an octatonic scale that covers most notes. We can also build this whole collection in BQN from a pile of outer products, here as offsets from the bass E flat:

        ⟨0‿15+⌜¯8‿0, 0‿15+⌜¯4‿0+⌜0‿7⟩  # First half

        ⥊ 0‿3 +⌜ ⟨0‿15+⌜¯8‿0, 0‿15+⌜¯4‿0+⌜0‿7⟩

The shared `0‿15` can be extracted with [another trick](https://mlochbaum.github.io/BQN/doc/enclose.html#broadcasting): `⟨a F b, a F c⟩` is the same as `(<a) F¨ ⟨b,c⟩` or `(<a) F⌜ ⟨b,c⟩`. Naturally I'll choose the second of these. Let's also take the result modulo 3 to show the octatonic properties better. Each `2` is a note that doesn't fit into the highlighted octatonic scale—just the root of each major seventh chord.

        3| ⥊ 0‿3 +⌜ (<0‿15) +⌜⌜ ⟨¯8‿0, ¯4‿0+⌜0‿7⟩

Moving on, bars 9 to 12 are transitional; they introduce some new ideas and don't really stick to the outer product theme. Probably because he is writing music and not some weird array programming math blog. The next section will suit us better, and what catches the eye first is an intimidating, oscillating left-hand line, delivered in 5:3 tuplets.

<!--GEN
⟨1‿49 Score "13 and 14"‿", left hand", Figure Piano 3⟩
-->

A younger Scriabin readily jumped into complex ad-hoc patterns, but in his most ostentatious madness he rarely went without a method. This part is in fact a short sequence moving up in tritones, obscured by regrouping them from five 3-note chords to three 5-note tuplets. No matter, [reshape](https://mlochbaum.github.io/BQN/doc/reshape.html) will do this for us, and we can throw in a quick and dirty [synthesis](../synth/README.md) as well.

        6 × 3 -˜ ↕5    # The low notes, still offset from E♭ = D♯

        ⊢ notes ← (⌽≢)⊸⥊ (6×3-˜↕5) +⌜ 0‿6‿13

        Synth ← { (3.4⋆-↕⊸÷≠𝕩) × -⟜(⋆⟜7) -⟜¬ 1|+`𝕩÷44100 }
        Play ⥊ (Synth 7560⊸/)˘ 55 × 2⋆12÷˜ 18+notes  # Low A = 55Hz

        3 | notes  # All octatonic, no 2s

Leaving out the reshape `(⌽≢)⊸⥊`, we get two columns that cover the same notes and a third that's different. Paring down to a 2 by 2 outer product gives the unique octave-equivalent notes only.

        (6×3-˜↕5) +⌜ 0‿6‿13

        0‿6 +⌜ 0‿7

<!--GEN
28 KSVG {
  h ← 46
  ⟨
    (0⋈28+h) KeyNotes 18⥊3⌽afc
    0‿(h‿0)‿0‿4‿"bluegreen" Cube 6‿7
  ⟩
}
-->

But what about the right hand? It's playing a chord on D flat and G flat above (written C sharp and F sharp, as the spellings now indicate an octatonic scale going from C sharp to C natural; the interested reader is referred to George Perle, "Scriabin's Self-Analyses"). These fit neatly into our reduced outer product, because it also features a 7-step interval on one side. When we reduce the octaves out, we find that the other side is a sequence of 3-step intervals!

        0‿6‿27 +⌜ 0‿7

        0‿3‿6 +⌜ 0‿7   # Squash together

This is child's play for someone well-versed in octatonic decomposition like you or I. The octatonic scale is two diminished sevenths `(3×↕4) +⌜ 0‿7` and all we have to do is truncate them to triads `3×↕3`. Because only four 7-step intervals are possible within the octatonic scale, any three of them must form the same structure, if you rotate them around right.

<!--GEN
dash4 ← "stroke-dasharray"‿"7 11" ≍˜ "class"⋈4⊑intCol
28 KSVG {
  y ← 0‿¯1 ⊏ yp ← 28×↕3
  pts ← yp ⋈˜¨ PX⌽4+⌜´3‿2↕⊸×¨i←3‿7
  la ← "class"⊸⋈¨ i⊏intCol
  ⟨
    (0‿28+y) KeyNotes 18⥊3⌽afc
    "stroke-width=3" Ge (la∾<dash4) Lines¨ ⟨2↕pts, ⍉pts, 1↓˘»⊸≍˝⍉pts⟩
    "stroke-width=1.75|class=purple" Ge pc ← Circ´¨ ⥊pts
    "stroke-width=1.75|class=red|opacity=0.75|style=fill:none" Ge 0‿1‿4 ⊏ pc
  ⟩
}
-->

Right after, in bar 15, Scriabin moves the B flat to the right hand, forming a perfectly normal major triad, which is again given an abnormal sound by the remaining notes in the left hand. It's the same 0-6-13 shape again, which is obscure but has some recognition as a voicing of the [Viennese trichord](https://en.wikipedia.org/wiki/Viennese_trichord) (I quite like this sound, and was experimenting with tritone-fifth and tritone-fourth combinations on the guitar long before I knew who Scriabin was). To separate things out, the right-hand major chord is moved up an octave, but an extra D flat is left in place so the thumbs cross.

It's interesting to compare this set of notes to the ones from the opening section. For example, we can get them from the last set of two major seventh chords, by moving the lower note of each 4-step interval up to shrink it to 3 steps.

<!--GEN
{
h ← 6 -˜ 2 × y ← 38 +´ dy ← 40‿16‿0
tx ← PX ¯2
¯100‿¯28‿512‿(50+h) SVG "fill=currentColor|text-anchor=middle" Ge ⟨
  (0⋈h) KeyNotes 18⥊3⌽afc, OctBrak h+3
  ("font-size"‿"14" ∾ Pos tx‿0)⊸Text "Bars:"
  "font-size=18" Ge (30+y×↕2) (Pos tx⊸⋈)⊸Text¨ "7–8"‿"13–16"
  ⟨0,             dy,0,3,"purple"⟩ Cube 3‿4‿7
  ⟨y,(3÷4)⊸×⌾(1⊸⊑)dy,0,4,"purple"⟩ Cube 3‿3‿7
⟩
}
-->

The second iteration of this pattern in bars 17 to 20 starts by repeating from the previous four bars, transposed up 3 steps—the same idea as the opening, but a more noticeable jump without another chord to prepare it. When we reach the chords with both hands together, they're unexpectedly pushed up another 3 steps. But still we can summarize this as an outer product, if we accept that the four 2-bar groups can't be broken down into a two-by-two shape.

        ⊢ chords ← 0‿0‿3‿6 +⌜ ⥊ 0‿7 +⌜ 0‿3‿6  # Bars 13 to 20

        Arp ← { +⟜((3e3⥊0)⊸»)˝ -⟜(⋆⟜3) -⟜¬ 1| 𝕩 ×⌜ ↕⊸÷44100 }
        Play 8÷˜⥊ Arp˘ 440 × 2⋆12÷˜ chords

Those final chords might well be considered part of the next section, where they're interspersed with some fresh material.

<!--GEN
⟨2‿49 Score "25 and 26"‿", left hand", Figure Piano 4⟩
-->

In the left hand we encounter another table-friendly chord that's also used heavily in the second piece in the set, and late Scriabin in general. The [French sixth](https://en.wikipedia.org/wiki/Augmented_sixth_chord#French_sixth) is commonly presented as `0‿6+⌜0‿4`, but Scriabin prefers the wider `0‿10+⌜0‿6`, and the lowest notes of bars 25 and 26 proceed 16-10-0 missing only the 6. Because the second instance is transposed down by 6 steps, the two bars together fill out the chord.

        0‿10 +⌜ 0‿6

        6‿0 +⌜ 16‿10‿0  # and 22 = 10+12

The shared tones 10 and 16 (C sharp and G) allow him to splice both arpeggios into a starting bit that's repeated without transposing, beginning with a curious B natural. Meanwhile, the right hand plays a B flat minor chord, then moves its root down for the G sharp of C sharp major. If combined, these form B flat minor seventh, which splits up much like the major seventh, into `0‿7+⌜0‿3`. This time it's arranged to play the two 7-step intervals as individual chords! And the 3-step interval makes it a fragment of an octatonic scale… except it's not the same one we've been using up to now. Really these notes don't look related to much of anything, not even the left-hand part as it only shares the note C sharp.

<!--GEN
{
h ← (31 +´ d1←36‿12) + y ← 38 +´ d0←28‿0
wt ← "class=green|style=fill:none|stroke-width=2.5"
le ← "font-size=18|text-anchor=start"
¯100‿¯28‿512‿(50+h) SVG "fill=currentColor|text-anchor=middle" Ge ⟨
  (0⋈h) (PX -⟜3) _xKeyNotes 15⥊afc, (¯1+↕5) OctBrak h+3
  wt Ge "path" Elt "ML"˘⊸(Pd○⥊) (PX (2×1-˜↕7)+⌜-⊸⋈0.37) ⋈¨ h+8
  le Ge (16‿29+y×↕2) (Pos (PX 12.2)⊸⋈)⊸Text¨ ∾⟜" hand"¨"Right"‿"Left"
  "stroke-width=3" Ge dash4 Lines (PX 2‿6)⋈¨⌽d0
  "stroke-width=1.75|class=yellow" Ge 0 PX⊸Circ y+8
  0‿d0‿0‿¯1‿"purple"    Cube 3‿7
  y‿d1‿0‿¯2‿"bluegreen" Cube 6‿4
⟩
}
-->

We check below that one note is the smallest possible overlap between a French sixth and minor seventh, by [counting](https://mlochbaum.github.io/BQN/doc/replicate.html#inverse) the entries of a _difference_ table modulo 12 (it's not obvious this works, think about it as long as you like!). We also find that two notes is the largest overlap, and we'd get it if the chords fit the same octatonic scale. But it seems more important that the right hand's C sharp and F—the two notes appearing in both bars—fit into and complete the [whole tone scale](tertian.md#what-are-they-really) all the left-hand notes belong to.

        # Intersection size of two chords at each offset ↕12
        /⁼⥊ 12| (0‿7+⌜0‿3) -⌜ 0‿10+⌜0‿6

        /⁼⥊ 3| 0‿7 -⌜ 0‿10  # Closely related!

The section trails off and suddenly congratulations are in order for reaching the midpoint of the composition! I hope you can persevere as we work through the remainder. What happens is the sequence repeats, transposed down by 6 semitones and with minor artistic changes, and finishes with a 4-bar coda that warps the theme to connect it the mystic chord (with D flat pushed up two octaves) and whole-tone scale. Outer product!

        0‿¯6 +⌜ 0‿3
