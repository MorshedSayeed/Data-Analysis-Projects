
## Personal Finance Data Analysis Project

### Data Analysis Using Power BI

1. Calculate total income

`Total Income = CALCULATE(SUM(FinData[Value]), FinData[Type] = "Income")`

3. Calculate total savings

`Total Saving = CALCULATE(SUM(FinData[Value]), FinData[Type] = "Savings")`

4. Calculate total expenses

`Total Expense = CALCULATE(SUM(FinData[Value]), FinData[Type] = "Expense")`

5. Percentage of income change month-on-month

`Income change MoM % = DIVIDE([Total Income], [Income LY])`

6. Last year income

`Income LY = CALCULATE([Total Income], DATEADD(FinData[Date], -1, MONTH))`

7. Calculate Cumulative net worth

`Cumulative net worth = CALCULATE (
    [Total Saving],
    FILTER (
        ALL ( FinData[Date]),
        FinData[Date] <= MAX ( FinData[Date] )
    )
)`


## Power BI Dashboard screenshots

![personal_finance-1](https://user-images.githubusercontent.com/78271544/180887443-17619444-fe05-4d7a-bd40-b407c4e0f11d.png)


##

![personal_finance-2](https://user-images.githubusercontent.com/78271544/180887466-2f37146e-37e2-450d-8445-b45244d4aa10.png)

##

![personal_finance-3](https://user-images.githubusercontent.com/78271544/180887494-2fd3c1a6-90f4-4e27-9c28-ef7fc387ee02.png)



