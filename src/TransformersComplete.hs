module TransformersComplete where

import Control.Monad.Trans.Maybe (MaybeT (..))
import Data.Char (isLower, isUpper)

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
  if length str < 8 || null (filter isUpper str) || null (filter isLower str)
    then return Nothing
    else return $ Just str

login :: String -> String -> String -> IO ()
login username email password = putStrLn $ "Now logged in as: " ++ username

main2 :: IO ()
main2 = do
  maybeCreds <- runMaybeT $ do
    usr <- readUserName
    email <- readEmail
    pass <- readPassword
    return (usr, email, pass)
  case maybeCreds of
    Nothing -> print "Couldn't login!"
    Just (u, e, p) -> login u e p
