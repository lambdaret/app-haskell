{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

module Logging.LogEx2 where

import Control.Monad.Logger.Aeson

doStuff :: (MonadLogger m) => Int -> m ()
doStuff x = do
  logDebug $ "Doing stuff" :# ["x" .= x]

logEx2 :: IO ()
logEx2 = do
  runStdoutLoggingT do
    doStuff 42
    logInfo "Done"
