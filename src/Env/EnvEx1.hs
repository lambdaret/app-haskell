{-# OPTIONS_GHC -Wno-missing-export-lists #-}
module Env.EnvEx1 where

import           Data.Maybe
import           System.Environment


envEx1 :: IO ()
envEx1 = do
  a <- lookupEnv "AA"
  print $ fromMaybe "DEFAULT" a
