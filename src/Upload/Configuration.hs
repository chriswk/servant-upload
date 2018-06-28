module Upload.Configuration where

import Data.Int (Int16)
import Data.Monoid (Last (..), (<>))
import Options.Applicative (Parser, ParserInfo, eitherReader, execParser, fullDesc, header, help, helper, info, long, metavar, option, optional, progDesc, short, strOption)
import Text.Read (readEither)

data ConfigError = MissingPort
                 | MissingStoreDirectory
                 deriving Show

newtype Port = Port { unPort :: Int16 } deriving Show

data PartialConfig = PartialConfig { pcPort :: Last Port
    , pcStoreDirectory :: Last FilePath
}

defaultConfig :: PartialConfig
defaultConfig = PartialConfig { 
    pcPort = pure (Port 8080)
    , pcStoreDirectory = pure "/tmp/mmo"
    }

data Config =
    Config { port :: Port
    , storeDirectory :: FilePath 
    }

instance Monoid PartialConfig where
    mempty = PartialConfig mempty mempty
    mappend a b = mempty { pcPort = pcPort a <> pcPort b 
                         , pcStoreDirectory = pcStoreDirectory a <> pcStoreDirectory b 
                         }

makeConfig :: PartialConfig -> Either ConfigError Config
makeConfig pc = do
    let lastToEither e (Last Nothing) = Left e
        lastToEither _ (Last (Just v)) = Right v
    port' <- lastToEither MissingPort (pcPort pc)
    storeDir' <- lastToEither MissingStoreDirectory (pcStoreDirectory pc)
    pure Config {
        port = port'
        , storeDirectory = storeDir' 
    }

parseOptions :: FilePath -> IO (Either ConfigError Config)
parseOptions configFilePath = do
    fileConfig <- parseConfigFile configFilePath
    commandLineConfig <- parseCommandLine
    pure (makeConfig (defaultConfig <> fileConfig <> commandLineConfig))

parseConfigFile :: FilePath -> IO PartialConfig
parseConfigFile = const (pure mempty)

parseCommandLine :: IO PartialConfig
parseCommandLine = execParser commandLineParser

commandLineParser :: ParserInfo PartialConfig
commandLineParser =
    let mods = fullDesc 
            <> progDesc "Upload files/documents and images" 
            <> header "Upload - Simple upload server"
    in info (helper <*> partialConfigParser) mods

partialConfigParser :: Parser PartialConfig
partialConfigParser = PartialConfig <$> portParser <*> storeDirectoryParser

portParser :: Parser (Last Port)
portParser =
    let portHelp = help "TCP port to accept connections on"
        mods = long "port" <> short 'p' <> metavar "PORT" <> portHelp
        portReader = eitherReader (fmap Port . readEither)
    in Last <$> optional (option portReader mods)

storeDirectoryParser :: Parser (Last FilePath)
storeDirectoryParser =
    let dirHelp = help "Root folder to store files/images to"
        mods = long "storedir" <> short 'd' <> metavar "STOREDIR" <> dirHelp
    in Last <$> optional (strOption mods)