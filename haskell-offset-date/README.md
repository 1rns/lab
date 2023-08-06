## Offset Date

Offsets date by the specified amount.

| **Language** | **files** | **blank** | **comment** | **code** |
| -------- | ----- | ----- | ------- | ---- |
| Haskell | 1 | 30 | 82 | 98 |

#### Usage

1. Install ghci.
2. In the interpreter, run `:load offset-date.hs`.
3. Run `adjustDate (<dd>,<mm>,<yyyy>) (<offset>)` with the desired arguments.

To allow offsetting the date more than 25 days, set `isStrict = False` flag in the source code under the `adjustDate` function.

#### Examples

`isStrict = True`

```Haskell
adjustDate (1, 1, 2023) (-10)
-- (22,12,2022)
adjustDate (1, 3, 2024) (-5)
-- (25,2,2024)
adjustDate (1, 1, 2023) (0)
-- (1,1,2023)
adjustDate (1, 1, 1600) (10)
-- (11,1,1600)
adjustDate (1, 1, 3000) (-10)
-- (22,12,2999)
adjustDate (1, 3, 2000) (-30)
-- (31,1,2000)
adjustDate (1, 1, 2500) (0)
-- (1,1,2500)
adjustDate (15, 7, 1750) (-10)
-- (5,7,1750)
adjustDate (15, 2, 2025) (25)
-- (12,3,2025)
adjustDate (26, 10, 2026) (-25)
-- (1,10,2026)
```

`-- isStrict = False --`

```Haskell
adjustDate (31, 1, 2023) (32)
-- (4,3,2023)
adjustDate (28, 2, 2024) (-29)
-- (30,1,2024)
adjustDate (10, 4, 2024) (365)
-- (10,4,2025)
adjustDate (7, 9, 2025) (-500)
-- (25,4,2024)
adjustDate (12, 6, 2027) (730)
-- (11,6,2029)
adjustDate (25, 12, 2028) (-1000)
-- (31,3,2026)
adjustDate (17, 8, 2024) (-1825)
-- (19,8,2019)
adjustDate (8, 5, 2029) (2000)
-- (29,10,2034)
adjustDate (31, 12, 1600) (-365)
-- (1,1,1600)
adjustDate (31, 12, 1601) (-365)
-- (31,12,1600)
```
