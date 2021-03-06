open import Lib.Dec
open import Lib.Equality

module Quantitative.Types.Formers.Dec
  {c} (PrimTy : Set c) (_≟P_ : (p q : PrimTy) → Dec (p ≡ q)) (C : Set c) (_≟_ : (π ρ : C) → Dec (π ≡ ρ)) where

  open import Quantitative.Types.Formers PrimTy C

  open import Lib.Product

  _≟Ty_ : (S S′ : Ty) → Dec (S ≡ S′)
  BASE p ≟Ty BASE q with p ≟P q
  ... | yes refl = yes refl
  ... | no b = no λ { refl → b refl }
  BASE _ ≟Ty ⊗1 = no λ ()
  BASE _ ≟Ty &1 = no λ ()
  BASE _ ≟Ty ⊕0 = no λ ()
  BASE _ ≟Ty (S′ ⊸ T′) = no λ ()
  BASE _ ≟Ty ! ρ′ S′ = no λ ()
  BASE _ ≟Ty (S′ ⊗ T′) = no λ ()
  BASE _ ≟Ty (S′ & T′) = no λ ()
  BASE _ ≟Ty (S′ ⊕ T′) = no λ ()
  ⊗1 ≟Ty BASE _ = no λ ()
  ⊗1 ≟Ty ⊗1 = yes refl
  ⊗1 ≟Ty &1 = no λ ()
  ⊗1 ≟Ty ⊕0 = no λ ()
  ⊗1 ≟Ty (S′ ⊸ T′) = no λ ()
  ⊗1 ≟Ty ! ρ′ S′ = no λ ()
  ⊗1 ≟Ty (S′ ⊗ T′) = no λ ()
  ⊗1 ≟Ty (S′ & T′) = no λ ()
  ⊗1 ≟Ty (S′ ⊕ T′) = no λ ()
  &1 ≟Ty BASE _ = no λ ()
  &1 ≟Ty ⊗1 = no λ ()
  &1 ≟Ty &1 = yes refl
  &1 ≟Ty ⊕0 = no λ ()
  &1 ≟Ty (S′ ⊸ T′) = no λ ()
  &1 ≟Ty ! ρ′ S′ = no λ ()
  &1 ≟Ty (S′ ⊗ T′) = no λ ()
  &1 ≟Ty (S′ & T′) = no λ ()
  &1 ≟Ty (S′ ⊕ T′) = no λ ()
  ⊕0 ≟Ty BASE _ = no λ ()
  ⊕0 ≟Ty ⊗1 = no λ ()
  ⊕0 ≟Ty &1 = no λ ()
  ⊕0 ≟Ty ⊕0 = yes refl
  ⊕0 ≟Ty (S′ ⊸ T′) = no λ ()
  ⊕0 ≟Ty ! ρ′ S′ = no λ ()
  ⊕0 ≟Ty (S′ ⊗ T′) = no λ ()
  ⊕0 ≟Ty (S′ & T′) = no λ ()
  ⊕0 ≟Ty (S′ ⊕ T′) = no λ ()
  (S ⊸ T) ≟Ty BASE _ = no λ ()
  (S ⊸ T) ≟Ty ⊗1 = no λ ()
  (S ⊸ T) ≟Ty &1 = no λ ()
  (S ⊸ T) ≟Ty ⊕0 = no λ ()
  (S ⊸ T) ≟Ty (S′ ⊸ T′) =
    mapDec (λ { (refl , refl) → refl })
           (λ { refl → (refl , refl) })
           ((S ≟Ty S′) ×? (T ≟Ty T′))
  (S ⊸ T) ≟Ty ! ρ′ S′ = no λ ()
  (S ⊸ T) ≟Ty (S′ ⊗ T′) = no λ ()
  (S ⊸ T) ≟Ty (S′ & T′) = no λ ()
  (S ⊸ T) ≟Ty (S′ ⊕ T′) = no λ ()
  ! ρ S ≟Ty BASE _ = no λ ()
  ! ρ S ≟Ty ⊗1 = no λ ()
  ! ρ S ≟Ty &1 = no λ ()
  ! ρ S ≟Ty ⊕0 = no λ ()
  ! ρ S ≟Ty (S′ ⊸ T′) = no λ ()
  ! ρ S ≟Ty ! ρ′ S′ =
    mapDec (λ { (refl , refl) → refl })
           (λ { refl → refl , refl })
           ((ρ ≟ ρ′) ×? (S ≟Ty S′))
  ! ρ S ≟Ty (S′ ⊗ T′) = no λ ()
  ! ρ S ≟Ty (S′ & T′) = no λ ()
  ! ρ S ≟Ty (S′ ⊕ T′) = no λ ()
  (S ⊗ T) ≟Ty BASE _ = no λ ()
  (S ⊗ T) ≟Ty ⊗1 = no λ ()
  (S ⊗ T) ≟Ty &1 = no λ ()
  (S ⊗ T) ≟Ty ⊕0 = no λ ()
  (S ⊗ T) ≟Ty (S′ ⊸ T′) = no λ ()
  (S ⊗ T) ≟Ty (S′ ⊗ T′) =
    mapDec (λ { (refl , refl) → refl })
           (λ { refl → (refl , refl) })
           ((S ≟Ty S′) ×? (T ≟Ty T′))
  (S ⊗ T) ≟Ty ! ρ S′ = no λ ()
  (S ⊗ T) ≟Ty (S′ & T′) = no λ ()
  (S ⊗ T) ≟Ty (S′ ⊕ T′) = no λ ()
  (S & T) ≟Ty BASE _ = no λ ()
  (S & T) ≟Ty ⊗1 = no λ ()
  (S & T) ≟Ty &1 = no λ ()
  (S & T) ≟Ty ⊕0 = no λ ()
  (S & T) ≟Ty (S′ ⊸ T′) = no λ ()
  (S & T) ≟Ty (S′ ⊗ T′) = no λ ()
  (S & T) ≟Ty (S′ & T′) =
    mapDec (λ { (refl , refl) → refl })
           (λ { refl → (refl , refl) })
           ((S ≟Ty S′) ×? (T ≟Ty T′))
  (S & T) ≟Ty ! ρ S′ = no λ ()
  (S & T) ≟Ty (S′ ⊕ T′) = no λ ()
  (S ⊕ T) ≟Ty BASE _ = no λ ()
  (S ⊕ T) ≟Ty ⊗1 = no λ ()
  (S ⊕ T) ≟Ty &1 = no λ ()
  (S ⊕ T) ≟Ty ⊕0 = no λ ()
  (S ⊕ T) ≟Ty (S′ ⊸ T′) = no λ ()
  (S ⊕ T) ≟Ty (S′ ⊗ T′) = no λ ()
  (S ⊕ T) ≟Ty (S′ & T′) = no λ ()
  (S ⊕ T) ≟Ty (S′ ⊕ T′) =
    mapDec (λ { (refl , refl) → refl })
           (λ { refl → (refl , refl) })
           ((S ≟Ty S′) ×? (T ≟Ty T′))
  (S ⊕ T) ≟Ty ! ρ S′ = no λ ()

  Is⊗1? = ⊗1 ≟Ty_
  Is&1? = &1 ≟Ty_
  Is⊕0? = ⊕0 ≟Ty_

  Is⊸? : ∀ S → Dec (∃ λ S0 → ∃ λ S1 → S0 ⊸ S1 ≡ S)
  Is⊸? (BASE _) = no λ { (_ , _ , ()) }
  Is⊸? ⊗1 = no λ { (_ , _ , ()) }
  Is⊸? &1 = no λ { (_ , _ , ()) }
  Is⊸? ⊕0 = no λ { (_ , _ , ()) }
  Is⊸? (S ⊸ T) = yes (S , T , refl)
  Is⊸? (S ⊗ T) = no λ { (_ , _ , ()) }
  Is⊸? (S & T) = no λ { (_ , _ , ()) }
  Is⊸? (S ⊕ T) = no λ { (_ , _ , ()) }
  Is⊸? (! ρ S) = no λ { (_ , _ , ()) }

  Is⊗? : ∀ S → Dec (∃ λ S0 → ∃ λ S1 → S0 ⊗ S1 ≡ S)
  Is⊗? (BASE _) = no λ { (_ , _ , ()) }
  Is⊗? ⊗1 = no λ { (_ , _ , ()) }
  Is⊗? &1 = no λ { (_ , _ , ()) }
  Is⊗? ⊕0 = no λ { (_ , _ , ()) }
  Is⊗? (S ⊸ T) = no λ { (_ , _ , ()) }
  Is⊗? (S ⊗ T) = yes (S , T , refl)
  Is⊗? (S & T) = no λ { (_ , _ , ()) }
  Is⊗? (S ⊕ T) = no λ { (_ , _ , ()) }
  Is⊗? (! ρ S) = no λ { (_ , _ , ()) }

  Is&? : ∀ S → Dec (∃ λ S0 → ∃ λ S1 → S0 & S1 ≡ S)
  Is&? (BASE _) = no λ { (_ , _ , ()) }
  Is&? ⊗1 = no λ { (_ , _ , ()) }
  Is&? &1 = no λ { (_ , _ , ()) }
  Is&? ⊕0 = no λ { (_ , _ , ()) }
  Is&? (S ⊸ T) = no λ { (_ , _ , ()) }
  Is&? (S ⊗ T) = no λ { (_ , _ , ()) }
  Is&? (S & T) = yes (S , T , refl)
  Is&? (S ⊕ T) = no λ { (_ , _ , ()) }
  Is&? (! ρ S) = no λ { (_ , _ , ()) }

  Is!? : ∀ S → Dec (∃ λ ρ → ∃ λ S0 → ! ρ S0 ≡ S)
  Is!? (BASE _) = no λ { (_ , _ , ()) }
  Is!? ⊗1 = no λ { (_ , _ , ()) }
  Is!? &1 = no λ { (_ , _ , ()) }
  Is!? ⊕0 = no λ { (_ , _ , ()) }
  Is!? (S ⊸ T) = no λ { (_ , _ , ()) }
  Is!? (S ⊗ T) = no λ { (_ , _ , ()) }
  Is!? (S & T) = no λ { (_ , _ , ()) }
  Is!? (S ⊕ T) = no λ { (_ , _ , ()) }
  Is!? (! ρ S) = yes (ρ , S , refl)

  Is⊕? : ∀ S → Dec (∃ λ S0 → ∃ λ S1 → S0 ⊕ S1 ≡ S)
  Is⊕? (BASE _) = no λ { (_ , _ , ()) }
  Is⊕? ⊗1 = no λ { (_ , _ , ()) }
  Is⊕? &1 = no λ { (_ , _ , ()) }
  Is⊕? ⊕0 = no λ { (_ , _ , ()) }
  Is⊕? (S ⊸ T) = no λ { (_ , _ , ()) }
  Is⊕? (S ⊗ T) = no λ { (_ , _ , ()) }
  Is⊕? (S & T) = no λ { (_ , _ , ()) }
  Is⊕? (S ⊕ T) = yes (S , T , refl)
  Is⊕? (! ρ S) = no λ { (_ , _ , ()) }
