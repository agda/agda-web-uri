module Web.URI.Port.Primitive where

postulate Port? : Set
{-# COMPILED_TYPE Port? String #-}

postulate :80 : Port?
{-# COMPILED :80 ":80" #-}

postulate ε : Port?
{-# COMPILED ε "" #-}
