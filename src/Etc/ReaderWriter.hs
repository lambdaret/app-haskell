{-# OPTIONS_GHC -Wno-missing-export-lists #-}
module Etc.ReaderWriter where

import           Control.Monad.Reader
import           Data.Maybe           (fromMaybe)
import           System.Environment   (lookupEnv)

data Environment = Environment
  { param1 :: String,
    param2 :: String,
    param3 :: String
  }

loadEnv :: IO Environment
loadEnv = do
  p1 <- lookupEnv "param1"
  p2 <- lookupEnv "param2"
  p3 <- lookupEnv "param3"
  return $
    Environment
      (fromMaybe "param1" p1)
      (fromMaybe "param2" p2)
      (fromMaybe "param3" p3)

func1' :: Reader Environment String
func1' = do
  res <- func2'
  return ("Result: " ++ show res)

func3 :: Environment -> Float
func3 env = fromIntegral (l1 + l2 + l3) * 2.1
  where
    l1 = length (param1 env)
    l2 = length (param2 env) * 2
    l3 = length (param3 env) * 3

func2' :: Reader Environment Int
func2' = do
  env <- ask
  let res3 = func3 env
  return (2 + floor res3)

mainRW :: IO ()
mainRW = do
  env <- loadEnv
  let str = runReader func1' env
  print str
