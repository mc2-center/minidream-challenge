FROM rocker/tidyverse:4.0.5

RUN R -e 'install.packages("argparse")'

WORKDIR /

COPY R/score.R .
COPY modules .
COPY data .
COPY minidream-challenge-2018.Rproj .
COPY modules/module0/.eval/eval_fxn.R modules/module0/.eval/eval_fxn.R
COPY modules/module1/.eval/eval_fxn.R modules/module1/.eval/eval_fxn.R
COPY modules/module2/.eval/eval_fxn.R modules/module2/.eval/eval_fxn.R
COPY modules/module3/.eval/eval_fxn.R modules/module3/.eval/eval_fxn.R
COPY modules/module4/.eval/eval_fxn.R modules/module4/.eval/eval_fxn.R
COPY modules/module5/.eval/eval_fxn.R modules/module5/.eval/eval_fxn.R
COPY modules/module6/.eval/eval_fxn.R modules/module6/.eval/eval_fxn.R
COPY modules/module7/.eval/eval_fxn.R modules/module7/.eval/eval_fxn.R
