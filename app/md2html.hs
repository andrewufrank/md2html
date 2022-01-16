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
import Uniform.StartApp ( startProgWithTitle )  
import UniformBase  
import Lib.Top


programName, progTitle :: Text
programName = "md2html" :: Text
progTitle = unwords' ["example md to HTML and PDF", showVersion version] :: Text
-- could use version from cabal? 

-- the process is centered on the current working dir

main :: IO ()
main =
    startProgWithTitle
        programName progTitle
        ( do
            mdConversion
        --     flags :: PubFlags <-
        --         parseArgs2input
        --             sourceDirTestSite 
        --             --  add a delete flag
        --             ( unlinesT
        --                 [ "the flags to select what is included:"
        --                 , "default is nothing included"
        --                 , "\n -p publish"
        --                 , "\n -d drafts"
        --                 , "\n -o old"
        --                 , "\n -t test (use data in package)"
        --                 , "\n -q quick (not producing the pdfs, which is slowing down)"
        --                 , "\n -w start to watch the files for changes and rebake (implies -s s cancels -u"
        --                 , "\n -s start local server (port is fixed in settings)"
        --                 , "\n -u upload to external server (not yet implemented"
        --                 ]
        --             )
        --             "list flags to include"
        --     ssgProcess NoticeLevel0 flags
        )
