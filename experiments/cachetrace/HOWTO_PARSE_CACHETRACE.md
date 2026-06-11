```python
import pandas as pd
import numpy as np
import matplotlib.pylab as plt
import matplotlib
```


```python
df = pd.read_csv('cluster10.sort', sep=',', 
                  names=['timestamp', 'key', 'key_size', 'value_size', 'client_id', 'op', 'ttl'])
```


```python
df.columns
```




    Index(['timestamp', 'key', 'key_size', 'value_size', 'client_id', 'op', 'ttl'], dtype='object')




```python
vcs = df.timestamp.value_counts().sort_index(ascending=True)
```


```python
vcs
```




    timestamp
    0         166
    1         256
    2         234
    3         283
    4         231
             ... 
    617065    122
    617066    141
    617067    144
    617068    134
    617069     53
    Name: count, Length: 616740, dtype: int64




```python
xx = vcs.index.tolist()
yy = vcs.tolist()
```


```python
fig, ax = plt.subplots()
ax.errorbar(xx, yy, capsize=3, fmt="r--o", ecolor = "black")
ax.set_xlabel("Time (seconds)", fontsize=20)
ax.set_ylabel("Num Requests", fontsize=20)
ax.set_title(f"Twitter cache-trace cluster10.sort", size=22)

plt.grid()
plt.tight_layout()
```


    
![png](output_6_0.png)
    



```python
print(type(xx), len(xx))
print(type(yy), len(yy))
```

    <class 'list'> 616740
    <class 'list'> 616740



```python
with open("cluster10.rps.txt", "a") as f:
    for i in range(len(xx)):
        f.write(f"{xx[i]},{yy[i]}\n")
```


```python

```
