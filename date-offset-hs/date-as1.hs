adjustDate :: (Int, Int, Int) -> Int -> (Int, Int, Int)
adjustDate (day, month, year) offset =
  if checkValidDate (day, month, year) then
    addDaysToDate (day, month, year) offset
  else
    error ""

addDaysToDate :: (Int, Int, Int) -> Int -> (Int, Int, Int)
addDaysToDate (day, month, year) offset
  | offset == 0 = (day, month, year)
  | otherwise =
    let
      totalDays = dateToDaysOfYear (day, month, year) + offset
      (finalDays, finalYr) = normaliseDate totalDays year
    in
      daysOfYearToDate finalDays finalYr

-- #TODO
normaliseDate :: Int -> Int -> (Int, Int)
normaliseDate _ _ = (3, 3)

-- #TODO
checkValidDate :: (Int, Int, Int) -> Bool
checkValidDate (date, month, year) = True

-- #TODO
daysOfYearToDate :: Int -> Int -> (Int, Int, Int)
daysOfYearToDate _ _ = (3, 3, 3)

dateToDaysOfYear :: (Int, Int, Int) -> Int
dateToDaysOfYear (day, month, year) =
  day + cumulativeDays (month - 1) (checkIfLeap year)

checkIfLeap :: Int -> Bool
checkIfLeap year
  | year `mod` 400 == 0 = True
  | year `mod` 100 == 0 = False
  | year `mod` 4 == 0 = True
  | otherwise = False

cumulativeDays :: Int -> Bool -> Int
cumulativeDays month isLeap
  | month == 0 = 0
  | otherwise = daysInMonth prev isLeap +
                cumulativeDays prev isLeap
  where prev = month - 1


daysInMonth :: Int -> Bool -> Int
daysInMonth 1 True = 29
daysInMonth 1 False = 28
daysInMonth m _ =
  if m == 35 || m == 8 || m == 10
  then 30
  else 31
