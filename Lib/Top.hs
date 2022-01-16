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
    putIOwords ["\nmdConversion",  "preparations"]

    curr <- currentDir 
    let docs = addDir curr (makeRelDir "docs")

    putIOwords ["\nmdConversion",  "read md"]
    let 
        d1fn = makeRelFile "doc1"
        
    mdText1 :: MarkdownText <- read7 docs d1fn  markdownFileType
    putIOwords ["\nmdText1", unMT mdText1]
    
    putIOwords ["\nmdConversion",  "md to pandoc"]
    pandoc1 :: Pandoc <- readMarkdown2 mdText1 
    putIOwords ["\npandoc1", showJSONnice pandoc1]
    

    putIOwords ["\nmdConversion",  "pandoc process cites"]
    d1c :: Pandoc <- pandocProcessCites pandoc1
    putIOwords ["\nd1p", showJSONnice d1c]

    putIOwords ["\nmdConversion",  "pandoc to hmtl"]
    html <- writeHtml5String2 d1c
    -- produces WARNING: The term Abstract has no translation defined.
    putIOwords ["\nhtml", showT html]

    putIOwords ["\nmdConversion",  "pandoc to pdf"]
    tmpl1 <- unPandocM $ Pandoc.compileDefaultTemplate "latex"  

    pdf1  <- unPandocM $ Pandoc.makePDF "lualatex"   [] Pandoc.writeLaTeX (latexOptions  ( tmpl1)) d1c
    let fn =  "docs/result.pdf" :: String
    writeFile2 fn (either id id pdf1)
            -- could use handleError
    putIOwords ["\npdf1", "done in /docs/result.pdf"]

    putIOwords ["\nmdConversion done"]
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

latexOptions :: Pandoc.Template Text -> Pandoc.WriterOptions
-- | reasonable extension - crucial!
latexOptions template1 =
  Pandoc.def
    { Pandoc.writerHighlightStyle = Just tango,
      Pandoc.writerCiteMethod = Pandoc.Natbib,
      Pandoc.writerTemplate = Just template1,
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
