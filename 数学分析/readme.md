# 复分析复习总结

实数集是复数集的子集，复分析定理可用于实分析。复分析的一些定理与实分析形式相似，而一些证明又需要对实虚部二元实函应用实分析定理。

拉氏变换是信号和系统分析的重要工具，其逆变换可用留数定理计算。

## 留数定理

- 扩充的复平面（包含无穷远点）内有有限孤立奇点，则所有孤立奇点留数和为0。

$$\sum Res[f,z_k]=0$$

留数定理的证明涉及复分析的多个理论。先给出一些基本定义。

## 复数

- 设**有理数**的概念抽象自自然界，并由幂运算扩充为**实数**。

- 将实数单位的负值开根定义为复数单位，构成**复数**。

$$\sqrt{-1}=i,\ z = x+yi.\quad x,\ y\in \mathbb R, \quad z\in\mathbb C$$

## 函数

- **映射**：集合中元素的对应关系。单射表示一个元素只映射到一个元素。

- **函数**：数集到数集的单射。

$$f(z)=u(z)+iv(z),\quad f:\mathbb C \to\mathbb C,\quad u,v\in\mathbb R$$

- **数列**：定义域为整数集的函数。

$$a_1,a_2\dots,a_n,\quad a:\mathbb Z \to \mathbb C$$

## 极限

- 函数的在某点的**极限**：值域内极限值的任意邻域，均对应于定义域内该点某去心邻域。

$$\lim_{z\to z_0}=f(z_0)\quad\equiv\quad\forall \epsilon>0,\ \exists \delta,\quad |z-z_0|<\delta\Rightarrow|f(z)-f(z_0)|<\epsilon$$

## 导数

- 函数在一点的**导数**：该点函数增量与自变量增量的比，在增量为零处的极限。

$$f'(z_0)=\frac{df}{dz}|_{z=z_0}\equiv \lim_{\Delta z \to 0}\frac{f(z_0+\Delta z)-f(z_0)}{\Delta z}$$

- 函数在一点**解析**：函数在该点及某邻域内可导。

## 微分

- 函数在一点为**无穷小**：该点极限为0.

- **高阶无穷小**：两无穷小比值为无穷小，则分子为**高阶无穷小**。

$$\alpha=o(\beta)\quad\equiv\quad\frac\alpha\beta\to0$$

- 函数在一点的**微分**：该点函数增量与自变量增量的一阶线性等价关系。

$$df=f'dz+o(dz)$$

## 积分

- 曲线的**内侧**：前进方向的左侧。**正向**：逆时针方向。

- 函数在一有向曲线的**积分**：在曲线上做分割，所有弧段自变量增量乘以弧内任一点的函数值的和在弧长趋于0时的极限。

- 二元实函**对弧长的曲线积分**：弧长与函数值乘积的和的极限，等于因、自变量连线构成曲面的面积。

- 二元实函**对坐标的曲线积分**：自变量之差与函数值乘积的和的极限，等于对弧长积分在坐标轴投影的曲面面积。

由此可以定义留数。

## 留数

函数在一点的邻域内解析，其留数可由围线积分给出。

$$Res[f,z_0]=2\pi i\oint fdz$$

证明留数定理还需要柯西积分定理，为此先介绍复数的指数表示。

## 复数的指数表示

- 复数可表示为模和辐角形式。

$$\begin{align}
z=|z|e^{iArgz}&=\sqrt {x^2+y^2}e^{i\tan^{-1}\frac yx}\\
&=\sqrt{x^2+y^2}(\cos(\tan^{-1}\frac yx)+\sin(\tan^{-1}\frac yx)i)\\
&=x+yi
\end{align}$$

(2)为欧拉公式，下面给出相关定义及证明。

- **自然常数**：结算次数与利率乘积为1的复利，在利率趋于零趋于0时的极限。

$$e=\lim_{x\to0}(1+x)^\frac1x,x\in\mathbb R$$

证明：

自变量为正整数倒数时，多项式展开，可知单调有界，故收敛。用夹逼准则推广至正实数，用变量代换推广至实数。

- 以自然常数为底的指数函数的导数等于自身。

$$(e^x)'=e^x$$

证明：

$$\begin{align*}
(e^x)' &= \lim_{\Delta x \to 0} \frac{e^{(x+\Delta x)}-e^x}{\Delta x}\\
&=e^x \lim_{\Delta x \to 0} \frac{e^{\Delta x}-1}{\Delta x}\\
e^{\Delta x}-1=t\Rightarrow
&=e^x \lim_{t\to 0} \frac t{\ln(t+1)}\\
&=e^x \lim_{t\to 0} \frac1{\ln(t+1)^\frac1t}\\
&=e^x
\end{align*}$$

- 幂函数的导数等于幂乘以幂次减一的自身。

证明

$$\begin{align*}
(x^\mu)'&=\lim_{\Delta x \to 0}\frac{(x+\Delta x)^\mu-x^\mu}{\Delta x}\\
&=x^{\mu-1}\lim_{\Delta x \to 0}\frac{(1+\frac{\Delta x}x)^\mu-1}{\frac{\Delta x}x}\\
u=\frac{\Delta x}x,v=(1+\frac{\Delta x}x)^\mu-1\Rightarrow
&=x^{\mu-1}\lim_{t\to 0}\frac t{\ln(1+t)}\lim_{u\to 0}\frac{\mu\ln(1+u)}{u}\\
&=\mu x^{\mu-1}
\end{align*}
$$

