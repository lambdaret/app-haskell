{-# OPTIONS_GHC -Wno-missing-export-lists #-}
module Etc.Reporting where

import           Data.Monoid  (getSum)

import qualified Etc.Database as DB
import           Etc.Project

data Report = Report
    { budgetProfit :: Money
     , netProfit   :: Money
     , difference  :: Money
    } deriving (Show, Eq)

instance Semigroup Report where
    (<>) (Report b1 n1 d1) (Report b2 n2 d2) =
        Report (b1+b2) (n1+n2) (d1+d2)

instance Monoid Report where
    mempty = Report 0 0 0
    -- mappend (Report b1 n1 d1) (Report b2 n2 d2) =
    --     Report (b1+b2) (n1+n2) (d1+d2)

calculateReport :: Budget -> [Transaction] -> Report
calculateReport budget transactions =
    Report
        { budgetProfit = budgetProfit'
        , netProfit = netProfit'
        , difference = netProfit' - budgetProfit'
        }
        where
            budgetProfit' = budgetIncome budget - budgetExpenditure budget
            netProfit' = getSum (foldMap asProfit transactions)
            asProfit (Sale m)     = pure m
            asProfit (Purchase m) = pure (negate m)

calculateProjectReport :: Project -> IO Report
calculateProjectReport = calc
  where
    calc (Project p _) =
        calculateReport <$> DB.getBudget p <*> DB.getTransactions p
    calc (ProjectGroup _ projects) = foldMap calc projects
