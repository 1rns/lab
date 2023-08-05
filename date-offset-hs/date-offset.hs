adjustDate :: (Int, Int, Int) -> Int -> (Int, Int, Int)
adjustDate (day, month, year) offset =
    if isDateValid (day, month, year)
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
    | totDays == 366 && isLeapYear prevYr = (totDays, prevYr)
    | totDays == 0 = (if isLeapYear $ prevYr - 1 then 366 else 365, prevYr - 1)
    | otherwise =
        let
            finalYr = prevYr +
                if totDays < 0
                then ceiling (fromIntegral totDays / 365) - 1
                else floor (fromIntegral totDays / 365)
            finalDays = (totDays `mod` 365) + numLeapsBetween prevYr finalYr
        in
            if finalDays < 1
            then normaliseDate finalDays finalYr
            else (finalDays, finalYr)

numLeapsBetween :: Int -> Int -> Int
numLeapsBetween yr1 yr2
    | yr1 > yr2 = sum [1 | y <- [yr2..yr1-1], isLeapYear y]
    | otherwise = -sum [1 | y <- [yr1..yr2-1], isLeapYear y]

-- #TODO
isDateValid :: (Int, Int, Int) -> Bool
isDateValid (date, month, year) = True

daysOfYearToDate :: Int -> Int -> (Int, Int, Int)
daysOfYearToDate totalDays yr =
    let
        cMon = cumulativeMonths yr
        mon = getFirstGeqIndex totalDays cMon
        day = totalDays - valueAt (mon - 1) cMon
    in
        (day, mon, yr)

dateToDaysOfYear :: (Int, Int, Int) -> Int
dateToDaysOfYear (d, m, y) = d + getCumulativeDaysOfMonth m y

isLeapYear :: Int -> Bool
isLeapYear year =
    year `mod` 4 == 0 && (
    year `mod` 100 /= 0 ||
    year `mod` 400 == 0  )

valueAt :: Ord a => Int -> [a] -> a
valueAt index (h:t)
    | index == 0 = h
    | otherwise = valueAt (index - 1) t

getCumulativeDaysOfMonth :: Int -> Int -> Int
getCumulativeDaysOfMonth month yr =
    valueAt (month - 1) (cumulativeMonths yr)

cumulativeMonths :: Int -> [Int]
cumulativeMonths year
    | isLeapYear year =
        [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366]
    | otherwise =
        [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365]

getFirstGeqIndex :: Int -> [Int] -> Int
getFirstGeqIndex _ [] = -1
getFirstGeqIndex num (h : t)
    | h >= num = 0
    | current == -1 = -1
    | otherwise = 1 + current
      where current = getFirstGeqIndex num t

-- ———— Unused ———— --
daysInMonth :: Int -> Bool -> Int
daysInMonth 1 True = 29
daysInMonth 1 False = 28
daysInMonth m _ =
    if m == 4 || m == 6 || m == 9 || m == 11
    then 30
    else 31
