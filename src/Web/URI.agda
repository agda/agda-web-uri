open import Data.Bool using ( Bool ; true ; false ; _∨_ )
open import Data.List.Primitive using ( #List ; [] ; _∷_ )
open import Data.Maybe using ( Maybe ; just ; nothing )
open import Data.Maybe.Primitive using ( #Maybe ; just ; nothing )
open import Data.String using ( String )
open import Web.URI.Primitive using ( #URI ; #toString ; #fromString ; #abs ; #rel )
open import Web.URI.Scheme using ( Scheme? ; http: )
open import Web.URI.Port using ( Port? ; ε )

module Web.URI where

infixl 5 _/_ _#_ _//_∶_ _//_

-- No authority or query component for now, and no parent path segments.
-- URIRef? isAbs isRef tracks whether a URI is absolute or relative,
-- and whether it is a URI reference (allows a #fragment) or not.

data URIRef? : Bool → Bool → Set where
  root : {isRef : Bool} → (URIRef? false isRef)
  _//_∶_ : {isRef : Bool} → Scheme? → String → Port? → (URIRef? true isRef)
  _/_ : {isAbs isRef : Bool} → (URIRef? isAbs false) → String → (URIRef? isAbs isRef)
  _#_ : {isAbs : Bool} → (URIRef? isAbs false) → String → (URIRef? isAbs true)

RURI     = URIRef? false false
RURIRef  = URIRef? false true
RURIRef? = URIRef? false
AURI     = URIRef? true false
AURIRef  = URIRef? true true
AURIRef? = URIRef? true

URIRef : Bool → Set
URIRef isAbs = URIRef? isAbs true

URI : Bool → Set
URI isAbs = URIRef? isAbs false

_//_ : {isRef : Bool} → Scheme? → String → (URIRef? true isRef)
s // h = s // h ∶ ε

http://_ : {isRef : Bool} → String → (URIRef? true isRef)
http:// h = http: // h

xsd: : String → AURIRef
xsd:(local) = http://"www.w3.org"/"2001"/"XMLSchema"#(local)

rdf: : String → AURIRef
rdf:(local) = http://"www.w3.org"/"1999"/"02"/"22-rdf-syntax-ns"#(local)

rdfs: : String → AURIRef
rdfs:(local) = http://"www.w3.org"/"2000"/"01"/"rdf-schema"#(local)

owl: : String → AURIRef
owl:(local) = http://"www.w3.org"/"2002"/"07"/"owl"#(local)

-- Parsing --

fromURI : {isAbs isRef : Bool} → (URIRef? isAbs false) → (URIRef? isAbs isRef)
fromURI {isAbs} {false} u = u
fromURI root              = root
fromURI (s // h ∶ n)      = s // h ∶ n
fromURI (u / a)           = u / a

from#Path : {isAbs : Bool} → (URIRef? isAbs false) → (#List String) → (URIRef? isAbs false)
from#Path u []       = u
from#Path u (a ∷ as) = from#Path (u / a) as

from#Fragment : {isAbs isRef : Bool} → (URIRef? isAbs false) → (#Maybe String) → (Maybe (URIRef? isAbs isRef))
from#Fragment {isAbs} {true}  u (just f) = just (u # f)
from#Fragment {isAbs} {false} u (just f) = nothing
from#Fragment {isAbs} {isRef} u nothing  = just (fromURI u)

from#URI : {isAbs isRef : Bool} → (#Maybe #URI) → (Maybe (URIRef? isAbs isRef))
from#URI {true}  (just (#abs s h n p f)) = from#Fragment (from#Path (s // h ∶ n) p) f
from#URI {false} (just (#rel       p f)) = from#Fragment (from#Path root p) f
from#URI         _                       = nothing

fromString : {isAbs isRef : Bool} → String → (Maybe (URIRef? isAbs isRef))
fromString s = from#URI (#fromString s)

-- Serializing to#URI'

to#URI : {isAbs isRef : Bool} → (URIRef? isAbs isRef) → (#List String) → (#Maybe String) → #URI
to#URI root         as f? = #rel as f?
to#URI (s // h ∶ n) as f? = #abs s h n as f?
to#URI (u / a)      as f? = to#URI u (a ∷ as) f?
to#URI (u # f)      as f? = to#URI u as (just f)

toString :  {isAbs isRef : Bool} → (URIRef? isAbs isRef) → String
toString u = #toString (to#URI u [] nothing)

-- Composing --

_&_ : {isAbs₁ isAbs₂ isRef : Bool} → (URIRef? isAbs₁ false) → (URIRef? isAbs₂ isRef) → (URIRef? (isAbs₂ ∨ isAbs₁) isRef)
u & root         = fromURI u
u & (s // h ∶ n) = s // h ∶ n
u & (v / a)      = (u & v) / a
u & (v # a)      = (u & v) # a
