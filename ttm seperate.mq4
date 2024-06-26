//+------------------------------------------------------------------+
//|                                                 TTM_Separate.mq4 |
//|                                                       Hamoon     |
//+------------------------------------------------------------------+
#property copyright "Hamoon"
#property link      ""
#property description "Separate indicator window for TTM indicator"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots 1
#property indicator_label1 "TTM_State"
#property indicator_type1 DRAW_LINE
#property indicator_color1 clrBlue
#property indicator_style1 STYLE_SOLID
#property indicator_width1 2

input int TTMperiod = 6; // TTM period

double TTMStateBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    SetIndexBuffer(0, TTMStateBuffer, INDICATOR_DATA);
    IndicatorShortName("TTM_State");
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    int limit = rates_total - prev_calculated;
    if(limit > 0)
    {
        for(int i = limit - 1; i >= 0; i--)
        {
            double Low_ma = iMA(NULL, 0, TTMperiod, 0, MODE_EMA, PRICE_LOW, rates_total - i - 1);
            double High_ma = iMA(NULL, 0, TTMperiod, 0, MODE_EMA, PRICE_HIGH, rates_total - i - 1);
            double Low_third = (High_ma - Low_ma) / 3 + Low_ma;
            double High_third = 2 * (High_ma - Low_ma) / 3 + Low_ma;

            if(close[rates_total - i - 1] > High_third)
                TTMStateBuffer[rates_total - i - 1] = 1;
            else if(close[rates_total - i - 1] < Low_third)
                TTMStateBuffer[rates_total - i - 1] = 0;
            else
                TTMStateBuffer[rates_total - i - 1] = TTMStateBuffer[rates_total - i];
        }
    }

    return(rates_total);
}
//+------------------------------------------------------------------+