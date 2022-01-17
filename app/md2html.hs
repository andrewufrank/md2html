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
import Control.Monad.IO.Class

-- import Uniform.StartApp ( startProgWithTitle )  
import UniformBase  
-- import Lib.Top

import Text.Pandoc 
import Text.Pandoc as Pandoc
import Text.Pandoc.Citeproc 
main :: IO ()
main = do 

    putStrLn "start test md to html and pdf test with citations"

    res1 <- runIO  mdConversion2
    res2 <- handleError  res1

    putStrLn . unwords $ ["end test. result: ", show res2]

mdConversion2 :: PandocIO () 
mdConversion2 = do 
    -- read md file 
    md1 <- liftIO $ readFile "docs/doc1.md"

    -- convert md to pandoc 
    p1 <- readMarkdown markdownOptions (s2t md1)

    -- process citations
    p2 <- processCitations p1 

    liftIO $ putStrLn . show $ p2 

    return ()

-- | Reasonable options for reading a markdown file
markdownOptions :: Pandoc.ReaderOptions
markdownOptions = Pandoc.def { Pandoc.readerExtensions = exts }
  where
    exts = mconcat
        [ Pandoc.extensionsFromList
            [ Pandoc.Ext_yaml_metadata_block
            , Pandoc.Ext_fenced_code_attributes
            , Pandoc.Ext_auto_identifiers
            -- , Pandoc.Ext_raw_html   -- three extension give markdown_strict
            , Pandoc.Ext_raw_tex   --Allow raw TeX (other than math)
            , Pandoc.Ext_shortcut_reference_links
            , Pandoc.Ext_spaced_reference_links
            , Pandoc.Ext_footnotes  -- all footnotes
            , Pandoc.Ext_citations           -- <-- this is the important extension for bibTex
            ]
        , Pandoc.githubMarkdownExtensions
        ]