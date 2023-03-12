{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}

module Json.ExJson where

-- import           Data.Aeson          (Value (Object), withObject, (.:))
import           Data.Aeson.Types
import           Data.Map
import           Network.HTTP.Simple


getObj :: Response Value -> Object
getObj res = case getResponseBody res of
  Object o -> o
  _        -> error "Exception"

-- getRates = lookup "rates"

tupleizeFields :: Value -> Either String (Map String (Map String Double))
tupleizeFields = parseEither $
  withObject "rates" $ \obj -> do
    obj .: "rates"

parseRates :: Value -> Maybe (Map String (Map String Double))
parseRates = parseMaybe $
  withObject "rates" $ \obj -> do
    obj .: "rates"

getJson :: IO ()
getJson = do
  response <- httpJSON url :: IO (Response Value)
  print $ getObj response
  where
    url = "https://api.exchangerate.host/timeseries?start_date=2023-03-07&end_date=2023-03-07"
