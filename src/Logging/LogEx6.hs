{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

module Logging.LogEx6 where

import System.Log.FastLogger
import Control.Monad.Logger.Aeson
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as C8
import Data.Function (on)
import Data.Text


x :: FormattedTime -> Message
x time = do
  "Some log message with metadata" :# [ "bloorp" .= (42 :: Int), "bonk" .= ("abc" :: Text), "time" .= C8.unpack time]

logex6 :: IO ()
logex6 = do
  -- timeformat <- newTimeCache simpleTimeFormat'
  timeformat <- newTimeCache (C8.pack "%F_%H%M%S")
  let logspec = TimedFileLogSpec "logex6.log" "%F_%H%M" (on (==) (BS.take 15)) check
  let logtype = LogFileTimedRotate logspec defaultBufSize
  withTimedFastLogger timeformat logtype $ \logger->do
    -- logger (\time -> toLogStr time <> " " <> "hi" <> "\n")
    logger (toLogStr . x)



