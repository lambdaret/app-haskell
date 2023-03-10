{-# LANGUAGE OverloadedStrings #-}

module ExJson where

import           Data.Aeson          (Value (Object), withObject, (.:))
import           Data.Aeson.Types
import           Data.Map
import           Network.HTTP.Simple


getObj res = case getResponseBody res of
  Object o -> o
  _        -> error "Exception"

-- getRates = lookup "rates"

tupleizeFields :: Value -> Either String (Map String (Map String Double))
tupleizeFields = parseEither $
  withObject "rates" $ \obj -> do
    field1 <- obj .: "rates"
    return field1

parseRates :: Value -> Maybe (Map String (Map String Double))
-- parseRates :: Value -> Maybe (Map String (Map String Double))
parseRates = parseMaybe $
  withObject "rates" $ \obj -> do
    field1 <- obj .: "rates"
    return field1

getJson = do
  response <- httpJSON url :: IO (Response Value)
  print $ getObj response
  where
    url = "https://api.exchangerate.host/timeseries?start_date=2023-03-07&end_date=2023-03-07"
