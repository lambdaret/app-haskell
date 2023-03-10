{-# LANGUAGE OverloadedStrings #-}

module ExAeson4 where

import Data.Aeson
import Data.Aeson.KeyMap qualified as KM
import Data.Aeson.Types
import Data.Maybe
import Data.Vector

jsonData :: Value
jsonData =
  object
    [ "name" .= ("John Doe" :: String),
      "age" .= (30 :: Int),
      "interests" .= (["reading", "coding", "music"] :: [String])
    ]

data Person = Person
  { name :: String,
    age :: Int,
    interests :: Interests
  }
  deriving (Show)

newtype Interests = Interests
  { unInterests :: [String]
  }
  deriving (Show)

parsePerson :: Value -> Parser Person
parsePerson = withObject "person" $ \obj -> do
  Person
    <$> obj
    .: "name"
    <*> obj
    .: "age"
    <*> withArray
      "interests"
      ( \arr -> do
          Interests <$> traverse parseJSON (toList arr)
      )
      (fromJust (KM.lookup "interests" obj))

main :: IO ()
main = do
  print $ parseMaybe parsePerson jsonData

--   print $ parseMaybe parsePerson (encode jsonData)

-- let result = eitherDecodeStrict' $ encode jsonData >>= parseEither parsePerson
-- print result -- Right (Person {name = "John Doe", age = 30, interests = ["reading","coding","music"]})
