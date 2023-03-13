{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

module Logging.LogEx4 where



import Control.Monad.Logger.Aeson
import System.Log.FastLogger
import Control.Monad

doStuff :: (MonadLogger m) => Int -> m ()
doStuff x = do
  logDebug $ "Doing stuff" :# ["x" .= x]


logEx4 :: IO ()
logEx4 = do
  loggerSet <- newFileLoggerSet defaultBufSize "logex4.log"
--   loggerSet <- newFileLoggerSetN 30 (Just 2) "logex4.log"

  runFastLoggingT loggerSet do
    doStuff 42
    replicateM_ 10 $ logInfo "Done"
