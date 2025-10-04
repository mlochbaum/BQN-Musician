# Tertian-complement scales

Behind the [tertian scales](tertian.md) there is a shadow world in total opposition. Take a scale from each class and assemble the notes it excludes… behold!

<!--GEN ring.bqn
{
sevens ← {i‿n:⟨12↑/⁼0∾+`i-'0',n⟩}¨ ⟨
  "2212221"‿"-major"
  "2122221"‿"-melodic minor"
  "2122131"‿"harmonic minor"
  "2212131"‿"harmonic major"
⟩
other ← (4‿4‿3{⥊(𝕨×↕12÷𝕨)+⌜0‿𝕩}¨2‿3‿1) (12↑/⁼∘⊣)⊸⋈¨ ⟨
  "whole tone"
  "-augmented"
  "-octatonic"
⟩
pre ← "<tspan class=""red"">Un</tspan>"
pos ← ∾(-⊸⋈0.6)⋈˜¨¨(2‿1/-⊸⋈0.12)⊸+⌾(1⊸⊑)0.9×(↕+¬÷2˙)¨4‿3
pos ring.DrawTertianCompRow pre⊸∾⌾(1⊸⊑)¨ sevens∾other
}
-->

What you have to understand about this world is that any rules you were used to are preserved with minor changes. For one thing, the whole tone and augmented scales are literally the same. The others are all subsets of tertian scales: the diminished seventh from the octatonic scale is half a transposed octatonic scale, and any one of the seven-note complements can be turned back into some tertian scale by adding two correctly-chosen notes.

The degree of similarity may come as a surprise, but there's a reason for it: the criterion for a tertian scale enforces regular spacing between the notes, but from another perspective this is regular spacing of the gaps between notes! The relationship lets us extend our understanding of tertian scales to deal with a nice class of five-note scales including the pentatonic scale. And while jumping right from a scale to its complement in a piece would be a shock, the subset connections from _transpositions_ of complementary scales to various tertian scales make them easy to work in smoothly instead.

## Interval rules

Remember that we defined a [tertian scale](tertian.md) by requiring that the length of each scale third (combination of two adjacent intervals in the scale) is 3 or 4 semitone steps: at least 3, no more than 4. As we'll see, these two bounds are equivalent to two rules on the scale's complement:
- The length of each complement scale interval is 3 steps or less, and
- The length of each complement scale third is 4 steps or more.

To prove this, we translate our rules into statements about portions of the chromatic scale. We define a k-step "window" as k adjacent possible notes (so, positions `12|i+↕k` for some whole number `i`). In these terms, the rule that two adjacent scale intervals add up to at least 3 steps is saying that 3 notes can't fit in a 3-step window, or, each such window has 2 notes or fewer. And the rule that they have to add up to 4 steps or fewer says a 4-step window has to contain more than 1 note—otherwise, starting from the note before the window, you'd pass 4 steps before finishing 2 intervals (to go in the other direction, if we know every 4-step window has at least 2 notes, then the window immediately following any note contains its next two notes).

<!--GEN
PD ← ∾∘⥊∾¨⟜FmtNum ⋄ Path ← {𝕨⊢⊘(At˜)"path"} Elt "d"⋈⊢
Arrh ← 22‿12 { "m l l " PD (-∘⊏∾⥊) (𝕩≍-⌾⊑⌽𝕩) +˝∘×⎉1‿∞˜ 𝕗≍-⌾⊑𝕗 }
Circle ← "circle" Elt "r"‿"cx"‿"cy"≍˘FmtNum
{
set ← ["1010110","1010001"]-'0'
d ← 32 ⋄ h ← -⊸⋈20 ⋄ w ← d×≠⊏set
p ← d × si ← ↕∘≠˘ set
Ts ← Pos⊸Text¨
Tr ← {
  l‿t←∾⟜⟨""⟩¨⟨("<tspan class="""∾∾⟜""">")¨"bluegreen"‿"red",⋈˜"</tspan>"⟩
  ∾⥊⍉"24"⊸⊐⊸(⊏⟜l∾⊢≍⊏⟜t)𝕩
}
(⥊¯60‿500≍˘7+⌾⊑¯1‿2×94) SVG "stroke-width=2|stroke=currentColor" Ge ∾⟨
  Path∘{"M h" PD ¯24‿𝕩‿(16+w)}¨ h
  "class=unset"‿"class=set" Ge¨ set ⊔○⥊ p (Circle 12∾⋈)¨ h
  "text-anchor=middle|class=set" Ge (p⋈¨h) Ts⟜FmtNum○(set/○⥊⊢) si
  "purple"‿"green" ("class="∾∾⟜"|style=fill:none")⊸Ge¨ 1(↑⋈↓) Path¨ ⟨
    ("M h" PD ⟨4×d,54,3+2×d⟩) ∾ Arrh 1‿0
    "M vhv" PD ⟨d÷2,¯32⟩∾(4×d)(-∘⊢∾∾)20
    ("M vm h" PD ⟨0,42,24,0,¯12,3+4×d⟩) ∾ Arrh 1‿0
  ⟩
  "fill=currentColor|stroke=none|font-size=17" Ge ∾⟨
    "font-size=22" Ge ((w+28)⋈¨h) Ts "Yes"‿"No!"
    ((w-22)⋈¨-⊸⋈55) Ts Tr¨ "≥ 2 notes?"‿"≤ 4 steps?"
    (⟨d÷2,0⟩⋈¨6+-⊸⋈76) Ts Tr¨ "4-window"‿"2-interval"
  ⟩
⟩
}
-->

This formulation is perfect for flipping notes and gaps. If at least 2 places in a 3-window are notes then only the remaining 1 place could be a gap. Arithmetically, a 3-window with `n` notes and `g` gaps has `3 = n+g`, so `n ≤ 2` implies `(3-n) ≥ 3-2` or `g ≥ 1`. So the two columns in this table are sequences of equivalent rules:

| Gap minimum                       | Note minimum
|-----------------------------------|--------------
| At least 3 steps for 2 intervals  | At most 4 steps for 2 intervals
| A 3-window has at most 2 notes    | A 4-window has at least 2 notes
| A 3-window has at least 1 gap     | A 4-window has at most 2 gaps
| At most 3 steps in 1 gap interval | At least 4 steps for 2 gap intervals

In general, a rule of "There are at [least|most] n steps in k intervals" is equivalent to "There are at [most|least] n steps in n-k gap intervals". We can also use this to draw finer distinctions between tertian scales. Modes of major and melodic minor, and whole-tone and octatonic scales, are a little more regular that other tertian scales because they have no 3-step intervals, or, there are at most 2 steps in an interval. So in the complement, there are at least 2 steps in an interval, meaning scales like the pentatonic and diminished seventh don't have any notes right next to each other. And the harmonic and augmented scales, which break this rule, do have such pairs of notes in their complements—right in the middle of each 3-step interval, which is pretty obvious when you put it that way.

## As subsets

It's sort of intuitive that 5-note scales that satisfy one regularity condition can be filled out to give 7-note scales with a different one, but it doesn't exactly seem guaranteed. At least, we can analyze the 6-note scales. As tertian scales, [we showed](tertian.md#what-are-they-really) that every interval pair has to have the maximum length of 4, because there are 6 that need to add up to 24 steps. The same math holds for tertian scale complements, except that 4 is the minimum instead of maximum length (and when every pair of intervals is 4 steps, the fact that a single interval is no more than 3 follows immediately). So the complement of a 6-note tertian scale is automatically 6-note tertian. For the broader picture, let's lay our scales out explicitly:

<!--GEN
rp ← 5 + ring.size
Norm ← ⊢ ÷ +´⌾(×˜)
ac ← "class=yellow|style=fill:none|stroke-width=3.4|stroke-linecap=round"
Arr ← { Path ("M l " PD (𝕨+u×rp) ∾ d-u×3+2×rp) ∾ Arrh u←Norm d←𝕩-𝕨 }
Arrl ← {
  D ← Norm 𝕨 + (-⌾⊑⌽𝕨)⊸×
  o ← ∾⟜⌽˝ (rp×1‿1.85)⊸×˘ D¨ -⊸≍0.25‿0.32
  Path ("M c     " PD (𝕩+⊑o)∾∾-⟜(⊑o)¨1↓o) ∾ Arrh -D 0.28
}
Arrc ← {
  o ← 11×𝕨×-⌾⊑⌽ u ← Norm d ← -˜´𝕩
  i ← (⊑𝕩)+1.7×o ⋄ s ← (o+÷⟜2)⊸⋈ d-u×3+2×rp
  Path ("M q   " PD ∾⟨i+u×2-˜rp⟩∾s) ∾ Arrh Norm (11×u)+-˜´s
}
spos ← ∾(-⊸⋈0.62)⋈˜¨¨(0.08×⟨2/¯1‿1,3-˜2×↕3⟩)+(↕+¬÷2˙)¨4‿3
tsvg ← spos ring.DrawTertianCompRow ⋈¨ '0' -˜ ⟨
  "101101010110", "011010101011", "101100110110", "011011001101"
  "101010101010", "110011001100", "011011011011"
⟩
spr ← spos × 2×(rp+12)
tsvg {(¯1↓𝕨)∾1↓𝕩} (4⥊0) SVG ac Ge ⟨
  <∘Arr´˘ (6≍˘2‿3)⊏spr
  (<¯0.25 Arrc ⋈+¨{0.045×(2×-⌾⊑⌽𝕩)⊸+¨0.8‿¯1.4×<𝕩}∘-){𝔽≍𝔽˜}´˘ 2‿2⥊spr
  ⟨¯2‿9,1‿3,1‿¯5,2‿¯5,2‿¯1⟩ Arrl¨ (2⊸↑∾¯3⊸↑)spr
⟩
-->

In the top row, each 7-note class's complement fits naturally into a different class, with diatonic and melodic scales swapping off as well as the two harmonic classes, which are mirror images. Equivalently, those pairs of complements have been arranged so they don't overlap. There are also self-relationships that require rotation. To see these it's better to separate each scale from its complement:

<!--GEN
{
rpos ← -⌾(1⊸⊑¨)⊸∾ ¯1.6‿¯0.66‿0.26‿0.93‿1.6⋈¨0.5+((0.2×2⊸>)+0.6×3⊸=)↕5
tr←2×(rp+12)×rpos ⋄ d←⌈´|tr ⋄ w←1+rp÷˜⊑d ⋄ a ← ¯1‿2×1⊑d
le ← rp×3.6⌈w
DrawSc ← {
  int ← 4‿5‿6
  intervalColors ← "green"‿"bluegreen"‿"purple"
  rot ← {⟨⟩: {𝔽⟜(2⊸⌽)}; ⟨d⟩: i←d+↕l←≠d ⋄ {l⊸⥊𝔽(≠|i˙)⊸⊏}} 1↓𝕩
  Ext ← { dir 𝕊 𝕩:
    t ← (≠int)↑(int⊐(≠𝕩)|-˜_rot/𝕩) ⊔ ∾¨_rot 0.93×𝕩/dir
    P ← {("class="∾𝕨) Path ("M L "⥊˜≢)⊸PD ∾𝕩}
    "opacity=0.8" Ge ⌽ intervalColors P¨ t
  }
  ("transform=translate("∾(Fmt𝕨)∾")") Ge ext ring.Draw ⊑𝕩
}
tc ← "fill=currentColor|font-size=26"
ti ← "Tertian"‿"Complementary tertian"
rc ← "text-anchor=middle|font-size=20|fill=currentColor|opacity=0.9"
dc ← "class=lilac|stroke-width=10|opacity=0.25"
(⥊(0≍˘a)+¯1‿2×⌜⟨8+le,rp⟩) SVG ∾⟨
  ⋈dc Path "M h" PD ¯1‿0‿2×le
  tc Ge ((12-le)⋈¨-⊸⋈38-⊑a) Pos⊸Text¨ ti
  tr DrawSc¨ ∾⟜(¬1↑¨⊢) '0' -˜ ⟨
    "101101010110"‿"33233330032002"
    "011010101011"‿"32223330333"
    "101100110110"‿"3023343"
    "011011011011"‿"44444444"
    "101101100110"‿"3332330"
  ⟩
  ac Ge {S←⊏˘⟜(⌽∘‿5⥊tr) ⋄ ∾⟨
    Arr´∘S¨ (⥊⋈⌜˜↕2) ∾ ⋈¨⟜⌽2+↕3
    (⋈⟜-1) Arrc⟜S¨ 3⋈¨2‿4
  ⟩}
  rc Ge (((⋈⟜-84)⊸+⌾(2‿4⊸⊏)⊑¨5↑tr)⋈¨0‿0‿1‿2‿1⊏18‿¯55‿¯80) Pos⊸Text¨ ⟨
    "-1, ±6, +1" ⋄ "-1, +1"
    "-1" ⋄ "-1, +1" ⋄ "+1"
  ⟩
⟩
}
-->

That is, the "smoother" diatonic, melodic, and octatonic scales (no 3-step intervals) can all fit their own complements, and there are also various crossovers between classes. In fact, the diatonic scales on the far left can fit their complements in three different ways: shift by one semitone in either direction, or flip around by adding six. This last way is conventionally the standard in some sense, because when we do it to the major scale we get the "major pentatonic" and on the minor the "minor pentatonic".

<!--GEN
ring.DrawRow {i‿n:⟨12↑/⁼0∾+`i-'0',n⟩}¨ ⟨
  "2212221"‿"Major"
  "22323"  ‿"Major pentatonic"
⟩
-->

## Modulation

A great thing about working with tertian complements is that the entire [tertian modulation](modulation.md) framework applies. Over there, modulation means moving a note to a position that doesn't have a note—in neutral terms, swapping a note with an adjacent non-note. So back here it modulates the complement in the opposite direction, and since we don't show edge direction we can reinterpret any diagram by slapping "un-" in front of all the scale names! But if we do this for the rooted diagram we get only rootless complements, which isn't very useful. Root-containing tertian complements belong to a different subset of the full diagram. Repeating our counting exercises, each of the 4 classes has 5 modes for a total of 20 scales, and an edge is included when the root is one of 4 shared notes, so there are `96×4÷12` or 32 edges.

<!--GEN
dirh ← ⌊0.5+(6⥊115-0‿15‿20)×(•math.Sin ≍˘ •math.Cos) (2×π) × 6↑↕⊸÷12
dir ← ∾⟜-dirh
off ← ∾"M "∾¨FmtNum p0←-2÷˜+˝dirh
co ← "ABabCABabBcACbc" ⋄ co -↩ "Aa" ⊏˜ ci ← co≥'a'
cs ← ¬⊸-ci
dedup ← 4↓ci≤1≠co

circ ← (4↓cs)⊸×˘dir⊏˜ dd ← 12|(↕12)+⌜4↓co
HL ← { (𝕨⊣pa) Path off∾ ∾⥊ (𝕩⊏"m "≍"l ") ∾¨⎉(=⊣) FmtNum circ }
ps ← "fill=none|stroke-linejoin=round|stroke-linecap=round|"
pa ← ps∾"stroke=currentColor|stroke-width=2.5"
ph ← ps∾"class=yellow|style=fill:none|stroke-width=4"

modep ← 5↑(¯2÷˜+˝)⊸∾6↑8⌽dir
Lab ← {p𝕊a‿t:t Enc˜ Text "text-anchor"‿a ∾ Pos p×1.06+0.04×"middle"≡a}
(⥊(0≍˘0‿¯132)+¯1‿2×⌜320‿220) SVG ⟨
  "opacity=0.08" Ge HL dedup
  HL dedup⊸×˘ (¯1⊸⌽⊸∧·¬+`)⌾⥊ (4↓cs)⊸×˘dd⊏-˝0‿7=⌜↕12
  ph Path ("M "»"l "˘)⊸PD modep
  "fill=currentColor|font-size=14" Ge (<˘0.995×1‿4⊏+`modep) Lab¨ ⟨
    "middle"‿"Minor pentatonic"
    "end"   ‿"Major pent."
  ⟩
⟩
-->

The five pentatonic modes give us room for two full cubes. A cube still comes from a set of three independent notes we can modulate, but remember, the transpositions are backwards: to go from major to minor pentatonic you *raise* three notes.

<!--GEN
majmin ← ∧˘12|0‿3+⌜7×↕5
ScPos ← (60 -˜ 20×⊢) ⋈¨ -⊸⋈∘⊣
tpos ← 36 ScPos majmin
Modul ← { 𝕨 Path⟜{∾⥊>𝕩}¨ (≠˝𝕩) ⊔ ⍉"M "‿"L "∾¨¨FmtNum¨ 20 ScPos 𝕩 }
Te ← Pos⊸Text
(⥊¯1‿2×⌜304‿60) SVG "fill=currentColor" Ge ⟨
  "font-size=19|text-anchor=middle"Ge⥊tpos Te¨ FmtNum majmin
  "font-size=16|text-anchor=end"   Ge⥊(⊏˘tpos) -⟜40‿0⊸Te¨ ∾⟜" pent."¨ "Major"‿"Minor"
  pa‿ph Modul majmin
⟩
-->

Taking complements has roughly turned our tertian diagram upside-down, so the obvious thing to try is to spin it 180 degrees to lay it on top of the original. This corresponds to transposing all the scales 6 steps, which lines up each pentatonic mode with its standard diatonic parent. But none of the other subset relationships match up: they have rotations of -1 or +1, not ±6. Sounds like a long way off, except that the modulation diagram is laid out in fifths (7 steps)! This works out nicely for melodic modes, as the ones that contain a given complement are a one-twelfth rotation away in either direction. Because they swap between classes, harmonic modes aren't so simple.

<!--GEN
moded ← (¯2÷˜+˝)⊸∾6↑1↓dir
pp ← ps∾"class=purple|style=fill:none|stroke-width=3|opacity=0.25"
pt ← ps∾"stroke=currentColor|stroke-width=1.5"
pm ← ps∾"class=bluegreen|style=fill:none|stroke-width=4"
pr ← ps∾"class=red|style=fill:none|stroke-width=4"
(⥊(0≍˘⋈⟜-108)+¯1‿2×⌜320‿232) SVG ⟨
  pp HL dedup⊸×˘ (¯1⊸⌽⊸∧+`)⌾⥊ (4↓cs)⊸×˘dd⊏-˝0‿7=⌜↕12
  ph Ge Path¨ ⟨
    ("M "»"l "˘)⊸PD moded
    "M l "˘⊸PD (+`moded) ∾˘ 1(↓--⊸↓)8↑dir
  ⟩
  # (5⊸-⋈2⊸+)0‿1‿3‿4‿7  # (3⌽dir)+¯3⌽dir cancels
  pr Path "M l "˘⊸PD (1+(↕6)∾8‿9) ⊏ ((+`moded⊏⊸∾1↓dir)+3⌽dir) ∾˘ -dir
  "class=yellow|stroke-width=3" Ge (Circle 5⊸∾)¨ <˘+`-modep
  pm Path ("M "»"l "˘)⊸PD -⟜(9↑¯1⌽dir)⌾(+`) moded⊏⊸∾8↑1↓dir
  pt HL dedup⊸×˘ (¯1⊸⌽⊸∧+`)⌾⥊ (4↓cs)⊸×˘dd⊏-˝1‿6=⌜↕12
  "fill=currentColor|font-size=14" Ge (<˘+`moded) Lab¨ <˘⍉[
    2‿2‿3/⌽"start"‿"middle"‿"end"
    "Locrian"‿"Phrygian"‿"Aeolian (minor)"‿"Dorian"‿"Mixolydian"‿"Ionian (major)"‿"Lydian"
  ]
⟩
-->

Apparently Emperor Palpatine's dream catcher is nearing completion, but there are a few properties of the subset relation that can be identified with some effort. First, the subset edges are undirected. This is because, if A is a subset of B, then transposing both by 6 steps doesn't change this, and taking complements reverses the direction, so the complement at B's location is a subset of a scale at A. Second, transposing both scales without complementing, thus moving around the diagram by rotation, also maintains the subset relationships. The reason the diagram isn't 12-way symmetric, other than the edge length distortion, is that I've only drawn an edge if it relates two root-containing scales, that is, in one direction or the other both sides are in the diagram. Hopefully that's enough to see that all the edges come from just five classes: diatonic to the same location, diatonic to neighboring diatonic, diatonic to melodic, melodic to neighboring melodic, and harmonic to mirror harmonic. A tertian complement always has every one of these its class can, because if it contains the root then so does any superset of it.

So can does all this crazy scale theory lead to wild scale transformations? Here's one try, in just two steps we accomplish the work of two one-note modulations!

<!--GEN
ring.DrawThirdsRow -⟜'0'⌾⊑¨ ⟨
  "101101011010"‿"Minor"
  "100101010010"‿"Pentatonic minor"
  "110101010110"‿"Dorian ♭2"
⟩
-->

Following the links around the diagram is a good way to convince yourself that most of them go nowhere fast. Musically this is good: we *want* rich but restricted transformations to make interesting sounds. You're always free to hit random keys or suddenly switch scales, but if that's all you do it starts to sound the same pretty quick!

The way the diagram wraps around at the top does look intriguing. There aren't a lot of ways to get to it so it's a very specific trick (and mirror image).

<!--GEN
ring.DrawThirdsRow -⟜'0'⌾⊑¨ ⟨
  "101101011001"‿"Harmonic minor"
 ⋈"100101001001"
 ⋈"100100101001"
  "100110101101"‿"Lydian ♯2 ♯5?"
⟩
-->

If you've properly acclimated to the first two scales, that little 5 to 6 change comes as a paradigm shift, real high-concept stuff. However, the altered Lydian scale is ([as discussed](modulation.md#the-weirdest-scales)) quite a weird one and hard to play with. It strongly suggests a minor scale starting at note 1 instead of 0, so by changing the root, this could be used as a way to modulate up a semitone instead.

The harmonic inclusions are also practical for quickly jumping across the lower part of the diagram, although it takes some work to get from the diatonic scales on the outside to that inner circle. Here's an example going from Lydian, the brightest mode, to a darker-than-Phrygian scale, four steps equivalent to six one-note shifts.

<!--GEN
ring.DrawThirdsRow -⟜'0'⌾⊑¨ ⟨
  "101010110101"‿"Lydian"
  "101010010100"‿"Major pent."
  "101010010010"‿"Unmelodic"
  "100110010010"‿"Un-harmonic-minor"
  "110110011010"‿"Phrygian ♭4"
⟩
-->

You may notice that all these scales contain the major triad 0, 4, 7. Much of this pentatonic subset stuff is a weaker form of common-chord modulation, which we could use to leap across this entire progression with that one chord. But there's also a lot of value in knowing possible intermediate steps! For example, you might try to smooth things out with a major pentatonic melody before the chommon-chord modulation, or avoid note 8 for a little while after.
