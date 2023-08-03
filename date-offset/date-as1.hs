adjust_date :: (Int, Int, Int) -> Int -> (Int, Int, Int)
adjust_date (day, month, year) offset =
  if (checkValidDate (day, month, year)) then
    addDaysToDate (day, month, year) offset
  else
    error ""

addDaysToDate :: (Int, Int, Int) Int -> (Int, Int, Int)
addDaysToDate (day, month, year) offset
  | offset == 0 = (day, month, year)
  | totalDays > 365 || totalDays < 0 =
      let finalDays, finalYear = 
  | otherwise = daysOfYearToDate totalDays year
  where
    totalDays = dateToDaysOfYear (day, month, year) + offset
    
checkValidDate :: (Int, Int, Int) -> Bool
checkValidDate (date, month, year)

daysOfYearToDate :: Int -> (Int, Int, Int)


dateToDaysOfYear :: (Int, Int, Int) -> Int
dateToDaysOfYear day month year =
  day + cumulativeDays (month - 1) (checkIfLeap year)

checkIfLeap :: Int -> Bool
checkIfLeap year
  | year mod 400 == 0 = True
  | year mod 100 == 0 = False
  | year mod 4 == 0 = True
  | otherwise = False

cumulativeDays :: Int -> Bool -> Int
cumulativeDays month isLeap
  | month == 0 = 0
  | otherwise = daysInMonth (month - 1) isLeap +
                cumulativeDays (n - 1) isLeap

daysInMonth :: Int -> Bool -> Int
daysInMonth 0,2,4,6,7,9,11 _ = 31
daysInMonth 3,5,8,10 _ = 30
daysInMonth 1 isLeap
  | isLeap = 29
  | otherwise = 28