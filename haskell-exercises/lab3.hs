-- ——3.1——
genListA :: Int -> Int -> [Int]
genListA a b
  | a == b = [b]
  | b < a = a:genListA (a - 1) b
  | otherwise = a:genListA (a + 1) b

genListB :: Int -> Int -> [Int]
genListB a b = [a..b]


-- ——3.2——
-- 3.2.1
firstTenPow2 :: [Int]
firstTenPow2 = [2^x | x <- [0..9]]

-- 3.2.2
isPow2 :: Int -> Bool
isPow2 n
  | n < 1 = False
  | n == 1 = True
isPow2 n = even n && isPow2 (n `div` 2)

-- 3.2.3
isFirstTenPow2 :: [Bool]
isFirstTenPow2 = [isPow2 x | x <- [1..10]]

-- 3.2.4
filterPow2 :: [Int] -> [Int]
filterPow2 [] = []
filterPow2 (h:t)
  | isPow2 h = h:filterPow2 t
  | otherwise = filterPow2 t

-- 3.2.5
filterPow2LC :: [Int] -> [Int]
filterPow2LC ls = [x | x <- ls, isPow2 x]

-- 3.2.6
markPow2 :: [Int] -> [(Int, Bool)]
markPow2 ls = [(x,isPow2 x) | x <- ls]


-- ——3.3——
