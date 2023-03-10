module Ex1 where

import           Data.Aeson

import           Data.Aeson.KeyMap

newtype Test = Test [Int] deriving (Show)

instance FromJSON Test where
  parseJSON val = withObject "Test" (\o -> Test <$> mapM parseJSON (elems o)) val
