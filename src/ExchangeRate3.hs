{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
module ExchangeRate3 where

import           Data.Aeson
import qualified Data.Map            as M
import           Data.Text
import           GHC.Generics
import           Network.HTTP.Simple

data ExchangeRate = ExchangeRate {
  motd       :: M.Map Text Text,
  success    :: Bool,
  timeseries :: Bool,
  base       :: Text,
  start_date :: Text,
  end_date   :: Text,
  rates      :: M.Map Text (M.Map Text Double)
} deriving (Show, Generic)

instance FromJSON ExchangeRate;

url :: Request
url = "https://api.exchangerate.host/timeseries?start_date=2023-03-07&end_date=2023-03-07&base=USD"

getExchangeRate :: IO ExchangeRate
getExchangeRate = do
  response <- httpJSON url :: IO (Response ExchangeRate)
  return $ getResponseBody response

getRates :: ExchangeRate -> [(Text, Text, Text, Double)]
getRates er = do
  base' <- [base er]
  (date', rateMap) <- M.toList (rates er)
  (symbol', rate') <- M.toList rateMap
  return (date', base', symbol', rate')

showRates :: IO ()
showRates = do
  ex <- getExchangeRate
  print $ getRates ex
