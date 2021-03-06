open import Lib.Setoid

module Lib.Structure {c l} (S : Setoid c l) where

  open import Lib.Dec
  --open import Lib.Equality hiding (refl)
  open import Lib.FunctionProperties S
  open import Lib.Level
  open import Lib.Product hiding (assoc)

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
    infix 4 _≤_
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
    infix 4 _≤_
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
    infix 4 _≤_
    infixr 5 _∧_
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
    infix 4 _≤_
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

  -- Two operations

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

    plus mult : S ×S S →E S
    plus = record { _$E_ = uncurry _+_ ; _$E=_ = uncurry _+-cong_ }
    mult = record { _$E_ = uncurry _*_ ; _$E=_ = uncurry _*-cong_ }

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
    infix 4 _≤_
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

    isPomonoid : IsPomonoid ≤ e ·
    isPomonoid = record
      { _·-mono_ = _·-mono_
      ; isPoset = isPoset
      ; isMonoid = isMonoid
      }

  record CommutativePomonoid l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infix 4 _≤_
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

    pomonoid : Pomonoid l′
    pomonoid = record { isPomonoid = isPomonoid }

  -- Here so that we can prove that (C, _≤_, ⊤, _∧_) is a commutative pomonoid
  -- (so that we know what a commutative pomonoid is)

  record IsToppedMeetSemilattice {l′} (_≤_ : Rel l′) (⊤ : C) (_∧_ : Op2)
                           : Set (c ⊔ l ⊔ l′) where
    field
      top : ∀ x → x ≤ ⊤
      isMeetSemilattice : IsMeetSemilattice _≤_ _∧_
    open IsMeetSemilattice isMeetSemilattice public

  record ToppedMeetSemilattice l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infix 4 _≤_
    infixr 5 _∧_
    field
      _≤_ : Rel l′
      ⊤ : C
      _∧_ : Op2
      isToppedMeetSemilattice : IsToppedMeetSemilattice _≤_ ⊤ _∧_
    open IsToppedMeetSemilattice isToppedMeetSemilattice public

    meetSemilattice : MeetSemilattice l′
    meetSemilattice = record { isMeetSemilattice = isMeetSemilattice }
    open MeetSemilattice meetSemilattice public
      using (poset; preorder)

    commutativePomonoid : CommutativePomonoid l′
    commutativePomonoid = record
      { _≤_ = _≤_
      ; e = ⊤
      ; _·_ = _∧_
      ; isCommutativePomonoid = record
        { _·-mono_ = λ xx yy → greatest (≤-trans (fst lowerBound _ _) xx)
                                        (≤-trans (snd lowerBound _ _) yy)
        ; isPoset = isPoset
        ; isCommutativeMonoid = record
          { comm = λ x y → antisym (comm-≤ x y) (comm-≤ y x)
          ; isMonoid = record
            { identity = (λ y → antisym (snd lowerBound ⊤ y)
                                        (greatest (top y) ≤-refl))
                       , (λ x → antisym (fst lowerBound x ⊤)
                                        (greatest ≤-refl (top x)))
            ; assoc = λ x y z →
              antisym (greatest (≤-trans (fst lowerBound (x ∧ y) z)
                                         (fst lowerBound x y))
                                (greatest (≤-trans (fst lowerBound (x ∧ y) z)
                                                   (snd lowerBound x y))
                                          (snd lowerBound (x ∧ y) z)))
                      (greatest (greatest (fst lowerBound x (y ∧ z))
                                          (≤-trans (snd lowerBound x (y ∧ z))
                                                   (fst lowerBound y z)))
                                (≤-trans (snd lowerBound x (y ∧ z))
                                         (snd lowerBound y z)))
            ; _·-cong_ = λ xx yy →
              antisym (cong-≤ xx yy) (cong-≤ (sym xx) (sym yy))
            }
          }
        }
      }
      where
      comm-≤ : ∀ x y → x ∧ y ≤ y ∧ x
      comm-≤ x y = greatest (snd lowerBound x y) (fst lowerBound x y)

      cong-≤ : ∀ {x x′ y y′} → x ≈ x′ → y ≈ y′ → x ∧ y ≤ x′ ∧ y′
      cong-≤ {x} {x′} {y} {y′} xx yy =
        greatest (≤-trans (fst lowerBound x y) (≤-reflexive xx))
                 (≤-trans (snd lowerBound x y) (≤-reflexive yy))
    open CommutativePomonoid commutativePomonoid public
      using (commutativeMonoid)
      renaming (_·-mono_ to _∧-mono_)
    open CommutativeMonoid commutativeMonoid public

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

    +-isCommutativePomonoid : IsCommutativePomonoid ≤ e0 +
    +-isCommutativePomonoid = record
      { _·-mono_ = _+-mono_
      ; isPoset = isPoset
      ; isCommutativeMonoid = +-isCommutativeMonoid
      }
    open IsCommutativePomonoid +-isCommutativePomonoid public using ()
      renaming (isPomonoid to +-isPomonoid)

    *-isPomonoid : IsPomonoid ≤ e1 *
    *-isPomonoid = record
      { _·-mono_ = _*-mono_
      ; isPoset = isPoset
      ; isMonoid = *-isMonoid
      }

  record Posemiring l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infix 4 _≤_
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

    +-commutativePomonoid : CommutativePomonoid l′
    +-commutativePomonoid =
      record { isCommutativePomonoid = +-isCommutativePomonoid }
    open CommutativePomonoid +-commutativePomonoid public using ()
      renaming (pomonoid to +-pomonoid)

    *-pomonoid : Pomonoid l′
    *-pomonoid = record { isPomonoid = *-isPomonoid }

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
    infix 4 _≤_
    infixr 5 _∧_
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

  record IsToppedMeetSemilatticeSemiring
           {l′} (≤ : Rel l′) (e0 e1 ⊤ : C) (+ * _∧_ : Op2)
           : Set (c ⊔ l ⊔ l′) where
    infixr 6 _+-mono_
    infixr 7 _*-mono_
    field
      _+-mono_ : Mono ≤ +
      _*-mono_ : Mono ≤ *
      isToppedMeetSemilattice : IsToppedMeetSemilattice ≤ ⊤ _∧_
      isSemiring : IsSemiring e0 e1 + *
    open IsToppedMeetSemilattice isToppedMeetSemilattice public
    open IsSemiring isSemiring public

  record ToppedMeetSemilatticeSemiring l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infix 4 _≤_
    infixr 5 _∧_
    infixr 6 _+_
    infixr 7 _*_
    field
      _≤_ : Rel l′
      e0 e1 ⊤ : C
      _+_ _*_ _∧_ : Op2
      isToppedMeetSemilatticeSemiring :
        IsToppedMeetSemilatticeSemiring _≤_ e0 e1 ⊤ _+_ _*_ _∧_
    open IsToppedMeetSemilatticeSemiring isToppedMeetSemilatticeSemiring public

    toppedMeetSemilattice : ToppedMeetSemilattice l′
    toppedMeetSemilattice = record { isToppedMeetSemilattice = isToppedMeetSemilattice }

    meetSemilatticeSemiring : MeetSemilatticeSemiring l′
    meetSemilatticeSemiring = record { isMeetSemilatticeSemiring = record
      { _+-mono_ = _+-mono_
      ; _*-mono_ = _*-mono_
      ; isMeetSemilattice = isMeetSemilattice
      ; isSemiring = isSemiring
      } }
    open MeetSemilatticeSemiring meetSemilatticeSemiring public
      using (posemiring; meetSemilattice; poset; preorder; semiring;
             +-commutativeMonoid; +-monoid; *-monoid)

  record IsDecMeetSemilatticeSemiring
           {l′} (≤ : Rel l′) (e0 e1 : C) (+ * _∧_ : Op2)
           : Set (c ⊔ l ⊔ l′) where
    field
      _≤?_ : ∀ x y → Dec (≤ x y)
      isMeetSemilatticeSemiring : IsMeetSemilatticeSemiring ≤ e0 e1 + * _∧_
    open IsMeetSemilatticeSemiring isMeetSemilatticeSemiring public

  record DecMeetSemilatticeSemiring l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infix 4 _≤_
    infixr 5 _∧_
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
      using (posemiring; meetSemilattice; poset; preorder;
             semiring; +-commutativeMonoid; +-monoid; *-monoid)

  record IsDecToppedMeetSemilatticeSemiring
           {l′} (≤ : Rel l′) (e0 e1 ⊤ : C) (+ * _∧_ : Op2)
           : Set (c ⊔ l ⊔ l′) where
    field
      _≤?_ : ∀ x y → Dec (≤ x y)
      isToppedMeetSemilatticeSemiring : IsToppedMeetSemilatticeSemiring ≤ e0 e1 ⊤ + * _∧_
    open IsToppedMeetSemilatticeSemiring isToppedMeetSemilatticeSemiring public

  record DecToppedMeetSemilatticeSemiring l′ : Set (c ⊔ l ⊔ lsuc l′) where
    infix 4 _≤_
    infixr 5 _∧_
    infixr 6 _+_
    infixr 7 _*_
    field
      _≤_ : Rel l′
      e0 e1 ⊤ : C
      _+_ _*_ _∧_ : Op2
      isDecToppedMeetSemilatticeSemiring :
        IsDecToppedMeetSemilatticeSemiring _≤_ e0 e1 ⊤ _+_ _*_ _∧_
    open IsDecToppedMeetSemilatticeSemiring isDecToppedMeetSemilatticeSemiring public

    toppedMeetSemilatticeSemiring : ToppedMeetSemilatticeSemiring l′
    toppedMeetSemilatticeSemiring =
      record { isToppedMeetSemilatticeSemiring = isToppedMeetSemilatticeSemiring }
    open ToppedMeetSemilatticeSemiring toppedMeetSemilatticeSemiring public
      using (meetSemilatticeSemiring; posemiring;
             toppedMeetSemilattice; meetSemilattice; poset; preorder;
             semiring; +-commutativeMonoid; +-monoid; *-monoid)
