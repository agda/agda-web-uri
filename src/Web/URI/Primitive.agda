open import Data.String using ( String )
open import Web.URI.Port.Primitive using ( Port? )
open import Web.URI.Scheme.Primitive using ( Scheme? )

module Web.URI.Primitive where
{-# IMPORT Data.Maybe #-}
{-# IMPORT Web.URI.FFI #-}

-- In Agda 2.2.10 and below, there's no FFI binding for the stdlib
-- List and Maybe types, so we have to roll our own. This will change.

data #List (X : Set) : Set where
  [] : #List X
  _∷_ : X → #List X → #List X
{-# COMPILED_DATA #List [] [] (:) #-}

data #Maybe (X : Set) : Set where
  just : X → #Maybe X
  nothing : #Maybe X
{-# COMPILED_DATA #Maybe Data.Maybe.Maybe Data.Maybe.Just Data.Maybe.Nothing #-}

data #URI : Set where
  #abs : Scheme? → String → Port? → (#List String) → (#Maybe String) → #URI
  #rel : (#List String) → (#Maybe String) → #URI
{-# COMPILED_DATA #URI Web.URI.FFI.URI Web.URI.FFI.Abs Web.URI.FFI.Rel #-}

postulate #toString : #URI → String
{-# COMPILED #toString Web.URI.FFI.toString #-}

postulate #fromString : String → (#Maybe #URI)
{-# COMPILED #fromString Web.URI.FFI.fromString #-}
