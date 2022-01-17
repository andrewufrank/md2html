-------------------------------------------------------------------
--
-- Module      :   interactive start 
----------------------------------------------------------------------
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}

{- | the main for the example
    to convert a markdown file
    to HTML and PDF
    using haskell pandoc
-}
module Main where -- must have Main (main) or Main where

import Paths_md2html
import Data.Version

import Uniform.StartApp ( startProgWithTitle )  
import UniformBase  
import Lib.Top

import Text.Pandoc 
import Text.Pandoc as Pandoc

main :: IO ()
main = do 

putStrLn "start test md to html and pdf test with citations"

res1 <- runIO  mdConversion
res2 <- handleError  res1

putStrLn . unwords $ ["end test. result: ", res2]

mdConversion :: PandocIO () 
mdConversion = do 
    return ()
 