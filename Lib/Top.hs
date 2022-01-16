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


import UniformBase

mdConversion ::  ErrIO ()
mdConversion   = do
    putIOwords ["mdConversion",  "start"]
    putIOwords ["mdConversion",  "read md"]
    putIOwords ["mdConversion",  "md to pandoc"]
    putIOwords ["mdConversion",  "pandoc process cites"]
    putIOwords ["mdConversion",  "pandoc to hmtl"]
    putIOwords ["mdConversion",  "pandoc to pdf"]
    putIOwords ["mdConversion done"]
    return ()

