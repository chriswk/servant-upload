module Upload.Api where

import Upload.BackstageApi
import Data.Proxy
import Servant

type API = BackstageApi

api :: Proxy API
api = Proxy