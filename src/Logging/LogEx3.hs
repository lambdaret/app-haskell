{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

module Logging.LogEx3 where

import Control.Monad.Logger.Aeson

doStuff :: (MonadLogger m) => Int -> m ()
doStuff x = do
  logDebug $ "Doing stuff" :# ["x" .= x]

logEx3 :: IO ()
logEx3 = do
  runFileLoggingT "logex.log" do
    doStuff 42
    logInfo "Done"
