{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

module Logging.LogEx6 where

import System.Log.FastLogger
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as C8
import Data.Function (on)


logex6 :: IO ()
logex6 = do
  -- timeformat <- newTimeCache simpleTimeFormat'
  timeformat <- newTimeCache (C8.pack "%F_%H%M%S")
  let logspec = TimedFileLogSpec "logex6.log" "%F_%H%M" (on (==) (BS.take 15)) check
  let logtype = LogFileTimedRotate logspec defaultBufSize
  withTimedFastLogger timeformat logtype $ \logger->do
    logger (\time -> toLogStr time <> " " <> "hi" <> "\n")
    logger (\time -> toLogStr time <> " " <> toLogStr (show (head (f 1))) <> "\n")
    where
      f x = if x < 10 
              then []
              else [1,2,3]


