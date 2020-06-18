-----------------------------------------------------------------------------
--
-- Module      :   a test  
------------------------------------------------------------------------

{-# OPTIONS_GHC -Wno-missing-signatures #-}

module Main     where      -- must have Main (main) or Main where

 
import           Lib.DirTree
import           Lib.OpenClass

main :: IO ()
main =  do  -- with tests in other modules
    dirMain
    openMain

