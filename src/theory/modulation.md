# Tertian scale modulation

If you draw a graph connecting every [tertian scale](tertian.md) to all the others that are only off by a single note, you get this:

<!--GEN
dirh ← ⌊0.5+(6⥊130-0‿30‿40)×(•math.Sin ≍˘ •math.Cos) (2×π) × 6↑↕⊸÷12
dir ← ∾⟜-dirh
off ← ∾"M "∾¨FmtNum p0←-2÷˜+˝dirh
co ← "ABabCABabBcACbc" ⋄ co -↩ "Aa" ⊏˜ ci ← co≥'a'
cs ← ¬⊸-ci
dedup ← 4↓ci≤1≠co

circ ← (4↓cs)⊸×˘dir⊏˜ dd ← 12|(↕12)+⌜4↓co
HL ← { pa Elt "d"⋈off∾ ∾⥊ (𝕩⊏"m "≍"l ") ∾¨⎉(=⊣) FmtNum circ }
ps ← "fill=none|stroke-linejoin=round|stroke-linecap=round|stroke=currentColor|"
pa ← "path"At ps∾"stroke-width=2.5"
ph ← "path"At ps∾"class=yellow|style=fill:none|stroke-width=4"

hdim ← (0‿1‿0‿¯1×96)+⥊¯1‿2×⌜320‿224
hdim SVG figMod ← ⟨
  HL dedup⊸×˘ (¯1⊸⌽⊸∧+`)⌾⥊ (4↓cs)⊸×˘dd⊏-˝0‿7=⌜↕12
⟩
-->

More precisely, the paths show modulations from one scale to another that move one note by a semitone, without changing the root. The direction of the path indicates which note is being moved—along one direction it might mean moving the note 5 half steps above the root to 6, which would mean the other direction moves 6 back to 5.

It's not as chaotic as it looks. First, let's highlight the diatonic scales. These are the most connected class and form something of a backbone for the others. The directions have been chosen according to the circle of fifths so that these scales follow a simple path.

<!--GEN
modep ← (¯2÷˜+˝)⊸∾6↑1↓dir
modename ← ⟨"Locrian","Phrygian","Aeolian (minor)","Dorian"
            "Mixolydian","Ionian (major)","Lydian"⟩
anchor ← 2‿2‿3/"text-anchor"⊸⋈¨⌽"start"‿"middle"‿"end"
hdim SVG figLabel ← figMod ∾ ⟨
  ph Elt "d"⋈∾⥊(("M "»"l "˘)∾¨FmtNum)modep
  "fill=currentColor|font-size=14" Ge ⊑⟨
    modename Enc¨˜ anchor Text∘∾⟜Pos¨ <˘1.06×+`modep
  ⟩
⟩
-->

The entire rest of the arrangement is made up of one structure that slides along the backbone. The Greek name for this structure's shape is "kubos", or, in English, "cube". To study it, let's look at the relationship between one mode and another three apart, say, minor and major.

<!--GEN
minmaj ← ∧˘12|0‿9+⌜7×2-↕7
ScPos ← (70 -˜ 20×⊢) ⋈¨ -⊸⋈∘⊣
tpos ← 36 ScPos minmaj
Modul ← { 𝕨 {𝕨Elt"d"⋈∾⥊>𝕩}¨ (≠˝𝕩) ⊔ ⍉"M "‿"L "∾¨¨FmtNum¨ 20 ScPos 𝕩 }
Te ← Pos⊸Text
(⥊¯1‿2×⌜256‿64) SVG "fill=currentColor" Ge ⟨
  "font-size=19|text-anchor=middle"Ge⥊tpos Te¨ FmtNum minmaj
  "font-size=16|text-anchor=end"   Ge⥊(⊏˘tpos) -⟜40‿0⊸Te¨ "Minor"‿"Major"
  pa‿ph Modul minmaj
⟩
-->

Three changes are required to get from one to the other. Going along diatonic modes, we'd first change 8 to 9 to get to dorian, then 3 to 4 to get to mixolydian, and finally 10 to 11. But other orderings are possible. In baroque music particularly it's common to see a progression of minor, harmonic minor, melodic minor, which moves 10, then 8, then 3. Given that these three moves are completely independent, we can choose to use or leave out each one, giving 2³ possible combinations connected like the corners of a cube. Three is the greatest number of transitions that can be reordered like this, because next comes 5 to 6, which requires the 8 to 9 move first, or it gives a non-tertian scale with two half steps next to each other (and the same for 2 to 1 in the other direction).

<!--GEN
names ← 2‿1‿0⍉⌽⌽˘2‿2‿2⥊⟨
    "Harmonic major",   "Major"
  "Harmonic minor",   "Melodic minor"
    "Melodic major",    "Mixolydian"
  "Minor",            "Dorian"
⟩
c0 ← ¯2 ÷˜ +˝ cdir ← >⟨100‿0,50‿¯40,0‿¯80⟩
CPd ← "d"⋈·∾∘⥊("M "∾¨·FmtNum c0⊘⊣)∾("l "˘∾¨FmtNum)∘⊢
CPath ← Elt⟜CPd
npos ← (<c0)+⌜˝(-⊸⋈12‿0)⊸+⌾⊏0‿1×⌜˜<˘cdir
(⥊¯1‿2×⌜256‿96) SVG figCube ← ⟨
  ("path"At ps∾"stroke-width=1.5") CPath cs×co⊏cdir
  ph CPath cdir
  "fill=currentColor|font-size=14" Ge ⟨
    ⟨"text-anchor=end",""⟩ Ge¨ <∘⥊˘ npos Pos⊸Text¨ names
  ⟩
⟩
-->

Two corners haven't been mentioned yet. Harmonic major is an unusual scale formed from major by making the 9→8 move so that the top four notes match harmonic minor. Melodic major, a mix of minor and mixolydian, is less weird. I've heard it called the "wonder scale". It's also a mode of melodic minor. Take a look at the right and bottom faces of the cube. They both have diatonic scales at three corners, plus a fourth scale towards the center of the cube. All of these scales are the same, but translated by a fifth—up a fifth when moving from minor to dorian for example.

<!--GEN
Gpr ← (ps∾"style=fill:none|stroke-width=3|class="∾⊣)⊸Ge
faces ← (c0(⊣≍+)⊏cdir) (<"path"Elt CPd⟜(∾⟜-))˘ 2↕cdir
(⥊¯1‿2×⌜256‿96) SVG ⌽⌾(¯2⊸↑) figCube ∾ ⋈"red"‿"bluegreen" Gpr¨ faces
-->

Here's the scale graph again. Can you see the four complete cubes locrian→dorian, phrygian→mixolydian, aeolian→ionian, and dorian→lydian? After these, there are two more faces added on each side, which come from partial cubes.

<!--GEN
hdim SVG figLabel
-->

The modes of melodic minor are tightly connected to the diatonic scales, since each one (except two at the edges) connects to two of them. Modes of harmonic minor and major only connect to one diatonic mode—in fact, each connects to one scale from each other class (again, except at boundaries). The move from minor to harmonic minor or major to harmonic major is further out of order than the moves to melodic minor modes, since it skips two other moves instead of one, so in that sense these scales are "less diatonic".

[Emmett Chapman](https://en.wikipedia.org/wiki/Emmett_Chapman)'s "offset modal system" also centers on tertian scales related by one-note shifts. His "offset" modes are our modes of melodic minor and "double offset" modes are harmonic major (harmonic minor modes don't appear!). So [his description](https://www.stick.com/method/articles/parallel/) of how he works with offset modes serves as a practical exploration of connecting modes and modulation to chords and improvisation.

## Going off-root

Okay, the scale graph clearly has some symmetry, but why is it so limited? Here's the full version:

<!--GEN
(⥊¯1‿2×⌜256‿224) SVG ⟨ HL dedup ⟩
-->

This graph includes 7-note tertian scales that *don't* contain the root. Generally, these wouldn't be considered scales, although it's possible to play in them if the impression of a root note is strong enough from outside context. For example, from a lydian scale you might modulate to a sort of super-lydian by moving the root up a step, giving the impression of a scale even brighter than lydian. If you rebase the scale at the moved note as a new root, you get locrian, but it's not really the same scale: that's a mode change. To really get to locrian, you have to make 5 more modulations through various rootless scales until there's space to sharpen the top note into the root position. In total, you can get from lydian to locrian by flattening every note but the root, or by sharpening every note *including* the root, except the shared note 6.

<!--GEN
{
lydlup ← 12⊸«⌾(1⊸⊏) lydloc ← ∧˘12|0‿6+⌜7×↕7
tpos ← 36 ScPos lydloc
(⥊¯1‿2×⌜256‿64) SVG "fill=currentColor|font-size=19|text-anchor=middle" Ge ⟨
  tpos Te¨ FmtNum lydloc
  ("opacity=0.5"At⊸∾Pos 1⊑36 ScPos 12) Text FmtNum 0
  "font-size=16|text-anchor=end"   Ge⥊(⊏˘tpos) -⟜40‿0⊸Te¨ "Lydian"‿"Locrian"
  ⥊⍉>⟨ph,"path"At ps∾"class=red|style=fill:none|stroke-width=4"⟩ pa⊸⋈⊸Modul¨ lydloc‿lydlup
⟩
}
-->

The big graph has full 12-fold symmetry since it can be rotated by changing which note we consider to be the root (this display perturbs that slightly to keep certain scales from landing exactly on top of each other). So it has 12 modes of each scale class instead of the 7 we had before, and exactly twice as many transitions. This is because a transition only appears in the rooted graph if it moves between two rooted scales. So one of the six common notes between the two scales has to be the root. Which is half of the twelve total notes; by symmetry exactly half of transitions appear in the rooted graph. This incidentally makes it easy to count the number of transitions in each. The rooted graph has 12 cubes (12 transitions each), and 12 shared faces (4 transitions), so each adds 8 transitions, for a total of 96. Half that gives 48 transitions among the 28 scales in the rooted graph.

Another kind of symmetry does make it into the rooted graph: inversion. In the full graph, there are 12 inversions, one that fixes each of the 6 pairs of tritones and another set of 6 that flip around an axis halfway between two tritones. Only one of these works for the rooted graph, the inversion that fixes the root. It fixes the symmetric scales dorian and melodic major, and shuffles the others around.

<!--GEN
csym ← ps∾"class=purple|stroke-width=6|stroke-dasharray=20 16|opacity=0.8"
hdim SVG figLabel ∾ ⟨
  ("line"At csym)  Elt (⥊⍉"xy"⋈⌜"12")≍˘FmtNum-⊸∾1.2×(+˝4↑dir)+p0
⟩
-->

## The weirdest scales

Okay, surely you're dying to know what's going on with these scales, at the ends? They're modes of harmonic major and minor, but they're not reachable from any of the diatonic modes. All the other modes of, say, harmonic minor, are reachable from the corresponding mode of ordinary minor, but for these scales, the note that would be altered is the root.

<!--GEN
hdim SVG figLabel ∾ ⟨
  "class=red|stroke-width=3|opacity=0.7" Ge ⟨
    {"circle" Elt "r"‿"cx"‿"cy"≍˘FmtNum 18∾𝕩}¨⟨
      (+˝0‿4‿5⊏dir)+p0, (+˝6‿8‿9⊏dir)-p0
    ⟩
  ⟩
⟩
-->

Here they are. The post-locrian scale comes from shifting the root of mixolydian, and the post-lydian one from aeolian in the same way.

<!--GEN ring.bqn
ring.DrawTertianRow -⟜'0'⌾⊑¨ ⟨
  "110110101100"‿"Locrian ♭4 ♭7?"
  "100110101101"‿"Lydian ♯2 ♯5?"
⟩
-->

But… these scales are… not all that different from each other? Just swap note 1 for 11 to go back and forth. As described above, it takes six changes to get between lydian and locrian, and four are incorporated here. The other changes move a note to or from the root, so they interact with some rootless scale. Specifically, we'll be going through a sort of anti-dorian mode that's rotated halfway around, keeping the symmetry but leaving a gap at the root.

<!--GEN
ring.DrawTertianRow -⟜'0'⌾⊑¨ ⟨
  "010110101101"‿"Anti-Dorian"
  "110110101101"‿"Spliced octatonic"
⟩
-->

Also shown for comparison is the [loose tertian](tertian.md#loose-tertian-scales) scale we get by leaving the root in. It starts like a 1-2 octatonic scale, ends like a 2-1, and crosses over right in the middle.

These are all some pretty strange scales. I don't think they sound quite as unusual as the augmented scales, which means they're only the weirdest 7-note tertian scales, but that's not nothing. Both the perfect fourth and fifth are missing, so you know you're going to be in a weird chord situation. Two of them, even: the root is the start of *both* an augmented chord and a diminished seventh. But only one of these is actually the root chord: in the post-locrian scale the inclusion of note 1 means we start on a 3-step third and get a diminished chord, and in the post-lydian scale we get the augmented chord instead.
