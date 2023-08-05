adjustDate :: (Int, Int, Int) -> Int -> (Int, Int, Int)
adjustDate (day, month, year) offset =
  if checkValidDate (day, month, year)
    then addDaysToDate (day, month, year) offset
    else error ""

addDaysToDate :: (Int, Int, Int) -> Int -> (Int, Int, Int)
addDaysToDate (day, month, year) offset
  | offset == 0 = (day, month, year)
  | otherwise =
      let
        totalDays = dateToDaysOfYear (day, month, year) + offset
        (finalDays, finalYr) = normaliseDate totalDays year
      in
        daysOfYearToDate finalDays finalYr

normaliseDate :: Int -> Int -> (Int, Int)
normaliseDate totDays prevYr
  | totDays <= 365 && totDays >= 1 = (totDays, prevYr)
  | totDays == 366 && isLeapYear prevYr = (totDays,prevYr)
  | totDays == 0 = (if isLeapYear (prevYr - 1) then 366 else 365,prevYr - 1)
  | totDays < 1 = let
      finalYr = prevYr + ceiling (fromIntegral totDays / 365) - 1
      invDays = (totDays `mod` 365) + countLeapsInInterval prevYr finalYr
    in
      if invDays == 0
      then normaliseDate invDays (finalYr + 1)
      else (invDays, finalYr)
  | otherwise = let
      finalYr = prevYr + floor (fromIntegral totDays / 365)
      finalDays = (totDays `mod` 365) - countLeapsInInterval prevYr finalYr
    in
      if totDays < 1
      then normaliseDate totDays finalYr
      else (finalDays, finalYr)

countLeapsInInterval :: Int -> Int -> Int
countLeapsInInterval yr1 yr2 = sum [1 | y <- [yr1 .. yr2], isLeapYear y]

-- #TODO
checkValidDate :: (Int, Int, Int) -> Bool
checkValidDate (date, month, year) = True

daysOfYearToDate :: Int -> Int -> (Int, Int, Int)
daysOfYearToDate totalDays yr =
  let
    cMonths = cumulativeMonths yr
    month = getFirstIndexGreaterOrEqThan totalDays cMonths
    day = totalDays - valueAt (month - 1) cMonths
  in (day, month, yr)

dateToDaysOfYear :: (Int, Int, Int) -> Int
dateToDaysOfYear (d, m, y) = d + getCumulativeDaysOfMonth m y

isLeapYear :: Int -> Bool
isLeapYear year = year `mod` 4 == 0 &&
                 (year `mod` 100 /= 0 ||
                  year `mod` 400 == 0)

valueAt :: Ord a => Int -> [a] -> a
valueAt index (h:t)
  | index == 0 = h
  | otherwise = valueAt (index - 1) t

getCumulativeDaysOfMonth :: Int -> Int -> Int
getCumulativeDaysOfMonth month yr =
  valueAt (month - 1) (cumulativeMonths yr)

cumulativeMonths :: Int -> [Int]
cumulativeMonths year
  | isLeapYear year = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366]
  | otherwise       = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365]

getFirstIndexGreaterOrEqThan :: Int -> [Int] -> Int
getFirstIndexGreaterOrEqThan _ [] = -1
getFirstIndexGreaterOrEqThan num (h : t)
  | h >= num = 0 -- return *this* index
  | current == -1 = -1 -- no elem greater than
  | otherwise = 1 + current -- increment index
  where
    current = getFirstIndexGreaterOrEqThan num t

-- ———— Unused ———— --
daysInMonth :: Int -> Bool -> Int
daysInMonth 1 True = 29
daysInMonth 1 False = 28
daysInMonth m _ =
  if m == 4 || m == 6 || m == 9 || m == 11
  then 30
  else 31
