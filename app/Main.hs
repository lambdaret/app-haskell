module Main (main) where

import           Env.EnvEx2 (envEx2)
-- import           Lib

main :: IO ()
-- main = someFunc
main = do
  envEx2
  print "hello"
