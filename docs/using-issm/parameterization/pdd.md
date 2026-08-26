---
title: PDD
layout: default
parent: Parameterization
math: mathjax3
---

# Positive Degree Day (PDD)

## Physical basis
### Positive degree day method
A standard positive degree day (PDD) method is used to compute the surface mass balance (ice ablation and accumulation) from the temperature and precipitation fields. The hourly temperatures are assumed to have a normal distribution, of standard deviation $$\sigma_{PDD} = 5.5\,^{\circ}\mathrm{C}$$, around the monthly mean (T$$_m$$). The number of days for which the temperature is above $$0\,^{\circ}\mathrm{C}$$ in a year is computed as follows:

$$
\text{PDD} =\frac{1}{\sigma_{PDD}\sqrt{2\pi}}\int_{0}^{1year}\int_{0\,^{\circ}\mathrm{C}}^{T_m+2.5\sigma_{PDD}}T exp\left[\frac{-(T-T_m)^2}{2\sigma_{PDD}^2} \right] \;dT\,dt
$$
The amount of snow and ice that melts is assumed to be proportional to the number of positive degree days. Snow is melted first and the remaining positive degree days are used to melt ice. A dependence to the mean June/July/August temperature ($$T_{jja}$$) is added to get the ablation rate factor for snow ($$\gamma_{snow}$$) and ice ($$\gamma_{ice}$$):

$$
\begin{array}{ccc}\gamma_{\text{ice }} = &\begin{cases}\text{17.22 mm/PDD}                                                     & T_{jja} \le -1\,^{\circ}\mathrm{C},\\\text{0.0067} \times \text{(10-}T_{jja}\text{ )}^3\text{ + 8.3 mm/PDD}  & -1\,^{\circ}\mathrm{C} < T_{jja} < 10\,^{\circ}\mathrm{C},\\\text{8.3 mm/PDD}                                                       & 10\,^{\circ}\mathrm{C} \le T_{jja}\end{cases}\\ \text{and} \\\gamma_{\text{snow }}=&\begin{cases}\text{2.65 mm/PDD}  &                              T_{jja}  \le -1\,^{\circ}\mathrm{C},\\\text{0.15} \times T_{jja} \text{+ 2.8 mm/PDD}\hphantom{mm/PDD}  &         -1\,^{\circ}\mathrm{C} < T_{jja} < 10\,^{\circ}\mathrm{C},\\\text{4.3 mm/PDD}  &                               10\,^{\circ}\mathrm{C} \le T_{jja}\end{cases}\end{array}
$$

A fraction of the melted snow is refrozen. The amount of superimposed ice for a year is:

$$
\text{superimposed ice =}\begin{cases}\text{min[Pr + M, 2.2} \times \text{(Ps - M) - d} \times \text{ci /L} \times \text{min(Tsurf , 0}\,^{\circ}\mathrm{C}\text{)]} & \text{M }<\text{ Ps ,}\\\text{min[Pr + M, d }\times \text{ci /L} \times \text{min(Tsurf , }\,^{\circ}\mathrm{C}\text{)]} & \text{M }>\text{ Ps}\end{cases}
$$
where:

- $$Pr$$ is the rainfall in a year
- $$Ps$$ is the snow fall in a year
- $$M$$ is the snow melt in a year
- $$2.2$$ is the capillarity factor
- $$d$$ is the active thermodynamic layer (set to 1 m)
- $$ci$$ is the ice specific heat capacity (152.5 + 7.122T $$Jkg^{-1} K^{-1}$$)
- $$L$$ is the latent heat fusion (3.35 $$\times 10^{5}$$ $$Jkg^{-1}$$)
- $$Tsurf$$ is the surface temperature

A normal distribution of the hourly temperature is also assumed to compute the amount of snow accumulation from the precipitation. A lower standard deviation $$\sigma_{RS} = \sigma_{PDD}-0.5$$ is assumed in that case to take into account the smaller temperature variability during cloudy days. Precipitation is considered to be snow when the temperature is below 0$$\,^{\circ}\mathrm{C}$$.

$$
\frac{\text{accumulation}}{\text{precipitation}} =\frac{\rho_i}{\rho_w\sigma_{RS}\sqrt{2\pi}}\int_0^{1year}\int_{T_m-2.5\sigma_{RS}}^{0\,^{\circ}\mathrm{C}}exp\left[\frac{-(T-T_m)^2}{2\sigma_{RS}^2} \right] dTdt
$$

### Temperature and precipitation forcing (Under development)
If precipitation comes from another elevation than the surface elevation of the ice, it can be adjusted to take into account the elevation desertification effect.

If the forcing temperatures are provided for a constant altitude, a lapse rate of 6.5$$^\circ$$/km is used to adjust them to the surface elevation of each step.

## Model parameters
The parameters relevant to the positive degree day and $$\delta^{18}O$$ parameterization methods can be displayed by typing:

The lapse rate is computed as a weighted mean of the present-day ($$rlaps$$) and LGM ($$rlapslgm$$) lapse rate as:

$$
rtlaps=TdiffTime*rlapslgm + \left(1.-TdiffTime\right)*rlaps
$$
where `TdiffTime` is the time interpolation parameter (`Tdiff`) at the integration time.

The surface temperature ($$Tsurf$$) is the yearly average temperature computed from the monthly temperature tstar. tstar is computed as the present-day temperature plus the temperature difference, $$tdiffh$$, between LGM and present day:

$$
tstar = tdiffh + TemperaturesPresentday[imonth] - rtlaps \times \max{st,sealev \times 0.001};
$$
st is the difference between the surface elevation and the elevation from temperature source:

$$
st=(s-s0t)/1000
$$
and tdiffh is the weighted mean between the present-day and LGM temperature:

$$
tdiffh = TdiffTime \times ( TemperaturesLgm[imonth] - TemperaturesPresentday[imonth] )
$$

````
>> md.smb
````


- `isdelta18o`: whether temperature and precipitation delta18o parameterization is activated (0 or 1, default is 0)
- `desfac`: desertification elevation factor (between 0 and 1, default is 0.5) (m)
- `s0p`: should be set to elevation from precipitation source (between 0 and a few 1000s m, default is 0) (m)
- `s0t`: should be set to elevation from temperature source (between 0 and a few 1000s m, default is 0) [m]
- `rlaps`: present-day lapse rate (degree/km)
- `rlapslgm`: LGM lapse rate (degree/km)
- `Pfac`: time interpolation parameter for precipitation, 1D (year)
- `Tdiff`: time interpolation parameter for temperature, 1D (year)
- `sealev`: sea level (m)
- `monthlytemperatures`: monthly surface temperatures (K), required if PDD is activated and delta18o not activated
- `precipitation`: surface precipitation (m/yr water eq)
- `temperatures_presentday`: monthly present-day surface temperatures (K), required if PDD is activated and delta18o activated
- `temperatures_lgm`: monthly LGM surface temperatures (K), required if PDD is activated and delta18o activated
- `precipitations_presentday`: monthly surface precipitation (m/yr water eq), required if PDD is activated and delta18o activated
- `delta18o`: delta18o, required if PDD is activated and delta18o activated
- `delta18o_surface`: surface elevation of the delta18o site, required if PDD is activated and delta18o activated

## Running a simulation
To turn this module on in a simulation, use the following command:
````
>> md.smb = SMBpdd();
````

