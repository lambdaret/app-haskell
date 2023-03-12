{-# OPTIONS_GHC -Wno-missing-export-lists #-}
{-# LANGUAGE OverloadedStrings #-}

module Etc.Demo where

import           Etc.Project

someProject :: Project
someProject = ProjectGroup "Sweden" [stockholm, gothenburg, malmo]
    where
        stockholm = Project 1 "Stockholm"
        gothenburg = Project 2 "Gothenburg"
        malmo = ProjectGroup "Malmo" [city, limhamn]
        city = Project 3 "Malmo City"
        limhamn = Project 4 "Limhamn"
