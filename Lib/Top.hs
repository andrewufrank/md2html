----------------------------------------------------------------------
--
-- Module      :   convert a homepage
----------------------------------------------------------------------
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -Wall -fno-warn-orphans 
            -fno-warn-missing-signatures
            -fno-warn-missing-methods 
            -fno-warn-duplicate-exports 
            -fno-warn-unused-imports 
            -fno-warn-unused-matches #-}

{- | to convert a markdown file (.md) 

                to html and to pdf 
              orginals are found in dire doughDir and go to bakeDir
-}

module Lib.Top (mdConversion) where

import qualified Text.Pandoc as Pandoc

import UniformBase
import qualified Uniform.PandocImports as UP
import Uniform.PandocImports (MarkdownText, markdownFileType, Pandoc, unPandocM)
import Uniform.Pandoc (writeHtml5String2)
import Uniform.BibTex

mdConversion ::  ErrIO ()
mdConversion   = do
    putIOwords ["mdConversion",  "start"]

    putIOwords ["mdConversion",  "read md"]
    curr <- currentDir 
    let docs = addDir curr (makeRelDir "docs")
    let 
        d1fn = makeRelFile "doc1"
        mdFile = makeTyped (Extension "md")  ::TypedFile5 [Text] Text
    d1 :: MarkdownText <- read7 docs d1fn  markdownFileType
    putIOwords ["d1", showT d1]
    
    putIOwords ["mdConversion",  "md to pandoc"]
    d1p :: Pandoc <- readMarkdown2 d1 
    putIOwords ["d1p", showT d1p]
    

    putIOwords ["mdConversion",  "pandoc process cites"]
    d1c :: Pandoc <- pandocProcessCites d1p
    putIOwords ["d1p", showT d1c]

    putIOwords ["mdConversion",  "pandoc to hmtl"]
    html <- writeHtml5String2 d1c
    putIOwords ["html", showT html]

    putIOwords ["mdConversion",  "pandoc to pdf"]
    putIOwords ["mdConversion done"]
    return ()

readMarkdown2 text1 =
    unPandocM $ Pandoc.readMarkdown markdownOptions (unwrap7 text1 :: Text)

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