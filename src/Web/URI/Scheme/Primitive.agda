module Web.URI.Scheme.Primitive where

postulate Scheme? : Set
{-# COMPILED_TYPE Scheme? String #-}

postulate http: : Scheme?
{-# COMPILED http: "http:" #-}

postulate https: : Scheme?
{-# COMPILED https: "https:" #-}

postulate ε : Scheme?
{-# COMPILED ε "" #-}

