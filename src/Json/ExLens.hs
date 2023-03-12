{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant ^." #-}
{-# LANGUAGE OverloadedStrings #-}

module Json.ExLens where

import           Control.Lens        (At (at), (^.))
import           Data.Aeson.Lens
import           Data.Aeson.Types
import           Data.Map
import qualified Data.Text           as T
import           Network.HTTP.Simple

-- | API endpoint URL
apiUrl :: String
apiUrl = "https://api.exchangerate.host/timeseries?start_date=2023-03-07&end_date=2023-03-07"

fetchExchangeRates :: IO (Maybe Value)
fetchExchangeRates = do
  request <- parseRequest apiUrl
  response <- httpJSON request :: IO (Response Value)
  let body = getResponseBody response
  return $ body ^. _Object ^. at "rates"

rateBySymbol :: Map T.Text Double -> Maybe (T.Text, Double)
rateBySymbol ratesMap = do
  rateSymbol <- Data.Map.lookup "USD" ratesMap -- Replace "USD" with desired currency symbol
  return (T.pack "USD", rateSymbol)

mainLens :: IO ()
mainLens = do
  maybeRates <- fetchExchangeRates
  case maybeRates of
    Nothing    -> putStrLn "Error fetching rates data"
    Just rates -> print rates

getTestData :: IO (Response Value)
getTestData = do
  let url = "https://api.exchangerate.host/timeseries?start_date=2023-03-06&end_date=2023-03-07"
  request <- parseRequest url
  httpJSON request :: IO (Response Value)

-- response ^. to getResponseBody
--  v ^. _Object ^. at "rates" . to fromJust . _Object
-- ghci> v ^. _Object ^. at "rates" . to fromJust . _Object . to Data.Aeson.KeyMap.keys
-- ["2023-03-06","2023-03-07"]
-- response ^. to getResponseBody . _Object ^. at "rates" . to fromJust . _Object ^. at "2023-03-07" . to fromJust . _Object
