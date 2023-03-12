{-# OPTIONS_GHC -Wno-missing-export-lists #-}
module Etc.TransformersLifting where

import           Control.Monad.IO.Class     (MonadIO (liftIO))
import           Control.Monad.Trans.Class  (lift)
import           Control.Monad.Trans.Maybe  (MaybeT (..))
import           Control.Monad.Trans.Reader (ReaderT, ask, runReaderT)
import           Data.Char                  (isLower, isUpper)

type Env = (Maybe String, Maybe String, Maybe String)

type TripleMonad a = MaybeT (ReaderT Env IO) a

performReader :: ReaderT Env IO a -> TripleMonad a
performReader = lift

performIO :: IO a -> TripleMonad a
performIO = lift . lift

-- main1 :: IO ()
-- main1 = do
readUserName :: MaybeT IO String
readUserName = MaybeT $ do
  putStrLn "Please enter your name!"
  str <- getLine
  if length str > 5
    then return $ Just str
    else return Nothing

readEmail :: MaybeT IO String
readEmail = MaybeT $ do
  putStrLn "Please enter your email!"
  str <- getLine
  if '@' `elem` str && '.' `elem` str
    then return $ Just str
    else return Nothing

readPassword :: MaybeT IO String
readPassword = MaybeT $ do
  putStrLn "Please enter your Password!"
  str <- getLine
  if length str < 8 || not (any isUpper str) || not (any isLower str)
    then return Nothing
    else return $ Just str

login :: String -> String -> String -> IO ()
login username _ _ = putStrLn $ "Now logged in as: " ++ username

debugFunc :: (MonadIO m) => String -> m ()
debugFunc input = liftIO $ putStrLn ("Successfully produced input: " ++ input)

readUserName' :: MaybeT (ReaderT Env IO) String
readUserName' = MaybeT $ do
  (maybeOldUser, _, _) <- ask
  case maybeOldUser of
    Just str -> return $ Just str
    Nothing -> do
      lift $ putStrLn "Please enter your Username!"
      input <- lift getLine
      if length input > 5
        then return (Just input)
        else return Nothing

main3 :: IO ()
main3 = do
  maybeCreds <- runMaybeT $ do
    usr <- readUserName
    email <- readEmail
    pass <- readPassword
    debugFunc pass
    return (usr, email, pass)
  case maybeCreds of
    Nothing        -> print "Couldn't login!"
    Just (u, e, p) -> login u e p

-- main4 = do
--   u <- runReaderT readUserName'

f1 :: IO ()
f1 = do
  x <- runReaderT (runMaybeT readUserName') (Just "aaa", Just "bbb", Just "ccc")
  case x of
    Nothing -> print "error"
    Just s  -> print s

-- f1 (Just "aaa", Just "bbb", Just "ccc")
