module Lib.List where

  infixr 5 _∷_

  data List {a} (A : Set a) : Set a where
   [] : List A
   _∷_ : (x : A) (xs : List A) → List A

  -- Bidirectional order of arguments
  fold : ∀ {a b} {A : Set a} → List A → (B : Set b) (n : B) (c : A → B → B) → B
  fold [] B n c = n
  fold (x ∷ xs) B n c = c x (fold xs B n c)

  data ListR {a b r} {A : Set a} {B : Set b} (R : A → B → Set r)
             : List A → List B → Set r where
    [] : ListR R [] []
    _∷_ : ∀ {x y xs ys} (r : R x y) (rs : ListR R xs ys) →
          ListR R (x ∷ xs) (y ∷ ys)
