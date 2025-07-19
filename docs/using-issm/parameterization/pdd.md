---
title: Positive Degree Day (PDD)
layout: default
parent: Parameterization
---

## Positive Degree Day (PDD)

### Physical basis
#### Positive degree day method
A standard positive degree day (PDD) method is used to compute the surface masse balance (ice ablation and accumulation) from the temperature and precipitation fields. The hourly temperatures are assumed to have a normal distribution, of standard deviation <img src="https://latex.codecogs.com/svg.latex?\sigma_{PDD} = 5.5\,^{\circ}\mathrm{C}" alt="Equation 3">, around the monthly mean (T<img src="https://latex.codecogs.com/svg.latex?_m" alt="Equation 2">). The number of days for which the temperature is above <img src="https://latex.codecogs.com/svg.latex?0\,^{\circ}\mathrm{C}" alt="Equation 1"> in a year is computed as follows:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\text{PDD} =\frac{1}{\sigma_{PDD}\sqrt{2\pi}}\int_{0}^{1year}\int_{0\,^{\circ}\mathrm{C}}^{T_m+2.5\sigma_{PDD}}T exp\left[\frac{-(T-T_m)^2}{2\sigma_{PDD}^2} \right] \;dT\,dt" alt="Equation 4"></div>
The amount of snow and ice that melts is assumed to be proportional to the number of positive degree days. Snow is melted first and the remaining positive degree days are used to melt ice. A dependence to the mean June/July/August temperature (<img src="https://latex.codecogs.com/svg.latex?T_{jja}" alt="Equation 7">) is added to get the ablation rate factor for snow (<img src="https://latex.codecogs.com/svg.latex?\gamma_{snow}" alt="Equation 6">) and ice (<img src="https://latex.codecogs.com/svg.latex?\gamma_{ice}" alt="Equation 5">):

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\begin{array}{ccc}\gamma_{\text{ice }} = &\begin{cases}\text{17.22 mm/PDD}                                                     & T_{jja} \le -1\,^{\circ}\mathrm{C},\\\text{0.0067} \times \text{(10-}T_{jja}\text{ )}^3\text{ + 8.3 mm/PDD}  & -1\,^{\circ}\mathrm{C} < T_{jja} < 10\,^{\circ}\mathrm{C},\\\text{8.3 mm/PDD}                                                       & 10\,^{\circ}\mathrm{C} \le T_{jja}\end{cases}\\ \text{and} \\\gamma_{\text{snow }}=&\begin{cases}\text{2.65 mm/PDD}  &                              T_{jja}  \le -1\,^{\circ}\mathrm{C},\\\text{0.15} \times T_{jja} \text{+ 2.8 mm/PDD}\hphantom{mm/PDD}  &         -1\,^{\circ}\mathrm{C} < T_{jja} < 10\,^{\circ}\mathrm{C},\\\text{4.3 mm/PDD}  &                               10\,^{\circ}\mathrm{C} \le T_{jja}\end{cases}\end{array}" alt="Equation 8"></div>

A fraction of the melted snow is refrozen. The amount of superimposed ice for a year is:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\text{superimposed ice =}\begin{cases}\text{min[Pr + M, 2.2} \times \text{(Ps - M) - d} \times \text{ci /L} \times \text{min(Tsurf , 0}\,^{\circ}\mathrm{C}\text{)]} & \text{M }<\text{ Ps ,}\\\text{min[Pr + M, d }\times \text{ci /L} \times \text{min(Tsurf , }\,^{\circ}\mathrm{C}\text{)]} & \text{M }>\text{ Ps}\end{cases}" alt="Equation 9"></div>
where:

- <img src="https://latex.codecogs.com/svg.latex?Pr" alt="Equation 10"> is the rainfall in a year
- <img src="https://latex.codecogs.com/svg.latex?Ps" alt="Equation 11"> is the snow fall in a year
- <img src="https://latex.codecogs.com/svg.latex?M" alt="Equation 12"> is the snow melt in a year
- <img src="https://latex.codecogs.com/svg.latex?2.2" alt="Equation 13"> is the capillarity factor
- <img src="https://latex.codecogs.com/svg.latex?d" alt="Equation 14"> is the active thermodynamic layer (set to 1 m)
- <img src="https://latex.codecogs.com/svg.latex?c i" alt="Equation 16"> is the ice specific heat capacity (152.5 + 7.122T <img src="https://latex.codecogs.com/svg.latex?Jkg^{-1} K^{-1}" alt="Equation 15">)
- <img src="https://latex.codecogs.com/svg.latex?L" alt="Equation 20"> is the latent heat fusion (3.35 <img src="https://latex.codecogs.com/svg.latex?\times" alt="Equation 19"> <img src="https://latex.codecogs.com/svg.latex?10^{5}" alt="Equation 18"> <img src="https://latex.codecogs.com/svg.latex?Jkg^{-1}" alt="Equation 17">)
- <img src="https://latex.codecogs.com/svg.latex?Tsurf" alt="Equation 21"> is the surface temperature

