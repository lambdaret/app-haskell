{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE DeriveGeneric #-}

module Json.ExAeson6 where

import           Data.Aeson
import           GHC.Generics

-- Define a simple data type
data MyData = MyData { x :: Int, y :: Bool } deriving (Show, Generic)

-- Define a JSON instance for MyData using GHC.Generics
instance ToJSON MyData

instance FromJSON MyData

-- Example usage
mainExAeson6 :: IO ()
mainExAeson6 = print $ encode (MyData 42 True)