- **微分中值定理**：（内部可导的闭区间）两端实函数差之比等于中间某点的导数之比。

$$\frac{f(b)-f(a)}{g(b)-g(a)}=\frac{f'(\theta)}{g'(\theta)},\ \theta\in(a,b)$$

证明：

端点处等值则区间内存在零点，称为罗尔定理。构造函数，使上式满足罗尔定理条件，可证。

- **洛必达(L'Hôpital)定理**：实函极小值之比等于导数之比。

证明：

令所求点函数值为零，不影响极限。则

$$\lim_{x\to x_0}\frac {f(x)}{g(x)}=\lim_{x\to 0}\frac{f(x)-f(x_0)}{g(x)-g(x_0)}=\lim_{\theta\to 0}\frac{f'(\theta)}{g'(\theta)}$$

- 实函可展开为多项式，余项为高阶无穷小（实函的泰勒(Talor)展开定理）。

$$f(x)=\sum_{k=0}^n \frac{f^k(x_0)}{k!}(x-x_0)^k+o((x-x_0)^k)$$

证明：

余项的各阶导数为0，反复使用洛必达法则，结果为无穷小。

- **欧拉(Euler)公式**：复指数实部为幂的余弦，虚部为正弦。

$$e^{ix}=\cos x+i\sin x$$

证明：

$$\begin{align*}
e^{ix}&=1+ix+\frac{(ix)^2}{2!}+\dots+\frac{(ix)^n}{n!}\\
&=(1-\frac{x^2}{2!}+\frac{x^4}{4!}+\dots)+i(x-\frac{x^3}{3!}+\dots)\\
&=\cos x+i\sin x
\end{align*}$$

<br><br>

## 柯西(Cauchy)积分定理

- **闭路**：有向光滑闭曲线。

- **复合闭路**：内侧构成一个连通域的多条闭路。

- **柯西积分定理**：解析域内复合闭路积分为零。

$$\oint fdz=0$$

证明：

$$\begin{align}\oint fdz&=\oint(u+iv)(dx+idy)\\
&=\oint (udx-vdy)+i(vdx+udy)\\
&=\iint-(\frac{\partial u}{\partial y}+\frac{\partial v}{\partial x})+i(-\frac{\partial v}{\partial y}+\frac{\partial u}{\partial x})dxdy\\&=0\end{align}$$

其中(6)为格林公式，(7)为C-R公式。下面证明相关公式。

- **格林(Green)公式**：二元实函对坐标的围线积分等于偏导在内部的二重积分。

$$\oint Pdx+Qdy=\iint-\frac{\partial P}{\partial y}+\frac{\partial Q}{\partial x}dxdy$$

证明：

对单连通域，在积分变量上取一小段，切出积分区域的一片。上下侧自变量增量符号相反，则曲线积分值为所有段上下侧之差的和。由微积分基本定理可知，上下侧之差等于导数的积分。对多连通域，可切割为单连通域，割线上积分反向相消。

- **柯西-黎曼(Cauchy-Riemann)公式**：解析函数实虚部可互求。

$$\frac{\partial u}{\partial x}=\frac{\partial v}{\partial y},\quad
\frac{\partial u}{\partial y}=-\frac{\partial v}{\partial x}$$

证明：

$$\begin{align*}
\lim_{\Delta x\to 0,\Delta y=0}\frac{f(z_0+\Delta z)-f(z_0)}{\Delta z}&=\lim_{\Delta x=0,\Delta y\to 0}\frac{f(z_0+\Delta z)-f(z_0)}{\Delta z}\\
\frac{u(x_0+\Delta x, y_0)+iv(x_0+\Delta x,y_0)}{\Delta x}&=\frac{u(x_0, y_0+\Delta y)+iv(x_0,y_0+\Delta y)}{i\Delta y}\\
\frac{\partial u}{\partial x}+i\frac{\partial v}{\partial x}&=-i\frac{\partial u}{\partial y}+\frac{\partial v}{\partial y}\end{align*}$$

由柯西积分定理可得两个推论。

### 复合闭路定理

- 内外侧曲线构成复合闭路，积分和为零。故内外侧同相曲线积分相等。

### 柯西积分公式

- 解析域内函数值可由围线上函数值除以自变量差值在围线上的积分算得。

$$f(z_0)=\frac1{2\pi i}\oint \frac{f(z)}{z-z_0}dz$$

证明：

被积函数在所求点去心邻域内解析，令围线逼近所求点，有

$$\begin{align*}
\frac1{2\pi i}\oint_c \frac{f(z)}{z-z_0}dz&=\frac1{2\pi i}\oint_{R\to 0} \frac{f(z)}{z-z_0}dz\\
&=f(z_0)\frac1{2\pi i}\oint \frac1{z-z_0}dz\\
&=f(z_0)\frac1{2\pi i}\int_0^{2\pi}\frac1{z-z_0}i(z-z_0)d\theta\\
&=f(z_0)
\end{align*}$$

下面证明[留数定理](#留数定理)。



<!-- ## 级数

## 泰勒展开定理

## 洛朗级数 -->
