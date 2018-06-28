{-# LANGUAGE OverloadedStrings #-}

{-|
Module : Upload.Models
Description : Types and models used throught the application
Copyright : (c) FINN.no 2018
License: Apache v2
Maintainer: ck@schibsted.com
Stability : experimental
Portability : Posix

-}
module Upload.Models (Health(..),
 Failure, 
 Success,
 FileHandle ) where

import Data.Aeson


newtype Health = Health { status :: String } deriving (Show)

data UploadEnvelope = UploadEnvelope {
    clientId :: String
    , verticalId :: String
} deriving (Show)

type Failure = String
type Success = String

data FileHandle = FileHandle {
    failures :: [Failure]
    , success :: [Success]
} deriving (Show)
