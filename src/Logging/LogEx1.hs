{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

module Logging.LogEx1 where

import Control.Monad.Logger.CallStack
import Data.Text (pack)

doStuff :: (MonadLogger m) => Int -> m ()
doStuff x = do
  logDebug $ "Doing stuff: x=" <> pack (show x)

logEx1 :: IO ()
logEx1 = do
  runStdoutLoggingT do
    doStuff 42
    logInfo "Done"
