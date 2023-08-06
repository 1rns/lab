{-  This program does the following:

    1.    Validate input.
    2.    Turn date into day of year, then add offset.
    3.    Normalise the day in case it goes out of bounds
          of the current year.
    4.    Convert the new day into original date format.

    The flag `isStrict` restricts inputs (e.g. offset to be between
    -25 and 25). Setting it to false allows any num as offset.  -}


{-  Validates date & offset before adding/subtracting days.

    Example:
    > adjustDate (1, 3, 2024) (-5)
      (25,2,2024)  -}
adjustDate :: (Int, Int, Int) -> Int -> (Int, Int, Int)
adjustDate (day, month, year) offset =
    let isStrict = True -- see `isValidDate`
    in if isValidDate (day, month, year) isStrict &&
          isValidOffset offset isStrict
    then addDaysToDate (day, month, year) offset
    else error "invalid date" -- error should already be thrown before this

{-  Converts date (d/m/y) to day of year (d/y) then adds offset,
    which it then convert back to date.

    Example:
    > addDaysToDate (1, 3, 2024) (-5)
      (25,2,2024)  -}
addDaysToDate :: (Int, Int, Int) -> Int -> (Int, Int, Int)
addDaysToDate date 0 = date
addDaysToDate (day, month, year) offset =
    let
        totalDays = dateToDayOfYear (day, month, year) + offset
        (finalDays, finalYr) = normaliseDayOfYear totalDays year
    in
        if finalYr < 1 -- only occurs when isStrict = False
        then error "cannot subtract into negative years"
        else dayOfYearToDate finalDays finalYr

{-  Handles cases where the offset causes day of year to go under 1
    or over 365/366.

    If year jumps between leap years, then it adds/subtracts
    to make up for the extra day in the leap year(s).

    Example:
    > normaliseDayOfYear 366 2023
      (1,2024)

    > normaliseDayOfYear 0 2001
      (366,2000)

    -- isStrict = False
    > normaliseDayOfYear (365 * 3) 1999
      (364,2001)  -}
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
            finalDays = (totDays `mod` 365) - leapYearDiff prevYr finalYr
        in
            -- Handles edge case where the following is true:
            -- (totDays `mod` 365) == 0 && (numLeapsCrossed prevYr finalYr) > 0
            if finalDays < 1
            then normaliseDayOfYear finalDays finalYr
            else (finalDays, finalYr)

{-  Given two years, returns the number of leap years
    between them. If the first year is greater, then the number
    of leap years (if any) is negative.

    Example:
    > leapYearDiff 2019 2025
      2
    > leapYearDiff 2025 2019
      -2  -}
leapYearDiff :: Int -> Int -> Int
leapYearDiff yr1 yr2
    | yr1 > yr2 = -sum [1 | y <- [yr2..yr1-1], isLeapYear y]
    | otherwise = sum [1 | y <- [yr1..yr2-1], isLeapYear y]

{-  Validates date.
    The flag `isStrict` restricts year between 1600 and 3000 (inclusive).
    Set `isStrict` to False to allow any year between [1, inf],  -}
isValidDate :: (Int, Int, Int) -> Bool -> Bool
isValidDate (day, month, year) isStrict
    | year <= 0 =
        error "year cannot be less than 1"
    | month < 1 || month > 12 =
        error "month cannot be out of interval: [1, 12]"
    | day < 1 || day > daysInMonth month year =
        error ("day `" ++ show day ++ "` outside range of specified month `")
    | (year < 1600 || year > 3000) && isStrict =
        error "year cannot be out of interval: [1600, 3000]"
    | otherwise =
        True

{-  Validates offset.
    The flag `isStrict` restricts offset between -25 and 25 (inclusive).
    Set `isStrict` to False to allow any number as offset.  -}
isValidOffset :: Int -> Bool -> Bool
isValidOffset offset isStrict
    | isStrict && abs offset > 25 = error "offset cannot be out of interval: [-25, 25]"
    | otherwise = True

{-  Given a day of the year and the year, returns date in the
    format (d,m,y).

    Example:
    > dayOfYearToDate 366 2000
      (31,12,2000)  -}
dayOfYearToDate :: Int -> Int -> (Int, Int, Int)
dayOfYearToDate totalDays yr =
    let
        cMon = cumulativeMonths yr
        mon = getFirstGeqIndex totalDays cMon
        day = totalDays - valueAt (mon - 1) cMon
    in
        (day, mon, yr)

{-  Given a value and a list of elements w/ the same type, returns
    the first index with a value greater or equal than.

    Example:
    > getFirstGeqIndex 4 [1,2,3,4,5,6]
      3  -}
getFirstGeqIndex :: Ord a => a -> [a] -> Int
getFirstGeqIndex _ [] = -1
getFirstGeqIndex num (h : t)
    | h >= num = 0
    | current == -1 = -1
    | otherwise = 1 + current
    where current = getFirstGeqIndex num t

{-  Converts (d,m,y) to day of year.

    Example:
    > (30,12,2024)
      365  -}
dateToDayOfYear :: (Int, Int, Int) -> Int
dateToDayOfYear (d, m, y) = d + getNumDaysBeforeMonth m y

{-  Returns True if the argument passed is a leap year.  -}
isLeapYear :: Int -> Bool
isLeapYear year =
    year `mod` 4 == 0 && (
    year `mod` 100 /= 0 ||
    year `mod` 400 == 0  )

{-  Given an index and a list, returns the value of the
    list at that index.

    Example:
    > valueAt 2 [2,1,4,3]
      4
    > valueAt 4 [1,2,3,4]
      *** Exception: index out of list bounds  -}
valueAt :: Ord a => Int -> [a] -> a
valueAt 0 [] = error "index out of list bounds"
valueAt index (h:t)
    | index > 0 && null t = error "index out of list bounds"
    | index < 0 = error "cannot have negative index"
    | index == 0 = h
    | otherwise = valueAt (index - 1) t

{-    Example:
    > getNumDaysBeforeMonth 1 1994
      0
    > getNumDaysBeforeMonth 3 2004
      60  -}
getNumDaysBeforeMonth :: Int -> Int -> Int
getNumDaysBeforeMonth month yr =
    valueAt (month - 1) (cumulativeMonths yr)

{-  Gets list of values corresponding to the cumulative days
    for each month.

    Example:
    > cumulativeMonths 2000
    [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366]  -}
cumulativeMonths :: Int -> [Int]
cumulativeMonths year
    | isLeapYear year =
        [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366]
    | otherwise =
        [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365]

{-  Given a month and a year, determines the number of days
    in the month.

    Example:
    > daysInMonth 2 2000
      29  -}
daysInMonth :: Int -> Int -> Int
daysInMonth 2 year
    | isLeapYear year = 29
    | otherwise = 28
daysInMonth m _ =
    if m == 4 || m == 6 || m == 9 || m == 11
    then 30 else 31
