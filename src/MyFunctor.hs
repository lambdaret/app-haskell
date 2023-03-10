{-# OPTIONS_GHC -Wno-missing-export-lists #-}
module MyFunctor where

newtype MyList a = MyList
  { unMyList :: [a]
  }
  deriving (Show)

instance Functor MyList where
  fmap f (MyList xs) = MyList (fmap f xs)

instance Applicative MyList where
  pure a = MyList [a]
  (MyList fs) <*> (MyList xs) = MyList [f x | f <- fs, x <- xs]

instance Monad MyList where
  (MyList xs) >>= f = MyList [y | x <- xs, y <- unMyList (f x)]

instance Semigroup (MyList a) where
  (<>) (MyList xs) (MyList ys) = MyList (xs ++ ys)

instance Monoid (MyList a) where
  mempty = MyList []

-- pure x = MyList [x]

-- instance Applicative MyList => Monad MyList where
--   (MyList xs) >>= f = MyList [y | x <- xs, y <- unMyList (f x)]

f123 :: (Monad m, Num b) => m b -> m b
f123 x = do
  y <- x
  return $ y * 2
