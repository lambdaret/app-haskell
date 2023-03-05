module ExType where

type Amount = Int

doubleInt :: Int -> Int
doubleInt n = n*2

doubleInt' :: Amount -> Amount
doubleInt' n = n*2
    