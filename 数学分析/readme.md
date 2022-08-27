# 数学分析

数学分析以自然数为先验概念，由此构建出完整体系。

复数由实数定义。实数集是复数集的子集。复分析的一些定理与实分析形式相似，一些证明又需要对实虚部二元实函应用实分析定理。

复分析是信号和系统分析的有效工具。下面先介绍复分析和涉及的实分析概念和定理。

---

---

## 复数

- 设**有理数**的概念抽象自自然界，并由幂运算扩充为**实数**。

- 将实数单位的负值开根定义为虚部单位，构成**复数**。

$$\sqrt{-1}=i,\ z = x+yi.\quad x,\ y\in \mathbb R, \quad z\in\mathbb C$$

- **共轭**：实部相等虚部相反。

$$\bar z=x-yi$$

- **复平面**：将复数映射至实虚变量构成的二维平面。

- **扩充的复平面**：含无穷远点的复平面，记为z-。

---

### 复数不等式

- 复数和差的模小于等于模的和。

$$|z_1\pm z_2|\leq|z_1|+|z_2|$$

证明：

根据模和共轭的关系可证。也可用矢量的运算法则和三角形两边和大于第三边公理证明。

---

---

## 函数

- **映射**：集合中元素的对应关系。单射表示一个元素只映射到一个元素。

- **函数**：数集到数集的单射。

$$f(z)=u(z)+iv(z),\quad f:\mathbb C \to\mathbb C,\quad u,v\in\mathbb R$$

- **数列**：定义域为整数集的函数。

$$a_1,a_2\dots,a_n,\quad a:\mathbb Z \to \mathbb C$$

**注意实函可和无数个复函在实数集中有相同的映射关系，因此可以构建复函来分析实函。**

---

---

## 极限

- 函数的在某点的**极限**：值域内极限值的任意邻域，均对应于定义域内该点某去心邻域。

$$\lim_{z\to z_0}=f(z_0)\quad\equiv\quad\forall \epsilon>0,\ \exists \delta,\quad |z-z_0|<\delta\Rightarrow|f(z)-f(z_0)|<\epsilon$$

---

### 自然常数

- 结算次数与利率乘积为1的复利，在利率趋于零趋于0时的极限。

$$e=\lim_{x\to0}(1+x)^\frac1x,x\in\mathbb R$$

证明：

自变量为正整数倒数时，多项式展开，可知单调有界，故收敛。用夹逼准则推广至正实数，用变量代换推广至实数。

---

---

## 导数

- 函数在一点的**导数**：该点函数增量与自变量增量的比，在增量为零处的极限。

$$f'(z_0)=\frac{df}{dz}|_{z=z_0}\equiv \lim_{\Delta z \to 0}\frac{f(z_0+\Delta z)-f(z_0)}{\Delta z}$$

- 函数在一点**解析**：函数在该点及某邻域内可导。

---

### 实指数函数和幂函数的导数

- 以自然常数为底的实指数函数的导数等于自身。

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

- 幂函数可换底为指数函数求导。

$$(x^\mu)'=(e^{\mu\ln x})'=\mu x^{\mu-1}$$

---

### 微分中值定理

- （内部可导的闭区间）两端实函数差之比等于中间某点的导数之比。

$$\frac{f(b)-f(a)}{g(b)-g(a)}=\frac{f'(\theta)}{g'(\theta)},\ \theta\in(a,b)$$

证明：

端点处等值则区间内存在零点，称为罗尔定理。构造函数，使上式满足罗尔定理条件，可证。

---

### 洛必达(L'Hôpital)定理

- 实函极小值之比等于导数之比。

证明：

