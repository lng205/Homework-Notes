# 复分析复习总结

实数集是复数集的子集，复分析定理可用于实分析。复分析的一些定理与实分析形式相似，而一些证明又需要对实虚部二元实函应用实分析定理。

拉氏变换是信号和系统分析的重要工具，其逆变换可用留数定理计算。留数定理的证明涉及复分析的多个重要理论。

本文先试推导留数定理，引出主要定义和公式。

## 留数定理

- 扩充复平面内留数和为0

$$\sum\limits _{k=1}^nRes[f,z_k]=0$$

<br><br>

## 复数

- 设**有理数**的概念抽象自自然界，并由幂运算扩充为**实数**。

- 将实数单位的负值开根定义为复数单位，构成**复数**。

$$\sqrt{-1}=i,\ z = x+yi.\quad x,\ y\in \mathbb R, \quad z\in\mathbb C$$

## 函数

- **映射**为集合中元素的对应关系。单射表示一个元素只映射到一个元素。

- **函数**为数集到数集的单射。

$$f(z)=u(z)+iv(z),\quad f:\mathbb C \to\mathbb C,\quad u,v\in\mathbb R$$

- **数列**为定义域为整数集的函数。

$$a_1,a_2\dots,a_n,\quad a:\mathbb Z \to \mathbb C$$

## 极限

- 函数的在某点的极限为，值域内极限值的任意邻域，均对应于定义域内该点某去心邻域。

$$\lim_{z\to z_0}=f(z_0)\quad\equiv\quad\forall \epsilon>0,\ \exists \delta,\quad |z-z_0|<\delta\Rightarrow|f(z)-f(z_0)|<\epsilon$$

## 导数

- 函数在一点的导数为，该点函数增量与自变量增量的比，在增量为零处的极限。

$$f'(z_0)=\frac{df}{dz}|_{z=z_0}\equiv \lim_{\Delta z \to 0}\frac{f(z_0+\Delta z)-f(z_0)}{\Delta z}$$

- 函数在一点解析表示，函数在该点及某邻域内可导。

## 微分

- 函数在一点为无穷小表示极限为0.

- 一无穷小为另一无穷小的高阶无穷小，表示比值为无穷小。

$$\alpha=o(\beta)\quad\equiv\quad\frac\alpha\beta\to0$$

- 函数在一点的微分为，该点函数增量与自变量增量的一阶线性等价关系。

$$df=f'dz+o(dz)$$

## 复数的指数表示

$$\begin{align}
z=|z|e^{iArgz}&=\sqrt {x^2+y^2}e^{i\tan^{-1}\frac yx}\\
&=\sqrt{x^2+y^2}(\cos(\tan^{-1}\frac yx)+\sin(\tan^{-1}\frac yx)i)\\
&=x+yi
\end{align}$$

(2)为欧拉公式，证明此公式需要用到一些实函定理。

### 微分中值定理

- （内部可导的闭区间）两端实函数差之比等于中间某点的导数之比。

$$\frac{f(b)-f(a)}{g(b)-g(a)}=\frac{f'(\theta)}{g'(\theta)},\ \theta\in(a,b)$$

端点处等值则区间内存在零点，称为罗尔定理。构造函数，使上式满足罗尔定理条件，可证。

### 洛必达定理

- 实函极小值之比等于导数之比。

定义所求点值为零，不影响极限。则

$$\lim_{x\to x_0}\frac {f(x)}{g(x)}=\lim_{x\to 0}\frac{f(x)-f(x_0)}{g(x)-g(x_0)}=\lim_{\theta\to 0}\frac{f'(\theta)}{g'(\theta)}$$

## 柯西-黎曼(Cauchy-Riemann)条件

$$\frac{\partial u}{\partial x}=\frac{\partial v}{\partial y},\quad
\frac{\partial u}{\partial y}=-\frac{\partial v}{\partial x}$$

证明

$$\begin{align}
\lim_{\Delta x\to 0,\Delta y=0}\frac{f(z_0+\Delta z)-f(z_0)}{\Delta z}&=\lim_{\Delta x=0,\Delta y\to 0}\frac{f(z_0+\Delta z)-f(z_0)}{\Delta z}\\
\frac{u(x_0+\Delta x, y_0)+iv(x_0+\Delta x,y_0)}{\Delta x}&=\frac{u(x_0, y_0+\Delta y)+iv(x_0,y_0+\Delta y)}{i\Delta y}\\
\frac{\partial u}{\partial x}+i\frac{\partial v}{\partial x}&=-i\frac{\partial u}{\partial y}+\frac{\partial v}{\partial y}\end{align}$$

## 积分

- 曲线的内侧定义为，前进方向的左侧。逆时针方向为正向。

- 函数在一有向曲线的积分为，在曲线上做分割，所有弧段自变量增量乘以弧内任一点的函数值的和在弧长趋于0时的极限。

- 二元实函对弧长的曲线积分为，弧长与函数值乘积的和的极限，等于因、自变量连线构成曲面的面积。

- 二元实函对坐标的曲线积分为，自变量之差与函数值乘积的和的极限，等于对弧长积分在坐标轴投影的曲面面积。

## 格林公式

- 二元实函对坐标的围线积分等于偏导在内部的二重积分。

$$\oint Pdx+Qdy=\iint-\frac{\partial P}{\partial y}+\frac{\partial Q}{\partial x}dxdy$$

证明

在积分变量上取一小段，切出积分区域的一片。上下侧自变量增量符号相反，则曲线积分值为所有段上下侧之差的和。由微积分基本定理可知，上下侧之差等于导数的积分。

## 柯西积分定理

- 有向光滑闭曲线称为闭路。多条闭路内侧为一个连通域，构成复合闭路。

- 解析域内复合闭路积分为零。

$$\oint fdz=0$$

证明

$$\begin{align}\oint fdz&=\oint(u+iv)(dx+idy)\\
&=\oint (udx-vdy)+i(vdx+udy)\\
&=\iint-(\frac{\partial u}{\partial y}+\frac{\partial v}{\partial x})+i(-\frac{\partial v}{\partial y}+\frac{\partial u}{\partial x})dxdy\\&=0\end{align}$$

(6)为格林公式，对多连通域切分可构成多个单连通域，满足定理条件。切割线上的积分反向相消，不改变积分值。

(7)为C-R条件

由此有以下推论

### 复合闭路定理

- 内外侧曲线构成复合闭路，积分和为零。故内外侧同相曲线积分相等。

### 柯西积分公式

- 解析域内函数值可由围线上函数值除以自变量差值在围线上的积分算得。

$$f(z_0)=\frac1{2\pi i}\oint \frac{f(z)}{z-z_0}dz$$

证明

被积函数在所求点去心邻域内解析，令围线逼近所求点，有

$$\begin{align}
\frac1{2\pi i}\oint_c \frac{f(z)}{z-z_0}dz&=\frac1{2\pi i}\oint_{R\to 0} \frac{f(z)}{z-z_0}dz\\
&=f(z_0)\frac1{2\pi i}\oint \frac1{z-z_0}dz\\
&=f(z_0)\frac1{2\pi i}\int_0^{2\pi}\frac1{z-z_0}i(z-z_0)d\theta\\
&=f(z_0)
\end{align}$$

## 留数

$$Res[f,z_0]=2\pi i\oint fdz$$
