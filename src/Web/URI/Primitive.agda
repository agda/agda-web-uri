open import Data.String using ( String )
open import Data.List.Primitive using ( #List )
open import Data.Maybe.Primitive using ( #Maybe )
open import Web.URI.Port.Primitive using ( Port? )
open import Web.URI.Scheme.Primitive using ( Scheme? )

module Web.URI.Primitive where
{-# IMPORT Data.Maybe #-}
{-# IMPORT Web.URI.AgdaFFI #-}

data #URI : Set where
  #abs : Scheme? → String → Port? → (#List String) → (#Maybe String) → #URI
  #rel : (#List String) → (#Maybe String) → #URI
{-# COMPILED_DATA #URI Web.URI.AgdaFFI.URI Web.URI.AgdaFFI.Abs Web.URI.AgdaFFI.Rel #-}

postulate #toString : #URI → String
{-# COMPILED #toString Web.URI.AgdaFFI.toString #-}

postulate #fromString : String → (#Maybe #URI)
{-# COMPILED #fromString Web.URI.AgdaFFI.fromString #-}
