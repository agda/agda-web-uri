module Web.URI.FFI where

import Data.Maybe (Maybe)
import qualified Network.URI ( URI )
import Network.URI 
  ( URIAuth, 
    uriScheme, uriAuthority, uriPath, uriFragment, uriRegName, uriPort, 
    unEscapeString, escapeURIString, isUnreserved, 
    parseURIReference, 
    normalizePathSegments, normalizeCase )

data URI =
  Abs String String String [String] (Maybe String) |
  Rel [String] (Maybe String)

enc :: String -> String
enc = escapeURIString isUnreserved

dec :: String -> String
dec = unEscapeString

frag :: String -> (Maybe String)
frag ('#' : f) = Just (dec f)
frag _         = Nothing

unfrag :: (Maybe String) -> String
unfrag Nothing  = ""
unfrag (Just f) = '#' : enc f

path :: String -> [String]
path "" = []
path p = path' (break (== '/') p)

path' :: (String, String) -> [String]
path' ([], [])    = []
path' (a,  [])    = [dec a]
path' ([], c : p) = path p
path' (a,  c : p) = dec a : path p

unpath :: [String] -> String
unpath []       = ""
unpath [a]      = enc a
unpath (a : as) = enc a ++ "/" ++ unpath as

fromURI' :: String -> (Maybe URIAuth) -> String -> String -> URI
fromURI' s (Just a) p f = Abs s (dec (uriRegName a)) (uriPort a) (path p) (frag f)
fromURI' s Nothing  p f = Rel (path p) (frag f)

fromURI :: Network.URI.URI -> URI
fromURI u = fromURI' (uriScheme u) (uriAuthority u) (uriPath u) (uriFragment u)

toString :: URI -> String
toString (Abs s h n p f) = s ++ "//" ++ enc h ++ n ++ "/" ++ unpath p ++ unfrag f
toString (Rel       p f) =                                   unpath p ++ unfrag f

fromString :: String -> (Maybe URI)
fromString s = fmap fromURI (parseURIReference (normalizePathSegments (normalizeCase s)))
    