module TransTest where

import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.Maybe (MaybeT (..), runMaybeT)
import Control.Monad.Trans.Reader (ReaderT (..), ask)

-- `ReaderT`를 사용하여 구성 값을 얻습니다.
getConfig :: ReaderT String IO String
getConfig = ask

-- `MaybeT`를 사용하여 잠재적으로 실패할 수 있는 계산을 수행합니다.
calculate :: MaybeT (ReaderT String IO) Int
calculate = do
  config <- lift getConfig
  x <- MaybeT $ return $ lookup "x" (parseConfig config)
  y <- MaybeT $ return $ lookup "y" (parseConfig config)
  return (x + y)

-- 실행을 위한 헬퍼 함수입니다.
parseConfig :: String -> [(String, Int)]
parseConfig config = [("x", 1), ("y", 2)]

-- `runMaybeT`를 사용하여 `MaybeT`를 제거합니다.
-- `runReaderT`를 사용하여 `ReaderT`를 제거합니다.
-- `main` 함수는 `IO` 동작으로 감싸여 있습니다.
main10 :: IO ()
main10 = do
  let config = "example config"
  result <- runReaderT (runMaybeT calculate) config
  case result of
    Just value -> putStrLn $ "Result: " ++ show value
    Nothing -> putStrLn "Failed to calculate result"