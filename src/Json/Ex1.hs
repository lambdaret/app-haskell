{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}

module Json.Ex1 where

import           Data.Aeson

import           Data.Aeson.KeyMap

newtype Test = Test [Int] deriving (Show)

instance FromJSON Test where
  parseJSON = withObject "Test" (\o -> Test <$> mapM parseJSON (elems o))
