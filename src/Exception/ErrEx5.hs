{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{- 
https://hackage.haskell.org/package/base-4.16.0.0/docs/Control-Exception.html#g:4 
-}
module Exception.ErrEx5 where
import Control.Exception
import Data.Data

data SomeCompilerException = forall e . Exception e => SomeCompilerException e

instance Show SomeCompilerException where
  show (SomeCompilerException e) = show e

instance Exception SomeCompilerException

compilerExceptionToException :: Exception e => e -> SomeException
compilerExceptionToException = toException . SomeCompilerException

compilerExceptionFromException :: Exception e => SomeException -> Maybe e
compilerExceptionFromException x = do
  SomeCompilerException a <- fromException x
  cast a

data SomeFrontendException = forall e . Exception e => SomeFrontendException e

instance Show SomeFrontendException where
    show (SomeFrontendException e) = show e

instance Exception SomeFrontendException where
    toException = compilerExceptionToException
    fromException = compilerExceptionFromException

frontendExceptionToException :: Exception e => e -> SomeException
frontendExceptionToException = toException . SomeFrontendException

frontendExceptionFromException :: Exception e => SomeException -> Maybe e
frontendExceptionFromException x = do
    SomeFrontendException a <- fromException x
    cast a

data MismatchedParentheses = MismatchedParentheses
    deriving Show

instance Exception MismatchedParentheses where
    toException   = frontendExceptionToException
    fromException = frontendExceptionFromException

errEx5 :: IO ()
errEx5 = do
  throw MismatchedParentheses `catch` \e -> putStrLn ("Caught " ++ show (e :: MismatchedParentheses))
  throw MismatchedParentheses `catch` \e -> putStrLn ("Caught " ++ show (e :: SomeFrontendException))
  throw MismatchedParentheses `catch` \e -> putStrLn ("Caught " ++ show (e :: SomeCompilerException))
  throw MismatchedParentheses `catch` \e -> putStrLn ("Caught " ++ show (e :: IOException))
  putStrLn "hello"