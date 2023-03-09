{-# LANGUAGE OverloadedStrings #-}

module ExAeson2 where

import Control.Applicative
import Data.Aeson
import Data.Aeson.Key
import Data.Aeson.KeyMap qualified as KM
import Data.Map qualified as Map
import Data.Text (Text)
import Data.Tuple (uncurry)
import Data.Vector (toList)

data Person = Person {name :: Text, age :: Int} deriving (Show)

-- instance FromJSON Person where
--   parseJSON = withObject "Person" $ \o -> do
--     name <- o .: "name"
--     age <- o .: "age"
--     return Person {name = name, age = age}

instance FromJSON Person where
  parseJSON (Object v) = Person <$> v .: "name" <*> v .: "age"
    where
      getDates (Object o) = do
        return $ map toString (KM.keys o)
  parseJSON _ = empty

newtype PersonList = PersonList {unPersonList :: [Person]} deriving (Show)

instance FromJSON PersonList where
  parseJSON (Array v) = PersonList <$> mapM parseJSON (toList v)
  parseJSON _ = empty

-- instance FromJSON Person where
--   parseJSON (Object v) = do
--     name <- v .: "name"
--     age <- v .: "age"
--     return $ Person {name = name, age = age}
--   parseJSON _ = empty

getData1 = decode "{\"name\": \"hi\", \"age\":10}" :: Maybe Person

getData2 = decode "[{\"name\": \"hi\", \"age\":10}]" :: Maybe PersonList

-- instance FromJSON [Person] where
--   parseJSON = withObject "Person" $ \o -> do
--     return $ fmap (Person . parseJSON) o
