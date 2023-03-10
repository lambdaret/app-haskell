{-# LANGUAGE OverloadedStrings #-}

module ExchangeRate2 where

import Control.Applicative qualified as A
import Data.Aeson
import Data.Aeson.Key
import Data.Aeson.KeyMap qualified as KM
import Data.Aeson.Types
import Data.List
import Data.Map
import Data.Maybe
import Data.Scientific
import Data.Text
import Data.Vector qualified as V
import Network.HTTP.Simple
import Numeric

url = "https://api.exchangerate.host/timeseries?start_date=2023-03-07&end_date=2023-03-07"

-- data Rate = Rate
--   { date :: Text,
--     symbol :: Text,
--     rate :: Double
--   }
--   deriving (Show)
newtype Rate = Rate
  { unRate :: (Text, Text, Double)
  }
  deriving (Show)

newtype RateList = RateList {unRateList :: [(Text, Text, Text)]} deriving (Show)

data ExchangeRate = ExchangeRate
  { -- { rates :: Maybe (Map String Double),
    dates :: Maybe [Text],
    rates :: [(Text, Text, Double)]
  }
  deriving (Show)

instance FromJSON ExchangeRate where
  parseJSON (Object v) = do
    objs <- v .: "rates"
    return $ ExchangeRate {rates = getRates objs, dates = Just (getDates objs)}
    where
      getDates (Object o) = fmap toText (KM.keys o)
      getDates _ = []
      getRates (Object o) = do
        date' :: Key <- KM.keys o
        (symbol', Number rate') <- (KM.toList . fromObject) (fromJust (KM.lookup date' o))
        return (toText date', toText symbol', toRealFloat rate')
      getRates _ = error "error"
  parseJSON _ = A.empty

fromObject :: Value -> Object
fromObject (Object o) = o
fromObject _ = error "Error"

getBody = do
  response <- httpJSON url :: IO (Response Value)
  let v = getResponseBody response
  return v

getBody2 = do
  response <- httpJSON url :: IO (Response ExchangeRate)
  let v = getResponseBody response
  return v

-- p :: Value -> [(Text, Maybe Value)]
p v = do
  ratesValue <- (KM.toList . fromObject . fromJust . KM.lookup "rates") (fromObject v)
  return ratesValue

test1 = do
  x <- Just 3
  y <- Just 5
  z <- Just $ sum $ do
    i <- [1, 2, 3]
    j <- [4, 5]
    return (i * j)

  return (x * y * z)

test2 = do
  i <- [1, 2, 3]
  j <- [4, 5]
  return (i * j)
