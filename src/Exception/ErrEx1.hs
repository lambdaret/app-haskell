{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Monad law, left identity" #-}
{-# OPTIONS_GHC -Wno-type-defaults #-}
module Exception.ErrEx1 where
import Control.Exception

-- data ListException = ListIsEmpty | IndexNotFound
--   deriving (Show)

data ListException = ListIsEmpty | NotEnoughElements
  deriving (Show)

instance Exception ListException

myHead :: [a] -> a
myHead [] = throw ListIsEmpty
myHead (a:_) = a

sum2Pairs :: Num b => [b] -> (b, b)
sum2Pairs (a:b:c:d:_) = (a+b, c+d)
sum2Pairs _ = throw NotEnoughElements

errEx1 :: IO ()
errEx1 = do
  catch (return (sum2Pairs [2,3,4]) >>= print) handler
  catch (return (sum2Pairs [2,3,4,5]) >>= print) handler
  catch (print $ sum2Pairs [2,3,4]) handler
  where
    handler :: ListException -> IO ()
    handler = print
