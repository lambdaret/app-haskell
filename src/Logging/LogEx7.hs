{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Logging.LogEx7 where

import System.Log.FastLogger
import Control.Monad.Logger.Aeson
import Control.Monad.Logger.Aeson.Internal
import GHC.Stack (HasCallStack, callStack)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as C8
import Data.Function (on)
import Data.Text
import Data.Aeson
import GHC.Generics
import Data.ByteString.Lazy (ByteString)

-- {"time":"2023-03-14T09:14:13.0032114Z","level":"debug","location":{"package":"main","module":"Logging.LogEx3","file":"/workspaces/workspaces_ubuntu/app-haskell/src/Logging/LogEx3.hs","line":11,"char":3},"message":{"text":"Doing stuff","meta":{"x":42}}}
data Location = Location {
  l_filename :: Text,
  l_package :: Text,
  l_module :: Text,
  l_start :: (Int, Int),
  l_end :: (Int, Int)
} deriving (Show, Generic)

data LogData = LogData {
  log_time :: Text
  , log_level :: Text
  , log_message :: Text
  , log_location :: Location
} deriving (Show, Generic)

instance ToJSON Loc

instance ToJSON Location where
  toJSON = genericToJSON defaultOptions {
             fieldLabelModifier = \f -> case f of
                                      "l_filename" -> "filename"
                                      "l_package" -> "package"
                                      "l_module" -> "module"
                                      "l_start" -> "start"
                                      "l_end" -> "end"
                                      _ -> f
            }

instance ToJSON LogData where
  toJSON = genericToJSON defaultOptions {
             fieldLabelModifier = \f -> case f of
                                      "log_time" -> "time"
                                      "log_level" -> "level"
                                      "log_message" -> "message"
                                      "log_location" -> "location"
                                      _ -> f
            }

myLog :: HasCallStack => Text -> Text -> FormattedTime -> LogStr
myLog level message time = do
  toLogStr $ encode $ LogData {
    log_time = pack $ C8.unpack time,
    log_level = level,
    log_message = message,
    log_location = toLocation $ locFromCS callStack
  }
  where 
    toLocation loc = Location {
      l_filename = pack $ loc_filename loc,
      l_package = pack $ loc_package loc,
      l_module = pack $ loc_module loc,
      l_start = loc_start loc,
      l_end = loc_end loc
    }
-- type TimedFastLogger = (FormattedTime -> LogStr) -> IO ()
myLog' :: HasCallStack => TimedFastLogger -> Text -> Text -> IO ()
myLog' logger level message  = logger \time -> toLogStr $ encode $ LogData {
    log_time = pack $ C8.unpack time,
    log_level = level,
    log_message = message,
    log_location = toLocation $ locFromCS callStack
  }
  where 
    toLocation loc = Location {
      l_filename = pack $ loc_filename loc,
      l_package = pack $ loc_package loc,
      l_module = pack $ loc_module loc,
      l_start = loc_start loc,
      l_end = loc_end loc
    }

x :: HasCallStack => FormattedTime -> Message
x time = do
  "Some log message with metadata" :# [ "bloorp" .= (42 :: Int), "bonk" .= ("abc" :: Text), "time" .= C8.unpack time, "locatoin" .= loc]
  where
    loc = locFromCS callStack


logEx7 :: IO ()
logEx7 = do
  timeformat <- newTimeCache (C8.pack "%F_%H%M%S")
  let logspec = TimedFileLogSpec "logex7.log" "%F_%H%M" (on (==) (BS.take 15)) check
  let logtype = LogFileTimedRotate logspec defaultBufSize
  withTimedFastLogger timeformat logtype $ \logger -> do
    -- logger (\time -> toLogStr time <> " " <> "hi" <> "\n")
    -- logger (toLogStr . x)
    -- logger (myLog "info" "로그메시지")
    myLog' logger "info" "로그메시지"


