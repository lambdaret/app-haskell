{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}

module Json.ExchangeRate where

import qualified Control.Applicative as A
import           Data.Aeson
import           Data.Aeson.Key
import qualified Data.Aeson.KeyMap   as KM
import           Data.Maybe
import           Data.Text
import           Network.HTTP.Simple

url :: Request
url = "https://api.exchangerate.host/timeseries?start_date=2023-03-07&end_date=2023-03-07"

data ExchangeRate = ExchangeRate
  {
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
      getDates _          = []
      -- x (Object o) = KM.lookup (fromText "abc") o
      getRates (Object o) = do
        date' <- KM.keys o
        (symbol', Number rate') <- (KM.toList . fromObject) (fromJust (KM.lookup date' o))
        return (toText date', toText symbol', read (show rate'))
      getRates _ = error "error"
  parseJSON _ = A.empty


fromObject :: Value -> Object
fromObject (Object o) = o
fromObject _          = error "Error"

getBody :: IO Value
getBody = do
  response <- httpJSON url :: IO (Response Value)
  let v = getResponseBody response
  return v

getBody2 :: IO ExchangeRate
getBody2 = do
  response <- httpJSON url :: IO (Response ExchangeRate)
  let v = getResponseBody response
  return v

p :: Value -> [(Key, Value)]
p v = do
  (KM.toList . fromObject . fromJust . KM.lookup "rates") (fromObject v)

test1 :: Maybe Integer
test1 = do
  x <- Just 3
  y <- Just 5
  z <- Just $ sum $ do
    i <- [1, 2, 3]
    j <- [4, 5]
    return (i * j)

  return (x * y * z)

test2 :: [Integer]
test2 = do
  i <- [1, 2, 3]
  j <- [4, 5]
  return (i * j)
