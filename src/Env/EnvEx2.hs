{-# OPTIONS_GHC -Wno-missing-export-lists #-}
module Env.EnvEx2 where
import           Configuration.Dotenv
import           System.Environment

newConfig :: Config
newConfig = defaultConfig {
  configOverride = True
}

envEx2 :: IO ()
envEx2 = do
  -- loadFile newConfig
  loadFile defaultConfig
  a <- lookupEnv "AA"
  print a

-- $ AA=world stack ghci
-- ghci> :l EnvEnvEx2
-- ghci> envEx2