A normal distribution of the hourly temperature is also assumed to compute the amount of snow accumulation from the precipitation. A lower standard deviation <img src="https://latex.codecogs.com/svg.latex?\sigma_{RS} = \sigma_{PDD}-0.5" alt="Equation 23"> is assumed in that case to take into account the smaller temperature variability during cloudy days. Precipitation is considered to be snow when the temperature is below 0<img src="https://latex.codecogs.com/svg.latex?\,^{\circ}\mathrm{C}" alt="Equation 22">.

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
\frac{\text{accumulation}}{\text{precipitation}} =\frac{\rho_i}{\rho_w\sigma_{RS}\sqrt{2\pi}}\int_0^{1year}\int_{T_m-2.5\sigma_{RS}}^{0\,^{\circ}\mathrm{C}}exp\left[\frac{-(T-T_m)^2}{2\sigma_{RS}^2} \right] dTdt" alt="Equation 24"></div>

#### Temperature and precipitation forcing (Under development)
If precipitations come from another elevation than the surface elevation of the ice, it can be adjusted to take into account the elevation desertification effect.

If the forcing temperatures are provided for a constant altitude, a lapse rate of 6.5<img src="https://latex.codecogs.com/svg.latex?^\circ" alt="Equation 25">/km is used to adjust them to the surface elevation of each step.

### Model parameters
The parameters relevant to the positive degree day and <img src="https://latex.codecogs.com/svg.latex?\delta^{18}O" alt="Equation 28"> parameterization methods can be displayed by typing: The lapse rate is computed as an weighted mean of the present day (<img src="https://latex.codecogs.com/svg.latex?rlaps" alt="Equation 27">) and LGM (<img src="https://latex.codecogs.com/svg.latex?rlapslgm" alt="Equation 26">) lapse rate as:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
rtlaps=TdiffTime*rlapslgm + \left(1.-TdiffTime\right)*rlaps" alt="Equation 29"></div>
where `TdiffTime` is the time interpolation parameter (`Tdiff`) at the integration time.

The surface temperature (<img src="https://latex.codecogs.com/svg.latex?Tsurf" alt="Equation 31">) is the yearly average temperature computed from the monthly temperature tstar. tstar is computed as the present day temperature plus the temperature difference, <img src="https://latex.codecogs.com/svg.latex?tdiffh" alt="Equation 30">, between LGM and present day:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
tstar = tdiffh + TemperaturesPresentday[imonth] - rtlaps \times \max{st,sealev \times 0.001};" alt="Equation 32"></div>
st is the difference between the surface elevation and the elevation from temperature source:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
st=(s-s0t)/1000" alt="Equation 33"></div>
and tdiffh is the weighted mean between the present day and lgm temperature:

<div align="center"><img src="https://latex.codecogs.com/svg.latex?
tdiffh = TdiffTime \times ( TemperaturesLgm[imonth] - TemperaturesPresentday[imonth] )" alt="Equation 34"></div>

````
>> md.smb
````


- `isdelta18o`:  is temperature and precipitation delta18o parameterization activated (0 or 1, default is 0)
- `desfac`:  desertification elevation factor (between 0 and 1, default is 0.5) (m)
- `s0p`:  should be set to elevation from precipitation source (between 0 and a few 1000s m, default is 0) (m)
- `s0t`:   should be set to elevation from temperature source (between 0 and a few 1000s m, default is 0) [m]
- `rlaps`:  present day lapse rate (degree/km)
- `rlapslgm`: LGM lapse rate (degree/km)
- `Pfac`:  time interpolation parameter for precipitation, 1D (year)
- `Tdiff`: time interpolation parameter for temperature, 1D (year)
- `sealev`:  sea level (m)
- `monthlytemperatures`:  monthly surface temperatures (K), required if pdd is activated and delta18o not activated
- `precipitation`:  surface precipitation (m/yr water eq)
- `temperatures_presentday`:  monthly present day surface temperatures (K), required if pdd is activated and delta18o activated
- `temperatures_lgm`:  monthly LGM surface temperatures (K), required if pdd is activated and delta18o activated
- `precipitations_presentday`:  monthly surface precipitation (m/yr water eq), required if pdd is activated and delta18o activated
- `delta18o`:  delta18o, required if pdd is activated and delta18o activated
- `delta18o_surface`:  surface elevation of the delta18o site, required if pdd is activated and delta18o activated

### Running a simulation
To turn this module on in a simulation, use the following command:
````
>> md.smb = SMBpdd();
````

