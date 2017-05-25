{-# LANGUAGE MagicHash #-}

module Main where

import Java
import System.IO (BufferMode (..), hSetBuffering, stdout)

data {-# CLASS "java.net.URI" #-} URI = URI (Object# URI)
    deriving (Class, Show)

data {-# CLASS "java.nio.file.Path" #-} Path = Path (Object# Path)
    deriving (Class, Show)

foreign import java unsafe "@static java.net.URI.create"
    createURI :: String -> IO URI

foreign import java unsafe "@static java.nio.file.Paths.get"
    getPath :: URI -> IO Path

foreign import java unsafe "@static java.nio.file.Files.readAllBytes"
    readAllBytes :: Path -> IO JByteArray

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    putStrLn "Please enter a valid file URI:"
    uriText <- getLine
    uri <- createURI uriText
    path <- getPath uri
    content <- readAllBytes path
    -- content has type JByteArray
    length <- javaWith content alength
    putStrLn "Number of bytes read:"
    putStrLn $ show length

