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
import Text.Pandoc.Writers.LaTeX
import Text.Pandoc.PDF as Pandoc
import Text.Pandoc.Highlighting (tango)

import Data.Aeson.Encode.Pretty

import UniformBase
import qualified Uniform.PandocImports as UP
import Uniform.Pandoc (MarkdownText, unMT, markdownFileType, Pandoc, unPandocM)
import Uniform.Pandoc (writeHtml5String2)
import Uniform.BibTex

showJSONnice = bl2t.encodePretty

mdConversion ::  ErrIO ()
mdConversion   = do
    putIOwords ["mdConversion",  "preparations"]

    curr <- currentDir 
    let docs = addDir curr (makeRelDir "docs")

    putIOwords ["mdConversion",  "read md"]
    let 
        d1fn = makeRelFile "doc1"
        
    mdText1 :: MarkdownText <- read7 docs d1fn  markdownFileType
    putIOwords ["mdText1", unMT mdText1]
    
    putIOwords ["mdConversion",  "md to pandoc"]
    pandoc1 :: Pandoc <- readMarkdown2 mdText1 
    putIOwords ["pandoc1", showJSONnice pandoc1]
    

    putIOwords ["mdConversion",  "pandoc process cites"]
    d1c :: Pandoc <- pandocProcessCites pandoc1
    putIOwords ["d1p", showJSONnice d1c]

    putIOwords ["mdConversion",  "pandoc to hmtl"]
    html <- writeHtml5String2 d1c
    putIOwords ["html", showT html]

    putIOwords ["mdConversion",  "pandoc to pdf"]
    pdf1 <- unPandocM $ Pandoc.makePDF "lualatex"   [] Pandoc.writeLaTeX latexOptions d1c
    putIOwords ["pdf1", showT pdf1]
    
    
    -- (def { writerStandalone = True, writerTemplate = tmpl}) pdoc

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

latexOptions :: Pandoc.WriterOptions
-- | reasonable extension - crucial!
latexOptions =
  Pandoc.def
    { Pandoc.writerHighlightStyle = Just tango,
      Pandoc.writerCiteMethod = Pandoc.Natbib,
      -- Citeproc                        -- use citeproc to render them
      --           | Natbib                        -- output natbib cite commands
      --           | Biblatex                      -- output biblatex cite commands
      Pandoc.writerExtensions =
        Pandoc.extensionsFromList
          [ Pandoc.Ext_raw_tex --Allow raw TeX (other than math)
          -- , Pandoc.Ext_shortcut_reference_links
          -- , Pandoc.Ext_spaced_reference_links
          -- , Pandoc.Ext_citations           -- <-- this is the important extension for bibTex
          ]
    }
