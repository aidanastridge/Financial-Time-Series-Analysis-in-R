
![house_price_index_logo](https://user-images.githubusercontent.com/115724380/202934704-454ef675-2cf4-406f-af6b-12faadd15071.svg)

### Executive Summary 

This project aims to perform a time series analysis of the Montreal House Price Index from 1990 to 2017. We will explain the structure of the data and derive a convenient model to handle this data and make an accurate forecast. Many models can be used to deal with these data, but our choice is guided by considering the parsimonious Principe and the smallest AIC. 

### Introduction 

The data is from the [Teranet and National Bank of Canada](http://www.housepriceindex.ca/), these two companies devote themselves to give an independent rate of change of the Canadian single-family home-price. First, I will comment on the structure of this data, that is trend, seasonality, randomness though different plot (scatter plot, month plot, PACF and ACF) and different test. This part will to answer the question: “can the data become stationary?” Then we will perform transformations, in our case logarithmic and differencing, to convert the data into a stationary one. Then I continued by studying different ARIMA models for the data and make our choice based on AIC and the parsimonious principle. Then this model will be fitted to see the different coefficients and deriving the equation of our model. An important step will be the outcome of the sample forecasting that I will perform. At the last step, we will validate our model by an accuracy study. 

### Data Description 

Spanning July 1990 to February 2017, the Teranet-National Bank House Price Index measures the observed house prices of Montreal, Quebec. 

Montreal’s House Price Index measures the registered prices of houses over time. All properties have been sold at least twice; The latter is done to observe a linear change in value for the property between two sales. Even meeting the prior assumption, each house must also pass the endogenous checklist: 

* Non-arm's-length sales – no personal or professional relationship must be found between buyer and seller
* Renovations or any major changes to the property 
* Data error
* High-turnover frequency

Weighted Sales Pairs: The weighted sales pairs are the most challenging of calculations found within the index. Significant assumptions must be made: Not every sales pair should contribute the same to the index price. A popular method of attributing weight is taking the percentage-change in price, modelling the latter as a distribution (histogram) and taking those weights – the pairs with similar percentage changes in price are associated with their weight, and therefore placed either higher or lower in importance for the index calculation.

### Methodology

Defined as repeat sales methodology, a property must have been sold twice to be considered for the index. After passing the endogenous checklist, the estimation of the index is calculated by casting all qualified paired values through a linear regression algorithm.

### Final Model

Regression with Residuals ARIMA(3,0,1)

### Analysis

* ACF
* PACF
* Ljung-Box Test
* ARIMA
* Forecast

### Source

[Teranet and National Bank of Canada](http://www.housepriceindex.ca/)
