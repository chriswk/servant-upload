{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE TypeOperators #-}

module Upload.BackstageApi where

import Servant
import Upload.Models
import Data.Aeson
import qualified Data.Text as TE

type HealthStatus = "_" :> "health" :> Get '[ JSON] Health
type Prometheus = "_" :> "prometheus" :> Get '[ PlainText] TE.Text 

type BackstageApi = HealthStatus :<|> Prometheus