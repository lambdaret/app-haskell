module Ex1 where

import Control.Applicative
import Data.Aeson
-- import Data.HashMap.Strict qualified as HMS

import Data.Aeson.KeyMap
import Data.Map qualified as HMS
import Data.Text (Text)

newtype Test = Test [Int] deriving (Show)

instance FromJSON Test where
  parseJSON val = withObject "Test" (\o -> Test <$> mapM parseJSON (elems o)) val
