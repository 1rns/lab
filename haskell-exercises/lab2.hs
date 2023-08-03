-- ——2.1——
pow3 :: Int -> Int
pow3 x = x ^ 3 -- ✔

max2 :: Int -> Int -> Int
max2 = max -- ✔

diff3 :: Int -> Int -> Int -> Bool
diff3 x y z = x /= y && x /= z && y /= z -- ✔

-- ——2.2——
sumGuards :: Int -> Int -- ✔
sumGuards n
  | n == 1 = 0
  | n > 1 = n + sumGuards (n - 1)

sumIf :: Int -> Int -- ✔
sumIf n =
  if n == 1
    then 1
    else n + sumIf (n - 1)

sumPattern :: Int -> Int -- ✔
sumPattern 1 = 1
sumPattern n = n + sumPattern (n - 1)

sumBuiltin :: Int -> Int -- ✔
sumBuiltin n = sum [1 .. n]

sumFormula :: Float -> Float -- ❌ Should be Int -> Int
sumFormula n = (n * (n + 1)) / 2 -- use `div` instead of `/`

-- ——2.3——
lengthList :: [Int] -> Int -- ✔
lengthList [] = 0
lengthList (_ : tail) = 1 + lengthList tail

sumList :: [Int] -> Int -- ✔
sumList [] = 0
sumList (0 : t) = sumList t
sumList (h : t) = h + sumList t

maxList :: [Int] -> Int -- ✔
maxList [] = error "cannot have an empty list"
maxList [h] = h -- if only one element
maxList (h : t) = max h (maxList t)

-- ——2.4——
lengthList2 :: [Int] -> Int -- ✔
lengthList2 x
  | null x = 0
  | otherwise = 1 + lengthList2 (tail x)

sumList2 :: [Int] -> Int -- ✔
sumList2 x
  | null x = 0
  | otherwise = head x + sumList2 (tail x)

maxList2 :: [Int] -> Int -- ✔
maxList2 x
  | null x = error "cannot have an empty list"
  | null (tail x) = head x
  | otherwise = max (head x) (maxList2 (tail x))
