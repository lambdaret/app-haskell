{-# OPTIONS_GHC -fwarn-unused-imports #-}
{-# LANGUAGE OverloadedStrings #-}

module Demo where

import           PrettyPrint
import           Project
import           Reporting

someProject :: Project
someProject = ProjectGroup "Sweden" [stockholm, gothenburg, malmo]
    where
        stockholm = Project 1 "Stockholm"
        gothenburg = Project 2 "Gothenburg"
        malmo = ProjectGroup "Malmo" [city, limhamn]
        city = Project 3 "Malmo City"
        limhamn = Project 4 "Limhamn"
