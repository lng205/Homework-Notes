# 总结

## 实验四

实验四实现LED信道上的DCO-OFDM仿真，基本涵盖了之前的实验内容。

Matlab提供的函数和语法与仿真内容十分契合，代码可以写得简洁且高效。

考虑到信道特性已知且相对静态，选择在发射端进行均衡。此时各子载波符号能量一致，可直接套用AWGN误码率公式。

## 作业

1. 从数学上证明通过“赫密特对称”和“傅里叶反变换”后，可以产生实数。

离散频谱可由模拟频谱采样得到。下面证明频谱共轭对称的信号为实信号。

$$
\begin{align}
X(\omega)&=X^*(-\omega)\\
x(t)&=\frac{1}{2\pi}\int_{-\infty}^{+\infty}X(\omega)e^{j\omega t}d\omega\\
x^*(t)&=\frac{1}{2\pi}\int_{-\infty}^{+\infty}X^*(\omega)e^{-j\omega t}d\omega\\
&=\frac{1}{2\pi}\int_{+\infty}^{-\infty}X^*(-\omega)e^{j\omega t}d(-\omega)\\
&=\frac{1}{2\pi}\int_{-\infty}^{+\infty}X^*(-\omega)e^{j\omega t}d(\omega)\\
&=x(t)
\end{align}
$$

2. 从数学上推导循环前缀为何能保护DCO-OFDM信号块，循环前缀的长度范围为多少？从数学上证明为何循环前缀能把线性卷积转变成循环卷积。

线性系统输出为输入信号与系统冲激响应卷积。CP长度为h(n)拖尾长度，即h长度减1。将离散卷积表示为矩阵形式，举例证明如下。

$$
\begin{bmatrix}
y_0\\
y_1\\
y_2\\
y_3\\
\hdashline y_4\\
y_5\\
y_6\\
y_7\\
y_8\\
y_9
\end{bmatrix}
=\begin{bmatrix}
h_0\\
h_1&h_0\\
h_2&h_1&h_0\\
&h_2&h_1&h_0\\
\hdashline &&h_2&h_1&h_0\\
&&&h_2&h_1&h_0\\
&&&&h_2&h_1&h_0\\
&&&&&h_2&h_1&h_0\\
&&&&&&h_2&h_1&h_0\\
&&&&&&&h_2&h_1&h_0
\end{bmatrix}
\times
\begin{bmatrix}
m_5\\
m_6\\
n_5\\
n_6\\
\hdashline n_1\\
n_2\\
n_3\\
n_4\\
n_5\\
n_6
\end{bmatrix}\\
=\begin{bmatrix}
h_0m_5\\
h_1m_5+h_0m_6\\
h_2m_5+h_1m_6+h_0n_5\\
h_2m_6+h_1n_5+h_0n_6\\
\hdashline h_2n_5+h_1n_6+h_0n_1\\
h_2n_6+h_1n_1+h_0n_2\\
h_2n_1+h_1n_2+h_0n_3\\
h_2n_2+h_1n_3+h_0n_4\\
h_2n_3+h_1n_4+h_0n_5\\
h_2n_4+h_1n_5+h_0n_6
\end{bmatrix}
$$

3. 发送信号中的直流偏置在接收端经过傅里叶变换后发生了怎样的变化？是否对接收端和解调产生影响？

傅里叶变换满足可加性，常数对应频谱为冲激函数。故增加的直流分量直流分量对应频谱0Hz分量，不影响接收。

4. 从数学上论证DCO-OFDM如何消除由信道带来的码间干扰。

OFDM增加符号周期，再增加CP使码间干扰被截去。由2中计算可看出，码间干扰落在CP区间内。