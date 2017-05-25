{-# LANGUAGE MagicHash #-}

module Main where

import Data.ByteString (ByteString)
import Java
import System.IO (BufferMode (..), hSetBuffering, stdout)

import qualified Data.ByteString as B

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

readFileBytes :: String -> IO JByteArray
readFileBytes uri = readAllBytes =<< getPath =<< createURI uri

toByteString :: JByteArray -> ByteString
toByteString ba = B.pack $ fromIntegral <$> bs
    where bs = fromJava ba :: [Byte]

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    putStr "Please enter a valid file URI: "
    uri <- getLine
    putStr "Reading file contents into memory: "
    bytes <- readFileBytes uri
    putStrLn "done"
    putStr "Number of bytes read: "
    bytesRead <- java $ withObject bytes alength
    putStrLn $ show $ bytesRead
    putStr "Converting from JByteArray to ByteString: "
    let bs = toByteString bytes
    putStrLn "done"
    putStr "Number of bytes converted: "
    putStrLn $ show $ B.length bs



