import plotly.plotly as py
import plotly.graph_objs as go 
import csv
from dateutil import parser
from datetime import datetime

with open('gluPredict(15min).csv', 'rU') as csvfile:
	datareader = list(csv.reader(csvfile, delimiter=','))
	time=[parser.parse(i[0]) for i in datareader[::]]
	Glucose=[i[2] for i in datareader[::]]
GlucosePredict=[i[1] for i in datareader[::]]

trace0 = go.Scatter(
    x=time,
	y=Glucose,
	name = 'Glucose Value'
)

trace1 = go.Scatter(
	x=time,
	y=[70]*len(time),
	name='Low Bond'
)

trace2 = go.Scatter(
	x=time,
	y=[180]*len(time),
	name='High Bond'
)

trace3 = go.Scatter(
    x=time,
    y=GlucosePredict,
    name='Predict Value'
)
data = [trace0,trace1,trace2,trace3]
layout = dict(
    title='Time series with range slider and selectors',
    xaxis=dict(
    	title = 'Time (YYYY-MM-DD hh:mm:ss)',
        rangeselector=dict(
            buttons=list([
            	dict(
                    count=1,
                    label='1h',
                    step='hour',
                    stepmode='backward'
                ),
            	dict(
                    count=1,
                    label='1d',
                    step='day',
                    stepmode='backward'
                ),
                dict(
					count=7,
					label='1w',
					step='day',
					stepmode='backward'
                ),
                dict(
					count=1,
					label='1m',
					step='month',
					stepmode='backward'
                ),
                dict(
                	count=1,
                    label='YTD',
                    step='year',
                    stepmode='todate'
                ),
                dict(
                	count=1,
                    label='1y',
                    step='year',
                    stepmode='backward'
                ),
                dict(
                	step='all'
                )
            ])
        ),
        rangeslider=dict(),
        type='date'
    ),
    yaxis=dict(
    	title = 'Glucose Value (mg/dL)'
    )
)
fig = dict(data=data, layout=layout)
py.iplot(fig, filename = 'time-series-ka')