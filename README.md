
dhms
====

<!-- [![Travis-CI Build Status](https://travis-ci.org/tidyverse/hms.svg?branch=master)](https://travis-ci.org/tidyverse/hms) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/tidyverse/hms?branch=master&svg=true)](https://ci.appveyor.com/project/tidyverse/hms) [![Coverage Status](https://img.shields.io/codecov/c/github/tidyverse/hms/master.svg)](https://codecov.io/github/tidyverse/hms?branch=master) [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/hms)](https://cran.r-project.org/package=hms) -->
A simple class for storing durations values and displaying them in the `Dd HH:MM:SS` format. The implementation is exhaustivelly based on the very kneat [hms class](https://github.com/tidyverse/hms). Intended to facilitate representation and manipulations of duration in the context of ethological expriments.

The values are stored as a numeric vector a number of seconds. Implicitly, either since the onset of the experiment, or [ZT0](https://en.wikipedia.org/wiki/Zeitgeber) on the reference day. used in a data frame.

``` r
library(hms)
library(dhms)
```

<table style="width:94%;">
<colgroup>
<col width="31%" />
<col width="33%" />
<col width="29%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">function</th>
<th align="right">hms</th>
<th align="left">dhms</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><code>as.character()</code></td>
<td align="right"><code>hms(56, 34, 12, 2)</code> =&gt; 60:34:56</td>
<td align="left"><code>dhms(56, 34, 12, 2)</code> =&gt; 2d 12:34:56</td>
</tr>
</tbody>
</table>
