{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{- 
https://hackage.haskell.org/package/base-4.16.0.0/docs/Control-Exception.html#g:4 
-}
module Exception.ErrEx4 where
import Control.Exception

data MyException = ThisException | ThatException
  deriving Show

instance Exception MyException

errEx4 :: IO ()
errEx4 = do
  throw ThisException `catch` \e -> putStrLn ("Caugh " ++ show (e::MyException))
  putStrLn "hello"