{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
module Exception.ErrEx3 where
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

errEx3 :: IO ()
errEx3 = do
  handle handler $ readFile "does_not_exist.txt" >>= print
  handle handler $ do
    let result = sum2Pairs [2,3,4,5]
    print result
  where
    handler :: ListException -> IO ()
    handler e = print e
