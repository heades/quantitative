open import Lib.Structure
open import Lib.Structure.Sugar

module Lib.Matrix.Scaling {c l} (R : ΣSemiring c l) where

  open ΣSemiring R
  open import Lib.Structure.Semiring R

  open import Lib.Matrix.Setoid Carrier

  open import Lib.Equality as ≡ using (_≡_)
  open import Lib.Level
  open import Lib.Matrix.Addition +-σCommutativeMonoid
  open import Lib.Nat
  open import Lib.Product using (Σ; _×_; fst; snd; _,_; uncurry)
  open import Lib.Setoid
  open import Lib.Thinning

  private
    module Size (mn : Nat × Nat) where
      open import Lib.Module Carrier (MatS mn)

      scaleM : Carrier →E MatS mn →S MatS mn
      scaleM = record
        { _$E_ = λ x → postcomposeE (curryS mult $E x)
        ; _$E=_ = λ xx MM ii → (curryS mult $E= xx) (MM ii)
        }

      _**_ : C → Mat mn → Mat mn
      x ** M = scaleM $E x $E M

      Mat-semimodule : Semimodule
      Mat-semimodule = record
        { 0s = e0
        ; 1s = e1
        ; _+s_ = _+_
        ; _*s_ = _*_
        ; 0f = 0M
        ; _+f_ = _+M_
        ; _*f_ = _**_
        ; isSemimodule = record
          { +*s-isSemiring = isSemiring
          ; +f-isCommutativeMonoid = isCommutativeMonoidM
          ; _*f-cong_ = λ where
            xx MM ii → xx *-cong MM ii
          ; annihil = λ where
            .fst x ≡.refl → annihil .fst x
            .snd M ≡.refl → annihil .snd (M $E _)
          ; distrib = λ where
            .fst x M N ≡.refl → distrib .fst x (M $E _) (N $E _)
            .snd x y M ≡.refl → distrib .snd (M $E _) x y
          ; assoc = λ where
            x y M ≡.refl → *-assoc x y (M $E _)
          ; identity = λ where
            M ≡.refl → *-identity .fst (M $E _)
          }
        }
      open Semimodule Mat-semimodule public

    module Size-implicit {mn : Nat × Nat} = Size mn

  open Size public using (Mat-semimodule)
  open Size-implicit public using (scaleM; _**_)
    renaming ( isSemimodule to isSemimoduleM; _*f-cong_ to _**-cong_
             ; annihil to **-annihil; distrib to **-distrib; assoc to **-assoc
             ; identity to **-identity)