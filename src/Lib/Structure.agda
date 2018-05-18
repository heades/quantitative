open import Lib.Setoid

module Lib.Structure {c l} (S : Setoid c l) where

  open import Lib.Dec
  open import Lib.Equality hiding (refl)
  open import Lib.FunctionProperties S
  open import Lib.Level
  open import Lib.Product

  open Setoid S

  --------------------------------------------------------------------------------
  -- Relation properties

  Refl : ∀ {l′} → Rel l′ → Set _
  Refl _~_ = ∀ {x} → x ~ x

  Sym : ∀ {l′} → Rel l′ → Set _
  Sym _~_ = ∀ {x y} → x ~ y → y ~ x

  Trans : ∀ {l′} → Rel l′ → Set _
  Trans _~_ = ∀ {x y z} → x ~ y → y ~ z → x ~ z

  Reflexive : ∀ {l′} → Rel l′ → Set _
  Reflexive _≤_ = ∀ {x y} → x ≈ y → x ≤ y

  Antisym : ∀ {l′} → Rel l′ → Set _
  Antisym _≤_ = ∀ {x y} → x ≤ y → y ≤ x → x ≈ y

  --------------------------------------------------------------------------------
  -- Order

  record IsPreorder {l′} (≤ : Rel l′) : Set (c ⊔ l ⊔ l′) where
    field
      ≤-reflexive : Reflexive ≤
      ≤-trans : Trans ≤
    ≤-refl : Refl ≤
    ≤-refl = ≤-reflexive refl

  record Preorder l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infixr 4 _≤_
    field
      _≤_ : Rel l′
      isPreorder : IsPreorder _≤_
    open IsPreorder isPreorder public

  record IsPoset {l′} (≤ : Rel l′) : Set (c ⊔ l ⊔ l′) where
    field
      antisym : Antisym ≤
      isPreorder : IsPreorder ≤
    open IsPreorder isPreorder public

  record Poset l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infixr 4 _≤_
    field
      _≤_ : Rel l′
      isPoset : IsPoset _≤_
    open IsPoset isPoset public

    preorder : Preorder l′
    preorder = record { isPreorder = isPreorder }

  record IsMeetSemilattice {l′} (_≤_ : Rel l′) (_∧_ : Op2)
                           : Set (c ⊔ l ⊔ l′) where
    field
      lowerBound : (∀ a b → _∧_ a b ≤ a) × (∀ a b → _∧_ a b ≤ b)
      greatest : ∀ {a b m} → m ≤ a → m ≤ b → m ≤ _∧_ a b
      isPoset : IsPoset _≤_
    open IsPoset isPoset public

  record MeetSemilattice l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infixr 4 _≤_
    field
      _≤_ : Rel l′
      _∧_ : Op2
      isMeetSemilattice : IsMeetSemilattice _≤_ _∧_
    open IsMeetSemilattice isMeetSemilattice public

    poset : Poset l′
    poset = record { isPoset = isPoset }
    open Poset poset public
      using (preorder)

  {-
  record IsLattice {l′} (_≤_ : Rel l′) (_∧_ join : Op2)
                   : Set (c ⊔ l ⊔ l′) where
    field
      lowerBound : (∀ a b → _∧_ a b ≤ a) × (∀ a b → _∧_ a b ≤ b)
      upperBound : (∀ a b → a ≤ join a b) × (∀ a b → b ≤ join a b)
      greatest : ∀ {a b m} → m ≤ a → m ≤ b → m ≤ _∧_ a b
      least : ∀ {a b m} → a ≤ m → b ≤ m → join a b ≤ m
      isPoset : IsPoset _≤_
    open IsPoset isPoset public

  record Lattice l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infixr 4 _≤_
    field
      _≤_ : Rel l′
      _∧_ join : Op2
      isLattice : IsLattice _≤_ _∧_ join
    open IsLattice isLattice public

    meetSemilattice : MeetSemilattice l′
    meetSemilattice =
      record { isMeetSemilattice = record { lowerBound = lowerBound
                                          ; greatest = greatest
                                          ; isPoset = isPoset
                                          } }
    open MeetSemilattice meetSemilattice public
      using (isMeetSemilattice; poset; preorder)
  -}

  -- Structure

  record IsMonoid (e : C) (· : Op2) : Set (c ⊔ l) where
    infixr 5 _·-cong_
    field
      identity : Identity · e
      assoc : Assoc ·
      _·-cong_ : Cong2 ·

  record Monoid : Set (c ⊔ l) where
    infixr 5 _·_
    field
      e : C
      _·_ : Op2
      isMonoid : IsMonoid e _·_
    open IsMonoid isMonoid public

  record IsCommutativeMonoid (e : C) (· : Op2) : Set (c ⊔ l) where
    field
      comm : Comm ·
      isMonoid : IsMonoid e ·
    open IsMonoid isMonoid public

  record CommutativeMonoid : Set (c ⊔ l) where
    infixr 5 _·_
    field
      e : C
      _·_ : Op2
      isCommutativeMonoid : IsCommutativeMonoid e _·_
    open IsCommutativeMonoid isCommutativeMonoid public

    monoid : Monoid
    monoid = record { isMonoid = isMonoid }

  record IsSemiring (e0 e1 : C) (+ * : Op2) : Set (c ⊔ l) where
    field
      +-isCommutativeMonoid : IsCommutativeMonoid e0 +
      *-isMonoid : IsMonoid e1 *
      annihil : Annihil * e0
      distrib : Distrib * +
    open IsCommutativeMonoid +-isCommutativeMonoid public
      renaming (comm to +-comm; isMonoid to +-isMonoid;
                identity to +-identity; assoc to +-assoc; _·-cong_ to _+-cong_)
    open IsMonoid *-isMonoid public
      renaming (identity to *-identity; assoc to *-assoc; _·-cong_ to _*-cong_)

  record Semiring : Set (c ⊔ l) where
    infixr 6 _+_
    infixr 7 _*_
    field
      e0 e1 : C
      _+_ _*_ : Op2
      isSemiring : IsSemiring e0 e1 _+_ _*_
    open IsSemiring isSemiring public

    +-commutativeMonoid : CommutativeMonoid
    +-commutativeMonoid = record { isCommutativeMonoid = +-isCommutativeMonoid }
    open CommutativeMonoid +-commutativeMonoid public
      using ()
      renaming (monoid to +-monoid)

    *-monoid : Monoid
    *-monoid = record { isMonoid = *-isMonoid }

  -- Mixing order and structure

  record IsPomonoid {l′} (≤ : Rel l′) (e : C) (· : Op2) : Set (c ⊔ l ⊔ l′) where
    infixr 5 _·-mono_
    field
      _·-mono_ : Mono ≤ ·
      isPoset : IsPoset ≤
      isMonoid : IsMonoid e ·
    open IsPoset isPoset public
    open IsMonoid isMonoid public

  record Pomonoid l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infixr 4 _≤_
    infixr 5 _·_
    field
      _≤_ : Rel l′
      e : C
      _·_ : Op2
      isPomonoid : IsPomonoid _≤_ e _·_
    open IsPomonoid isPomonoid public

    poset : Poset l′
    poset = record { isPoset = isPoset }
    open Poset poset public
      using (preorder)

    monoid : Monoid
    monoid = record { isMonoid = isMonoid }

  record IsCommutativePomonoid {l′} (≤ : Rel l′) (e : C) (· : Op2)
                               : Set (c ⊔ l ⊔ l′) where
    infixr 5 _·-mono_
    field
      _·-mono_ : Mono ≤ ·
      isPoset : IsPoset ≤
      isCommutativeMonoid : IsCommutativeMonoid e ·
    open IsPoset isPoset public
    open IsCommutativeMonoid isCommutativeMonoid public

  record CommutativePomonoid l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infixr 4 _≤_
    infixr 5 _·_
    field
      _≤_ : Rel l′
      e : C
      _·_ : Op2
      isCommutativePomonoid : IsCommutativePomonoid _≤_ e _·_
    open IsCommutativePomonoid isCommutativePomonoid public

    poset : Poset l′
    poset = record { isPoset = isPoset }
    open Poset poset public
      using (preorder)

    commutativeMonoid : CommutativeMonoid
    commutativeMonoid = record { isCommutativeMonoid = isCommutativeMonoid }
    open CommutativeMonoid commutativeMonoid public
      using (monoid)

  record IsPosemiring {l′} (≤ : Rel l′) (e0 e1 : C) (+ * : Op2)
                      : Set (c ⊔ l ⊔ l′) where
    infixr 6 _+-mono_
    infixr 7 _*-mono_
    field
      _+-mono_ : Mono ≤ +
      _*-mono_ : Mono ≤ *
      isPoset : IsPoset ≤
      isSemiring : IsSemiring e0 e1 + *
    open IsPoset isPoset public
    open IsSemiring isSemiring public

  record Posemiring l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infixr 4 _≤_
    infixr 6 _+_
    infixr 7 _*_
    field
      _≤_ : Rel l′
      e0 e1 : C
      _+_ _*_ : Op2
      isPosemiring : IsPosemiring _≤_ e0 e1 _+_ _*_
    open IsPosemiring isPosemiring public

    poset : Poset l′
    poset = record { isPoset = isPoset }
    open Poset poset public
      using (preorder)

    semiring : Semiring
    semiring = record { isSemiring = isSemiring }
    open Semiring semiring public
      using (+-monoid; +-commutativeMonoid; *-monoid)

  record IsMeetSemilatticeSemiring
           {l′} (≤ : Rel l′) (e0 e1 : C) (+ * _∧_ : Op2)
           : Set (c ⊔ l ⊔ l′) where
    infixr 6 _+-mono_
    infixr 7 _*-mono_
    field
      _+-mono_ : Mono ≤ +
      _*-mono_ : Mono ≤ *
      isMeetSemilattice : IsMeetSemilattice ≤ _∧_
      isSemiring : IsSemiring e0 e1 + *
    open IsMeetSemilattice isMeetSemilattice public
    open IsSemiring isSemiring public

  record MeetSemilatticeSemiring l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infixr 4 _≤_
    infixr 6 _+_
    infixr 7 _*_
    field
      _≤_ : Rel l′
      e0 e1 : C
      _+_ _*_ _∧_ : Op2
      isMeetSemilatticeSemiring :
        IsMeetSemilatticeSemiring _≤_ e0 e1 _+_ _*_ _∧_
    open IsMeetSemilatticeSemiring isMeetSemilatticeSemiring public

    meetSemilattice : MeetSemilattice l′
    meetSemilattice = record { isMeetSemilattice = isMeetSemilattice }

    posemiring : Posemiring l′
    posemiring = record { isPosemiring = record
      { _+-mono_ = _+-mono_
      ; _*-mono_ = _*-mono_
      ; isPoset = isPoset
      ; isSemiring = isSemiring
      } }
    open Posemiring posemiring public
      using (poset; preorder; semiring; +-commutativeMonoid; +-monoid; *-monoid)

  record IsDecMeetSemilatticeSemiring
           {l′} (≤ : Rel l′) (e0 e1 : C) (+ * _∧_ : Op2)
           : Set (c ⊔ l ⊔ l′) where
    field
      _≤?_ : ∀ x y → Dec (≤ x y)
      isMeetSemilatticeSemiring : IsMeetSemilatticeSemiring ≤ e0 e1 + * _∧_
    open IsMeetSemilatticeSemiring isMeetSemilatticeSemiring public

  record DecMeetSemilatticeSemiring l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infixr 4 _≤_
    infixr 6 _+_
    infixr 7 _*_
    field
      _≤_ : Rel l′
      e0 e1 : C
      _+_ _*_ _∧_ : Op2
      isDecMeetSemilatticeSemiring :
        IsDecMeetSemilatticeSemiring _≤_ e0 e1 _+_ _*_ _∧_
    open IsDecMeetSemilatticeSemiring isDecMeetSemilatticeSemiring public

    meetSemilatticeSemiring : MeetSemilatticeSemiring l′
    meetSemilatticeSemiring =
      record { isMeetSemilatticeSemiring = isMeetSemilatticeSemiring }
    open MeetSemilatticeSemiring meetSemilatticeSemiring public
      using (posemiring; poset; preorder;
             semiring; +-commutativeMonoid; +-monoid; *-monoid)