令所求点函数值为零，不影响极限，此时可用[微分中值定理](#微分中值定理)。

$$\lim_{x\to x_0}\frac {f(x)}{g(x)}=\lim_{x\to 0}\frac{f(x)-f(x_0)}{g(x)-g(x_0)}=\lim_{x\to x_0}\frac{f'(x)}{g'(x)}$$

---

### 实函的泰勒(Talor)展开定理

- 实函可展开为多项式，余项为高阶无穷小。

$$f(x)=\sum_{k=0}^n \frac{f^k(x_0)}{k!}(x-x_0)^k+o((x-x_0)^k)$$

证明：

余项的各阶导数为0，反复使用[洛必达定理](#洛必达lhôpital定理)，结果为无穷小。

---

### 欧拉(Euler)公式

- 复指数实部为幂的余弦，虚部为正弦。

$$e^{ix}=\cos x+i\sin x$$

证明：

通过[泰勒定理](#实函的泰勒talor展开定理)和[求导公式](#实指数函数和幂函数的导数)可证。

$$\begin{align*}
e^{ix}&=1+ix+\frac{(ix)^2}{2!}+\dots+\frac{(ix)^n}{n!}\\
&=(1-\frac{x^2}{2!}+\frac{x^4}{4!}+\dots)+i(x-\frac{x^3}{3!}+\dots)\\
&=\cos x+i\sin x
\end{align*}$$

---

### 复数的指数表示

- 复数可表示为模和辐角形式。

$$z=|z|e^{iArgz}=\sqrt {x^2+y^2}e^{i\tan^{-1}\frac yx}$$

证明：

通过[欧拉公式](#欧拉euler公式)可证。

$$\begin{align*}
z&=\sqrt {x^2+y^2}e^{i\tan^{-1}\frac yx}\\
&=\sqrt{x^2+y^2}(\cos(\tan^{-1}\frac yx)+\sin(\tan^{-1}\frac yx)i)\\
&=x+yi
\end{align*}$$

---

### 柯西-黎曼(Cauchy-Riemann)公式

- 解析函数实虚部可互求。

$$\frac{\partial u}{\partial x}=\frac{\partial v}{\partial y},
\frac{\partial u}{\partial y}=-\frac{\partial v}{\partial x}$$

证明：

$$\begin{align*}
\lim_{\Delta x\to 0,\Delta y=0}\frac{f(z_0+\Delta z)-f(z_0)}{\Delta z}&=\lim_{\Delta x=0,\Delta y\to 0}\frac{f(z_0+\Delta z)-f(z_0)}{\Delta z}\\
\frac{u(x_0+\Delta x, y_0)+iv(x_0+\Delta x,y_0)}{\Delta x}&=\frac{u(x_0, y_0+\Delta y)+iv(x_0,y_0+\Delta y)}{i\Delta y}\\
\frac{\partial u}{\partial x}+i\frac{\partial v}{\partial x}&=-i\frac{\partial u}{\partial y}+\frac{\partial v}{\partial y}\end{align*}$$

---

### 调和函数和解析函数

- **拉普拉斯方程**：

$$\frac{\partial^2 u}{\partial^2 x}+\frac{\partial^2 u}{\partial^2 y}=0$$

- **调和函数**：满足拉普拉斯方程的二元实函。

- 解析函数实虚部均为调和函数。

证明：

通过[C-R公式](#柯西-黎曼cauchy-riemann公式)可证。

$$\frac{\partial^2 u}{\partial^2 x}+\frac{\partial^2 u}{\partial^2 y}=\frac{\partial^2 v}{\partial x\partial y}-\frac{\partial^2 v}{\partial x\partial y}=0$$

---

---

## 微分

- 函数在一点为**无穷小**：该点极限为0.

- **高阶无穷小**：两无穷小比值为无穷小，则分子为**高阶无穷小**。

$$\alpha=o(\beta)\quad\equiv\quad\frac\alpha\beta\to0$$

- 函数在一点的**微分**：该点附近函数增量与自变量增量的一阶线性等价关系。

$$df=f'dz+o(dz)$$

---

### 可微的充要条件

- **函数可微**等价于可导。

证明：

若函数可导，则增量比有极限，故余项是高阶无穷小。若可微，则增量比的极限为定值。

---

### 解析的充要条件

- **函数解析**等价于实虚部可微且满足[C-R公式](#柯西-黎曼cauchy-riemann公式)。

证明：

必要性在C-R公式中已证，下证充分性。将函数增量表示为实虚部函数的微分，再套用C-R公式，得到函数的微分式。

$$\begin{align*}
df&=du+idv\\
&=\frac{\partial u}{\partial x}dx+\frac{\partial u}{\partial y}dy+i\frac{\partial v}{\partial x}dx+i\frac{\partial v}{\partial y}dy+o(|dz|)\\
&=\frac{\partial v}{\partial y}dx+i^2\frac{\partial v}{\partial x}dy+i\frac{\partial v}{\partial x}dx+i\frac{\partial v}{\partial y}dy+o(|dz|)\\
&=(\frac{\partial v}{\partial y}+i\frac{\partial v}{\partial x})(dx+idy)+o(|dz|)\\
&=(\frac{\partial v}{\partial y}+i\frac{\partial v}{\partial x})(dz)+o(|dz|)\\
\end{align*}$$

**这意味着C-R公式给出了由实函构建解析函数的方法。**

---

### 指数函数和幂函数的导数

- 指数函数的导数为自身。

$$(e^z)'=e^z$$

证明：

根据[欧拉公式](#欧拉euler公式)和[解析的充要条件](#解析的充要条件)可证。

$$e^z=e^x\cos y+ie^x\sin y\\

\frac{\partial(e^x\cos y)}{\partial x}=\frac{\partial(e^x\sin y)}{\partial y},
\frac{\partial(e^x\cos y)}{\partial y}=-\frac{\partial(e^x\sin y)}{\partial x}
\Rightarrow (e^z)'=e^z$$

- 幂函数可换底为指数函数求导。

$$(z^a)'=az^{(a-1)}$$

---

---

## 积分

- 曲线的**内侧**：前进方向的左侧。**正向**：逆时针方向。

- 函数在一有向曲线的**积分**：在曲线上做分割，所有弧段自变量增量乘以弧内任一点的函数值的和在弧长趋于0时的极限。

- 二元实函**对弧长的曲线积分**：弧长与函数值乘积的和的极限，等于因、自变量连线构成曲面的面积。

- 二元实函**对坐标的曲线积分**：自变量之差与函数值乘积的和的极限，等于对弧长积分在坐标轴投影的曲面面积。

---

### 微积分基本定理

- 导数的积分等于原函数的变化量。

$$\int_a^bf'dz=f(b)-f(a)$$

证明：

增量比乘以自变量增量，在增量趋于零时，等于因变量增量。因变量增量的和等于变化量。

---

### 格林(Green)公式

- 二元实函对坐标的围线积分等于偏导在内部的二重积分。

$$\oint Pdx+Qdy=\iint-\frac{\partial P}{\partial y}+\frac{\partial Q}{\partial x}dxdy$$

证明：

对单连通域，在积分变量上取一小段，切出积分区域的一片。上下侧自变量增量符号相反，则曲线积分值为所有段上下侧之差的和。由[微积分基本定理](#微积分基本定理)，上下侧之差等于导数的积分。对多连通域，可切割为单连通域，割线上积分反向相消。

---

### 柯西(Cauchy)积分定理

- **闭路**：有向光滑闭曲线。

- **复合闭路**：内侧构成一个连通域的多条闭路。

- **柯西积分定理**：解析域内复合闭路积分为零。

$$\oint fdz=0$$

证明：

$$\begin{align}\oint fdz&=\oint(u+iv)(dx+idy)\\
&=\oint (udx-vdy)+i(vdx+udy)\\
&=\iint-(\frac{\partial u}{\partial y}+\frac{\partial v}{\partial x})+i(-\frac{\partial v}{\partial y}+\frac{\partial u}{\partial x})dxdy\\&=0\end{align}$$

其中(6)为[格林公式](#格林green公式)，(7)为[C-R公式](#柯西-黎曼cauchy-riemann公式)。

---

### 柯西积分公式

- 解析域内函数值可由围线上函数值除以自变量差值在围线上的积分算得。

$$f(z_0)=\frac1{2\pi i}\oint \frac{f(z)}{z-z_0}dz$$

证明：

被积函数在所求点去心邻域内解析，构建复合闭路。根据[柯西积分定理](#柯西cauchy积分定理)，令围线逼近所求点，不改变积分值。则

$$\begin{align*}
\frac1{2\pi i}\oint_c \frac{f(z)}{z-z_0}dz&=\frac1{2\pi i}\oint_{R\to 0} \frac{f(z)}{z-z_0}dz\\
&=f(z_0)\frac1{2\pi i}\oint \frac1{z-z_0}dz\\
&=f(z_0)\frac1{2\pi i}\int_0^{2\pi}\frac1{z-z_0}i(z-z_0)d\theta\\
&=f(z_0)
\end{align*}$$

- **解析函数有任意阶导数**且可由围线积分算得。

$$f^n(z_0)=\frac{n!}{2\pi i}\oint\frac {f(z)}{(z-z_0)^n}dz$$

证明：

使围线包含两点，积分值之差即为函数增量。

$$\begin{align*}
f(z_0+\Delta z)+f(z_0)&=\frac 1{2\pi i}\oint f(z)(\frac 1{z-(z_0+\Delta z)}-\frac1{z-z_0})dz\\
&=\frac {\Delta z}{2\pi i}\oint \frac{f(z)dz}{(z-z_0-\Delta z)(z-z_0)}\\
\lim_{\Delta z\to 0}\frac{f(z_0+\Delta z)+f(z_0)}{\Delta z}&=\frac 1{2\pi i}\oint \frac{f(z)dz}{(z-z_0)^2}
\end{align*}$$

同理递推即可。也可类比1/(1-x)求导过程。

---

### 平均值公式

- 解析函数圆心值等于在外部圆周上的均值。

证明：

由[柯西积分公式](#柯西积分公式)可证。

---

### 柯西不等式

- 解析函数导数的模小于函数值在外部任一圆上的上界除以半径。

$$|f'(z_0)|\leq\frac MR$$

证明：

根据[柯西积分公式](#柯西积分公式)和[复数不等式](#复数不等式)可证。此式也可推广至高阶导数。

$$|f'(z_0)|=|\frac1{2\pi i}\oint\frac{f(z)dz}{(z-z_0)^2}| \leq \frac1{2\pi}\oint\frac{|f(z)|}{R^2}d|z| \leq \frac MR$$

---

### 刘维尔(Liouville)定理

- **整函数**：在扩充的复平面内解析的函数。

- 有上界的整函数恒为常数。

证明：

由[柯西不等式](#柯西不等式)，令半径趋于无穷，则导数为零。

---

### 代数学基本定理

- 多项式在扩充的复平面上必有根。

$$\exists z\in z^-,\sum_{n\in\mathbb N} a_nz^n=0,a_n\in\mathbb C$$

证明：

若无根，则多项式的倒数解析且有界，由[刘维尔定理](#刘维尔liouville定理)知多项式恒为常数，则矛盾。

**递归使用此定理，则可将多项式分解至一阶。**

---

---

## 级数

- **级数**：数列的和。若项数在无穷远点的极限存在，则级数收敛至该极限值。

- **函数项级数**：由整数到函数的映射构成函数数列，也即一数集到数列集的映射。函数数列和为函数项级数。

---

---

## 留数

函数在一点的邻域内解析，其留数可由围线积分给出。

$$Res[f,z_0]=2\pi i\oint fdz$$

### 留数定理

- 扩充的复平面内有有限个孤立奇点，则所有孤立奇点留数和为0。

$$\sum Res[f,z_k]=0$$

证明：

---

---

<!-- ## 级数

## 泰勒展开定理

## 洛朗级数 -->
