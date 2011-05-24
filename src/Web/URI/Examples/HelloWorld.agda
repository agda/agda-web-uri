open import IO using ( run ; putStrLn )
open import Web.URI using ( AURI ; toString ; http://_ ; _/_ )

module Web.URI.Examples.HelloWorld where

hw : AURI
hw = http://"example.com"/"hello"/"world"

main = run (putStrLn (toString hw))