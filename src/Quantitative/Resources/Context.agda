open import Lib.Setoid
open import Lib.Structure

module Quantitative.Resources.Context
  {c l'} (C : Set c) (POS : Posemiring (≡-Setoid C) l') where

  open import Quantitative.Syntax C POS

  open import Lib.Equality
  open import Lib.Module
  open import Lib.Nat
  open import Lib.Product
  open import Lib.Thinning as Θ hiding (_≤_; ≤-refl)
  open import Lib.Vec
  open import Lib.VZip

  -- Resource contexts

  RCtx : Nat → Set c
  RCtx = Vec {c} C

  infix 4 _≈_ _≤_

  -- Equality of contexts

  _≈_ : ∀ {n} (Δ' Δ : RCtx n) → Set _
  _≈_ = VZip _≡_

  ≈-refl : ∀ {n} (Δ : RCtx n) → Δ ≈ Δ
  ≈-refl nil = nil
  ≈-refl (p :: Δ) = refl :: ≈-refl Δ

  ≈-sym : ∀ {n} {Δ' Δ : RCtx n} → Δ' ≈ Δ → Δ ≈ Δ'
  ≈-sym nil = nil
  ≈-sym (r :: rs) = sym r :: ≈-sym rs

  ≈-trans : ∀ {n} {Δ Δ' Δ'' : RCtx n} → Δ ≈ Δ' → Δ' ≈ Δ'' → Δ ≈ Δ''
  ≈-trans nil nil = nil
  ≈-trans (xy :: xys) (yz :: yzs) = trans xy yz :: ≈-trans xys yzs

  -- Reasoning syntax for _≈_
  infixr 1 _≈[_]Δ_
  infixr 2 _≈-QED

  _≈[_]Δ_ : ∀ {n} Δ {Δ' Δ'' : RCtx n} → Δ ≈ Δ' → Δ' ≈ Δ'' → Δ ≈ Δ''
  Δ ≈[ xy ]Δ yz = ≈-trans xy yz

  _≈-QED : ∀ {n} (Δ : RCtx n) → Δ ≈ Δ
  Δ ≈-QED = ≈-refl Δ

  -- Pointwise order on contexts

  _≤_ : ∀ {n} (Δ' Δ : RCtx n) → Set _
  _≤_ = VZip R._≤_

  ≤-refl : ∀ {n} (Δ : RCtx n) → Δ ≤ Δ
  ≤-refl nil = nil
  ≤-refl (p :: Δ) = R.≤-refl :: ≤-refl Δ

  ≤-reflexive : ∀ {n} {Δ0 Δ1 : RCtx n} → Δ0 ≈ Δ1 → Δ0 ≤ Δ1
  ≤-reflexive nil = nil
  ≤-reflexive (eq :: eqs) = R.≤-reflexive eq :: ≤-reflexive eqs

  ≤-trans : ∀ {n} {Δ0 Δ1 Δ2 : RCtx n} → Δ0 ≤ Δ1 → Δ1 ≤ Δ2 → Δ0 ≤ Δ2
  ≤-trans nil nil = nil
  ≤-trans (le01 :: sub01) (le12 :: sub12) = R.≤-trans le01 le12 :: ≤-trans sub01 sub12

  -- Reasoning syntax for _≤_
  infixr 1 _≤[_]Δ_
  infixr 2 _≤-QED

  _≤[_]Δ_ : ∀ {n} Δ {Δ' Δ'' : RCtx n} → Δ ≤ Δ' → Δ' ≤ Δ'' → Δ ≤ Δ''
  Δ ≤[ xy ]Δ yz = ≤-trans xy yz

  _≤-QED : ∀ {n} (Δ : RCtx n) → Δ ≤ Δ
  Δ ≤-QED = ≤-refl Δ

  -- Operations for building contexts

  setoid : Nat → Setoid _ _
  setoid n = record
    { C = RCtx n
    ; setoidOver = record
      { _≈_ = _≈_
      ; isSetoid = record
        { refl = ≈-refl _
        ; sym = ≈-sym
        ; trans = ≈-trans
        }
      }
    }

  infixl 6 _+Δ_ _+Δ-mono_ _+Δ-cong_
  infixl 7 _*Δ_ _*Δ-mono_ _*Δ-cong_

  0Δ 1Δ : ∀ {n} → RCtx n
  0Δ = replicateVec _ R.e0
  1Δ = replicateVec _ R.e1

  varRCtx : ∀ {n} → 1 Θ.≤ n → C → RCtx n
  varRCtx (os th) rho = rho :: 0Δ
  varRCtx (o' th) rho = R.e0 :: varRCtx th rho

  _+Δ_ : ∀ {n} (Δ0 Δ1 : RCtx n) → RCtx n
  _+Δ_ = vzip R._+_

  _*Δ_ : ∀ {n} → C → RCtx n → RCtx n
  _*Δ_ rho = vmap (rho R.*_)

  -- Properties about those operations

  _+Δ-cong_ : ∀ {n} {Δ0 Δ0' Δ1 Δ1' : RCtx n} →
              Δ0 ≈ Δ0' → Δ1 ≈ Δ1' → Δ0 +Δ Δ1 ≈ Δ0' +Δ Δ1'
  nil +Δ-cong nil = nil
  (eq0 :: eqs0) +Δ-cong (eq1 :: eqs1) = (eq0 R.+-cong eq1) :: eqs0 +Δ-cong eqs1

  _+Δ-mono_ : ∀ {n} {Δ0 Δ0' Δ1 Δ1' : RCtx n} →
              Δ0 ≤ Δ0' → Δ1 ≤ Δ1' → Δ0 +Δ Δ1 ≤ Δ0' +Δ Δ1'
  nil +Δ-mono nil = nil
  (le0 :: sub0) +Δ-mono (le1 :: sub1) = le0 R.+-mono le1 :: sub0 +Δ-mono sub1

  _*Δ-cong_ : ∀ {n rho rho'} {Δ Δ' : RCtx n} →
              rho ≡ rho' → Δ ≈ Δ' → rho *Δ Δ ≈ rho' *Δ Δ'
  eq *Δ-cong nil = nil
  eq *Δ-cong (eqΔ :: eqs) = (eq R.*-cong eqΔ) :: eq *Δ-cong eqs

  _*Δ-mono_ : ∀ {n rho rho'} {Δ Δ' : RCtx n} →
              rho R.≤ rho' → Δ ≤ Δ' → rho *Δ Δ ≤ rho' *Δ Δ'
  le *Δ-mono nil = nil
  le *Δ-mono (leΔ :: sub) = le R.*-mono leΔ :: le *Δ-mono sub

  +Δ-identity : (∀ {n} Δ → 0Δ {n} +Δ Δ ≈ Δ)
              × (∀ {n} Δ → Δ +Δ 0Δ {n} ≈ Δ)
  fst +Δ-identity = go
    where
    go : ∀ {n} Δ → 0Δ {n} +Δ Δ ≈ Δ
    go nil = nil
    go (p :: Δ) = fst R.+-identity p :: go Δ
  snd +Δ-identity = go
    where
    go : ∀ {n} Δ → Δ +Δ 0Δ {n} ≈ Δ
    go nil = nil
    go (p :: Δ) = snd R.+-identity p :: go Δ

  +Δ-comm : ∀ {n} (Δ Δ' : RCtx n) → Δ +Δ Δ' ≈ Δ' +Δ Δ
  +Δ-comm nil nil = nil
  +Δ-comm (p :: Δ) (p' :: Δ') = R.+-comm p p' :: +Δ-comm Δ Δ'

  +Δ-assoc : ∀ {n} (Δ Δ' Δ'' : RCtx n) →
             (Δ +Δ Δ') +Δ Δ'' ≈ Δ +Δ (Δ' +Δ Δ'')
  +Δ-assoc nil nil nil = nil
  +Δ-assoc (p :: Δ) (p' :: Δ') (p'' :: Δ'') = R.+-assoc p p' p'' :: +Δ-assoc Δ Δ' Δ''

  *Δ-identity : (∀ {n} (Δ : RCtx n) → R.e1 *Δ Δ ≈ Δ)
              × (∀ {n} rho → rho *Δ replicateVec n R.e1 ≈ replicateVec n rho)
  fst *Δ-identity nil = nil
  fst *Δ-identity (p :: Δ) = fst R.*-identity p :: fst *Δ-identity Δ

  snd *Δ-identity {zero} rho = nil
  snd *Δ-identity {succ n} rho = snd R.*-identity rho :: snd *Δ-identity {n} rho

  e0*Δ : ∀ {n} Δ → R.e0 *Δ Δ ≈ 0Δ {n}
  e0*Δ nil = nil
  e0*Δ (p :: Δ) = snd R.annihil p :: e0*Δ Δ

  *Δempty : ∀ {n} rho → rho *Δ 0Δ ≈ 0Δ {n}
  *Δempty rho =
    rho *Δ replicateVec _ R.e0     ≈[ vmap-replicateVec (rho R.*_) _ R.e0 ]Δ
    replicateVec _ (rho R.* R.e0)  ≈[ replicateVZip _ (fst R.annihil rho) ]Δ
    replicateVec _ R.e0            ≈-QED

  *Δ-distrib-+ : ∀ {n} (Δ : RCtx n) (rho rho' : C) →
                 (rho R.+ rho') *Δ Δ ≈ rho *Δ Δ +Δ rho' *Δ Δ
  *Δ-distrib-+ nil rho rho' = nil
  *Δ-distrib-+ (p :: Δ) rho rho' =
    snd R.distrib p rho rho' :: *Δ-distrib-+ Δ rho rho'

  *Δ-distrib-+Δ : ∀ {n} (rho : C) (Δ Δ' : RCtx n) →
                  rho *Δ (Δ +Δ Δ') ≈ rho *Δ Δ +Δ rho *Δ Δ'
  *Δ-distrib-+Δ rho nil nil = nil
  *Δ-distrib-+Δ rho (p :: Δ) (p' :: Δ') =
    fst R.distrib rho p p' :: *Δ-distrib-+Δ rho Δ Δ'

  posemimodule : ∀ n → Posemimodule (≡-Setoid C) (setoid n) _ _
  posemimodule n = record
    { _≤s_ = R._≤_
    ; _≤f_ = _≤_
    ; 0s = R.e0
    ; 1s = R.e1
    ; _+s_ = R._+_
    ; _*s_ = R._*_
    ; 0f = 0Δ
    ; 1f = 1Δ
    ; _+f_ = _+Δ_
    ; _*f_ = _*Δ_
    ; isPosemimodule = record
      { _+s-mono_ = R._+-mono_
      ; _*s-mono_ = R._*-mono_
      ; _+f-mono_ = _+Δ-mono_
      ; _*f-mono_ = _*Δ-mono_
      ; ≤s-isPoset = R.isPoset
      ; ≤f-isPoset = record
        { antisym = antisym
        ; isPreorder = record
          { ≤-reflexive = ≤-reflexive
          ; ≤-trans = ≤-trans
          }
        }
      ; isSemimodule = record
        { +*s-isSemiring = R.isSemiring
        ; +f-isCommutativeMonoid = record
          { comm = +Δ-comm
          ; isMonoid = record
            { identity = fst +Δ-identity , snd +Δ-identity
            ; assoc = +Δ-assoc
            ; _·-cong_ = _+Δ-cong_
            }
          }
        ; annihil = *Δempty , e0*Δ
        ; distrib = *Δ-distrib-+Δ , (λ x y z → *Δ-distrib-+ z x y)
        ; assoc = assoc
        ; identity = fst *Δ-identity
        }
      }
    }
    where
    assoc : ∀ {n} x y (zs : RCtx n) → (x R.* y) *Δ zs ≈ x *Δ (y *Δ zs)
    assoc x y nil = nil
    assoc x y (z :: zs) = R.*-assoc x y z :: assoc x y zs

    antisym : ∀ {n} → Antisym (setoid n) _≤_
    antisym nil nil = nil
    antisym (≤R :: ≤Δ) (≥R :: ≥Δ) = R.antisym ≤R ≥R :: antisym ≤Δ ≥Δ
