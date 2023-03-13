{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

module Logging.LogEx5 where

import System.Log.FastLogger
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as C8
import Data.Function (on)


logX :: TimedFastLogger -> LogStr -> IO ()
logX logger msg = logger (\time -> toLogStr time <> " " <> msg <> "\n")

logex5 :: IO ()
logex5 = do
  -- timeformat <- newTimeCache simpleTimeFormat'
  timeformat <- newTimeCache (C8.pack "%F_%H%M%S")
  let logspec = TimedFileLogSpec "logex5.log" "%F_%H%M" (on (==) (BS.take 15)) check
  let logtype = LogFileTimedRotate logspec defaultBufSize 
  withTimedFastLogger timeformat logtype $ \logger->do
    logX logger "hello"
    
