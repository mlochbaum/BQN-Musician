# Symmetric scales

Some [scales](scale.md) are symmetric when transposed: that is, shifting by some number of steps smaller than 12 leaves the scale unchanged. They're known as [modes of limited transposition](https://en.wikipedia.org/wiki/Mode_of_limited_transposition) because the number of *distinct* transpositions of the scale is smaller than the number of notes it has. Unwieldy and unintuitive, so we'll call them "symmetric scales" on this site.

For the most part I don't find this collection of scales musically interesting (a few classical composers have been drawn to the way their ambiguity makes for smooth modulations). However, they're a complication when counting scales, and enumerating them is an interesting enough problem to discuss.

<!--GEN ring.bqn
ring.DrawRow {12⥊𝕩-'0'}⌾⊑¨ ⟨
  "100"   ‿"Diminished 7th"
  "1001"  ‿"Augmented scale"
  "101110"‿"Messiaen mode 6"
⟩
-->

Here are some examples: the diminished 7th chord shows 4-fold symmetry while the augmented scale shows 3-fold and that other thing has only 2-fold symmetry. When a scale has `n`-fold symmetry, that means there are `n` ways to transpose it that leave it unchanged. What about the number of distinct transpositions `t`? For example, in the augmented scale `t=4` with the transpositions shown below.

<!--GEN
ring.DrawRow ⋈¨ ¯1⊸⌽⍟(↕4) 12⥊1‿1‿0‿0
-->

Each of the `t` scales has `n`-fold symmetry for itself, giving `n×t` total transpositions. Between these, all 12 possible transpositions must be accounted for—it has to land on one of the `t` unique transpositions! So `n×t` is 12, meaning that `n` is a divisor of 12 or `0 = n|12`. All right, let's list the possible values of `n`.

        Divisors ← { / 0 = (↕𝕩) | 𝕩 }

        ⊢ p12 ← Divisors 12  # Proper divisors

        ⊢ d12 ← p12 ∾ 12     # All divisors

A scale is symmetric when `n>1` or equivalently `t<12`. One-fold symmetry is no symmetry at all.

To find the total number of symmetric scales, we could add up the number for each `t<12`, that is, `t∊p12`. Since a scale with `t` distinct repetitions repeats every `t` steps, we might expect that the number of scales is `2⋆t`. That is, we choose which notes out of the first `t` appear, and all other choices are made for us. This doesn't work though: suppose we set `t←4` and choose `1‿0‿1‿0`. We get the following scale with only 2 unique tranpositions!

<!--GEN
ring.DrawRow ⋈¨ ¯1⊸⌽⍟(↕2) 12⥊1‿0
-->

Every scale that repeats after `t` steps also repeats after `k×t` steps. The number of scales with `t=4` is really the number that repeat after 4 steps, minus the number of scales with `t=2` and `t=1`, the divisors of 4. The arithmetic gets complicated quickly but is easily expressed with recursion. No base case needed, because 1 has no divisors!

        SymCount ← {(2⋆𝕩) - +´ 𝕊¨ Divisors 𝕩}

        SymCount 4

Here's how many total scales fit into each classification. The number of scales with any degree of symmetry is the total number of scales, minus the non-symmetric ones where `t=12`.

        sym12 ← SymCount¨ d12
        d12 ≍ sym12

        (2⋆12) - SymCount 12

So there are 12 scales with 4 unique transpositions each? Not quite, just 3 of them. Our system counts a new one for each starting point, so we should divide by 4 if we want to treat transpositions as equivalent.

<!--GEN
ring.DrawRow {12⥊𝕩-'0'}⌾⊑¨ ⟨
  "1000"‿"Augmented chord"
  "1100"‿"Augmented scale"
  "1110"‿"Messiaen mode 3"
⟩
-->

After dividing we get a new breakdown of the number of scale classes, displayed below. We also tack on a cumulative sum: 17 symmetric classes and 352 total classes. The total of 352 is one higher than the one we derived in the [tertian scale](tertian.md) page because this method counts the scale with no notes.

        d12 ∾ (⊢ ≍ +`) sym12 ÷ d12

Following the method on that page, we can normalize all scales (including those that don't contain the root) and group them by the number of unique transpositions.

        Normalize ← { ⊑ ∨ ⌽⟜𝕩¨ ↕≠𝕩 }
        ≠ scales ← ⍷ Normalize¨ ⥊↕12⥊2

        p12 ≍˘ >¨ ¯1 ↓ (+˝¬∨`p12 (⌽≡⊢)⌜ scales) ⊔ scales

All except the last group are quite boring: just clusters of notes repeated at intervals! However, four of the 6-transposition, or 2-fold symmetric, scales break this pattern.

<!--GEN
ring.DrawRow {12⥊𝕩-'0'}⌾⊑¨ ⟨
  "101000"‿"French 6th chord"
  "110100"‿"Inverse Petrushka?"
  "110010"‿"Petrushka chord"
  "111010"‿"Messiaen mode 6"
⟩
-->

Out of these, the first three are all subsets of the octatonic scale (although in a twist the French 6th is *also* a subset of the whole-tone scale; it's kind of its own thing). The last one is a pretty complex beast. Also it can be traversed as a cycle of 4-step and 5-step intervals (4-4-5-5-4-4-5-5) and that's… something?

<!--GEN
ring.DrawRow {12⥊𝕩-'0'}⌾⊑¨ ⟨
  "110"‿"Octatonic scale"
⟩
-->
