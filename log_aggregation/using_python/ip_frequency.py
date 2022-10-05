#!/usr/bin/python

import dask.dataframe as dd
from datetime import datetime
import pytz


def parse_datetime(x):
    '''
    Parses datetime with timezone formatted as:
        `[day/month/year:hour:minute:second zone]`

    Example:
        `>>> parse_datetime('13/Nov/2015:11:45:42 +0000')`
        `datetime.datetime(2015, 11, 3, 11, 45, 4, tzinfo=<UTC>)`

    Due to problems parsing the timezone (`%z`) with `datetime.strptime`, the
    timezone will be obtained using the `pytz` library.
    '''
    dt = datetime.strptime(x[1:-7], '%d/%b/%Y:%H:%M:%S')
    dt_tz = int(x[-6:-3])*60+int(x[-3:-1])
    return dt.replace(tzinfo=pytz.FixedOffset(dt_tz))


#after testing replace StringIO(temp) to filename
# df = pd.read_csv('access.log', delimiter=r"\s+", header=None, names=['timestamp','ip_address', 'path', 'http_verb', 'user_agent'], engine='python')
# df = dd.read_csv('access.log', blocksize=25e6, delimiter=r"\s+", header=None, names=['Time','IP'], engine='python')
# print(df.head())


data = dd.read_csv(
    'access.log',
    sep=r'\s(?=(?:[^"]*"[^"]*")*[^"]*$)(?![^\[]*\])',
    engine='python',
    na_values='-',
    header=None,
    usecols=[0, 1, 2, 3, 4],
    names=['time', 'ip', 'path', 'http_verb', 'user_agent'],
    converters={'time': parse_datetime,
                'ip': str,
                'path': str,
                'http_verb': str,
                'user_agent': str})

# print(data[['ip']].head())
# grouped_data = data.groupby(['ip']).ip.apply(lambda x: x.value_counts()).compute()
grouped_data = data.groupby(['ip'], sort=True).ip.apply(lambda x: x.value_counts(), meta=('x', 'f8')).compute()
print(grouped_data.head())
