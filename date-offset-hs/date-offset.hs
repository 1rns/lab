{-  This program does the following:
    1.    Validate input.
    2.    Turn date into day of year, and add offset,
            e.g. 364 corresponds to 29/12 on leap years).
    3.    Normalise the day in case it goes out of bounds
          of the current year.
    4.    Convert the new day into original date format.
-}


{-
    Calls function to validate date before passing to (and returning
    the value of) the `addDaysToDate` function.

    Example:
        adjustDate (1, 3, 2024) (-5)
      > (25,2,2024)
-}
adjustDate :: (Int, Int, Int) -> Int -> (Int, Int, Int)
adjustDate (day, month, year) offset =
    let isStrict = True -- see `isValidDate`
    in if isValidDate (day, month, year) isStrict &&
          isValidOffset offset isStrict
    then addDaysToDate (day, month, year) offset
    else error "invalid date" -- error should already be thrown before this

{-
    Calls functions to convert date (d/m/y) to day of year (d/y)
    before adding offset to it. Then makes function call to convert
    back to date.

    Example:
        addDaysToDate (1, 3, 2024) (-5)
      > (25,2,2024)
-}
addDaysToDate :: (Int, Int, Int) -> Int -> (Int, Int, Int)
addDaysToDate date 0 = date
addDaysToDate (day, month, year) offset =
    let
        totalDays = dateToDaysOfYear (day, month, year) + offset
        (finalDays, finalYr) = normaliseDayOfYear totalDays year
    in
        if finalYr < 1 -- only occurs when isStrict = False
        then error "cannot subtract into negative years"
        else daysOfYearToDate finalDays finalYr

{-
    Handles cases where the offset causes day of year to go under 1
    or over 365/366.

    If year jumps between leap years, then it adds/subtracts
    to make up for the extra day in the leap year(s).

    Example:
        normaliseDayOfYear 366 2023
      > (1,2024)

        normaliseDayOfYear 0 2001
      > (366,2000)

        -- isStrict = False
        normaliseDayOfYear (365 * 3) 1999
      > (364,2001)
-}
normaliseDayOfYear :: Int -> Int -> (Int, Int)
normaliseDayOfYear totDays prevYr
    | totDays <= 365 && totDays >= 1 = (totDays, prevYr)
    | totDays == 366 && isLeapYear prevYr = (totDays, prevYr)
    | totDays == 0 = (if isLeapYear $ prevYr - 1 then 366 else 365, prevYr - 1)
    | otherwise =
        let
            finalYr = prevYr +
                if totDays < 0
                then ceiling (fromIntegral totDays / 365) - 1
                else floor (fromIntegral totDays / 365)
            finalDays = (totDays `mod` 365) - numLeapsCrossed prevYr finalYr
        in
            -- Handle edge case where the following is true:
            -- (totDays `mod` 365) == 0 && (numLeapsCrossed prevYr finalYr) > 0
            if finalDays < 1
            then normaliseDayOfYear finalDays finalYr
            else (finalDays, finalYr)

{-
    Example:
        numLeapsCrossed 2019 2025
      > 2
        numLeapsCrossed 2025 2019
      > -2
-}
numLeapsCrossed :: Int -> Int -> Int
numLeapsCrossed yr1 yr2
    | yr1 > yr2 = -sum [1 | y <- [yr2..yr1-1], isLeapYear y]
    | otherwise = sum [1 | y <- [yr1..yr2-1], isLeapYear y]

{-
    Flag `isStrict` restricts year between 1600 and 3000 (inclusive).
    Set `isStrict` to False to allow any year between [1, inf],
-}
isValidDate :: (Int, Int, Int) -> Bool -> Bool
isValidDate (day, month, year) isStrict
    | year <= 0 = error "year cannot be less than 1"
    | month < 1 || month > 12 = error "month cannot be out of interval: [1, 12]"
    | day < 1 || day > daysInMonth month year =
        error ("day does not belong to specified month: " ++ show month)
    | (year < 1600 || year > 3000) &&
      isStrict = error "year cannot be out of interval: [1600, 3000]"
    | otherwise = True

{-
    Flag `isStrict` restricts offset between -25 and 25 (inclusive).
    Set `isStrict` to False to allow any number as offset.
-}
isValidOffset :: Int -> Bool -> Bool
isValidOffset offset isStrict
    | isStrict && abs offset > 25 = error "offset cannot be out of interval: [-25, 25]"
    | otherwise = True

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

daysInMonth :: Int -> Int -> Int
daysInMonth 1 year
    | isLeapYear year = 29
    | otherwise = 28
daysInMonth m _ =
    if m == 4 || m == 6 || m == 9 || m == 11
    then 30
    else 31
