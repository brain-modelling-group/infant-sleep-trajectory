# infant-sleep-trajectory

Example code used in *Mapping the physiological changes in sleep regulation across infancy and young childhood*, Webb et al. (2023).

## Code

Sleep_Model_PRF.m is the main file, which implements the combined Phillips and Robinson-Forger model of the sleep/wake switch, sleep homeostatic process, and circadian pacemaker.

Sleep_Model_PRF.m defines the model parameter values *p*, then calls the model via Run_prf_2023.m for a set time *T*. Run_prf_2023.m runs the model for 4 weeks as a warm up to remove any transients, the using the last model state as the initial value solves for time *T*, and extracts the last 2 weeks of the model output. The model is called via phillips_forger_model_2023.m, which also calls light_func.m and sigmoid.m.

The Matlab function Get_sleep_results_2023.m calculates a number of sleep behaviour summary measurements, including the probability of being asleep per 30 minute window for the last 7 days of the model produced time series. 

The R function cost_func_mtrx in cost_func_mtrx.R calculates the cost function value (Equation 13 of Webb et al. (2023)) for provided model produced sleep probabilities with a single set of sleep probability data. 

## Data 

The sleep-wake time series from the four datasets (Figure 2 Webb et al (2023)) are provided in *data/sleep-wake-data*, and the sleep probabilities used for the cost function and model fitting are provided in *data/sleep-prob-data*.

All four datasets are in public domain: Dataset 1 (Github repository https://github.com/jiuguangw/Agenoria, commit be11a8e on 30/12/2021, used for academic purposes under CC BY-NC-SA 4.0), Dataset 2 (Github repository https://github.com/jitney86/Baby-data-viz, commit d92043f on 11/8/2017, used for academic purposes under MIT license), Dataset 3 (Infant #01 in Figure 1 of Jenni et al. (2006) *Infant Behavior and Development*, 29(2):143-52), and Dataset 4 (Figure 3 of McGraw et al. (1999) *Sleep* 22:303-310). 