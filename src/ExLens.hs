{-# LANGUAGE OverloadedStrings #-}

module ExLens where

import Control.Lens
import Data.Aeson.Lens
import Data.Aeson.Types
import Data.Map
import Data.Text qualified as T
import Network.HTTP.Simple

-- | API endpoint URL
apiUrl :: String
apiUrl = "https://api.exchangerate.host/timeseries?start_date=2023-03-07&end_date=2023-03-07"

-- | Function to fetch and process the exchange rate data
-- fetchExchangeRates :: IO (Maybe (Map T.Text Double))
fetchExchangeRates = do
  request <- parseRequest apiUrl
  response <- httpJSON request :: IO (Response Value)
  let body = getResponseBody response
  return $ body ^. _Object ^. at "rates"

-- | Function to extract the exchange rates for a given symbol
rateBySymbol :: Map T.Text Double -> Maybe (T.Text, Double)
rateBySymbol ratesMap = do
  rateSymbol <- Data.Map.lookup "USD" ratesMap -- Replace "USD" with desired currency symbol
  return (T.pack "USD", rateSymbol)

-- | Entry point of the program
main :: IO ()
main = do
  maybeRates <- fetchExchangeRates
  case maybeRates of
    Nothing -> putStrLn "Error fetching rates data"
    Just rates -> print rates

getTestData = do
  let url = "https://api.exchangerate.host/timeseries?start_date=2023-03-06&end_date=2023-03-07"
  request <- parseRequest url
  response <- httpJSON request :: IO (Response Value)
  return response

-- response ^. to getResponseBody
--  v ^. _Object ^. at "rates" . to fromJust . _Object
-- ghci> v ^. _Object ^. at "rates" . to fromJust . _Object . to Data.Aeson.KeyMap.keys
-- ["2023-03-06","2023-03-07"]
-- response ^. to getResponseBody . _Object ^. at "rates" . to fromJust . _Object ^. at "2023-03-07" . to fromJust . _Object
