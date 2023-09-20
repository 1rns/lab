main :: IO ()
main = putStr "Hello World!"

echo :: IO ()
echo = do
    putStr "Enter a line: "
    line <- getLine
    if line == "stop" then return ()
    else do
        putStrLn line
        echo

readPoint :: (Real a) => IO (a, a, a)
readPoint = do
    line <- getLine
    let (x, y, z) = (read line::(Int, Int, Int))
    return (fromIntegral x, fromIntegral y, fromIntegral z)
