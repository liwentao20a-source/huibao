# 立面SAR成像几何模型推导

## 1. 坐标系与几何构型

### 1.1 坐标系定义

以雷达在初始时刻（慢时间 $t = 0$）的地面投影点为原点 $O$，建立三维直角坐标系 $(x, y, h)$：

| 坐标轴 | 方向 | 说明 |
|--------|------|------|
| $x$ 轴 | 雷达飞行方向 | 沿建筑立面水平方向 |
| $y$ 轴 | 垂直于建筑立面 | 由雷达指向建筑 |
| $h$ 轴 | 垂直向上 | 高度方向 |

建筑为一高层垂直立面，位于 $y = R_0$ 处（$R_0$ 为雷达航迹到立面的水平距离）。立面在 $x$ 和 $h$ 方向延伸。

### 1.2 平台运动模型

雷达平台以速度 $V$ 向前飞行，同时以固定俯冲角 $\alpha$ 向下俯冲。速度矢量在三维空间中的分量为：

$$\mathbf{v} = (V\cos\alpha,\; 0,\; -V\sin\alpha)$$

其中：
- $V\cos\alpha$：水平前向速度分量（沿 $x$ 轴）
- $V\sin\alpha$：垂直下降速度分量（沿 $-h$ 方向）

设初始时刻雷达位于 $(0, 0, H)$，其中 $H$ 为初始平台高度。在慢时间 $t$ 时刻，雷达平台位置为：

$$\begin{cases}
x_p(t) = V\cos\alpha \cdot t \\
y_p(t) = 0 \\
h_p(t) = H - V\sin\alpha \cdot t
\end{cases}$$

### 1.3 波束指向

雷达波束指向正前方偏下，照射范围落在建筑立面上。设波束中心在 $t = 0$ 时刻照射立面上的参考点 $P_{\text{ref}} = (0, R_0, h_c)$，其中 $h_c$ 为照射区域中心高度。

定义雷达至参考点的俯角 $\beta$：

$$\tan\beta = \frac{H - h_c}{R_0}, \quad \sin\beta = \frac{H - h_c}{\sqrt{R_0^2 + (H - h_c)^2}}$$

---

## 2. 瞬时斜距

### 2.1 斜距方程

立面上任意点目标 $P = (x, R_0, h)$，在慢时间 $t$ 时刻，雷达至目标的瞬时斜距为：

$$R(t) = \sqrt{\left[x - x_p(t)\right]^2 + \left[0 - R_0\right]^2 + \left[h_p(t) - h\right]^2}$$

代入平台运动方程：

$$R(t) = \sqrt{(x - V\cos\alpha \cdot t)^2 + R_0^2 + (H - V\sin\alpha \cdot t - h)^2} \tag{1}$$

### 2.2 化为标准双曲形式

将 $(1)$ 式平方并展开：

$$\begin{aligned}
R^2(t) &= (x - V\cos\alpha \cdot t)^2 + R_0^2 + \bigl[(H-h) - V\sin\alpha \cdot t\bigr]^2 \\[4pt]
&= x^2 - 2x V\cos\alpha \cdot t + V^2\cos^2\alpha \cdot t^2 \\
&\quad + R_0^2 \\
&\quad + (H-h)^2 - 2(H-h)V\sin\alpha \cdot t + V^2\sin^2\alpha \cdot t^2 \\[4pt]
&= \bigl[x^2 + R_0^2 + (H-h)^2\bigr] - 2V\bigl[x\cos\alpha + (H-h)\sin\alpha\bigr]t + V^2 t^2
\end{aligned}$$

定义两个辅助量：

$$\begin{aligned}
R_c^2(x, h) &= x^2 + R_0^2 + (H-h)^2 \quad &\text{(初始时刻斜距平方)} \\[4pt]
A(x, h) &= x\cos\alpha + (H-h)\sin\alpha \quad &\text{(投影位置参数)}
\end{aligned}$$

则：

$$R^2(t) = R_c^2 - 2V A t + V^2 t^2 \tag{2}$$

对 $(2)$ 式配方：

$$\begin{aligned}
R^2(t) &= (R_c^2 - A^2) + (Vt - A)^2 \\
&= R_{\min}^2 + V^2(t - t_c)^2
\end{aligned} \tag{3}$$

### 2.3 零多普勒时刻与最小斜距

由 $(3)$ 式，斜距在 $t = t_c$ 处取得最小值：

$$t_c = \frac{A}{V} = \frac{x\cos\alpha + (H-h)\sin\alpha}{V} \tag{4}$$

$t_c$ 即**零多普勒时刻**（波束中心对准目标时多普勒频率为零的时刻）。

最小斜距为：

$$R_{\min}^2 = R_c^2 - A^2$$

展开计算：

$$\begin{aligned}
R_{\min}^2 &= x^2 + R_0^2 + (H-h)^2 - \bigl[x\cos\alpha + (H-h)\sin\alpha\bigr]^2 \\[4pt]
&= x^2(1-\cos^2\alpha) + R_0^2 + (H-h)^2(1-\sin^2\alpha) - 2x(H-h)\cos\alpha\sin\alpha \\[4pt]
&= x^2\sin^2\alpha + R_0^2 + (H-h)^2\cos^2\alpha - 2x(H-h)\cos\alpha\sin\alpha \\[4pt]
&= \bigl[x\sin\alpha - (H-h)\cos\alpha\bigr]^2 + R_0^2
\end{aligned}$$

即：

$$\boxed{R_{\min}(x, h) = \sqrt{\bigl[x\sin\alpha - (H-h)\cos\alpha\bigr]^2 + R_0^2}} \tag{5}$$

### 2.4 特例验证

- **无俯冲（$\alpha = 0$）**：$R_{\min}^2 = (H-h)^2 + R_0^2$，退化为平飞正侧视情况，最小斜距即正侧视距离。
- **垂直俯冲（$\alpha \to 90^\circ$）**：$R_{\min}^2 = x^2 + R_0^2$，此时雷达垂直下降，最小斜距为水平距离。
- **参考点 $(0, R_0, h_c)$ 处**：$R_{\min}^2 = (H-h_c)^2\cos^2\alpha + R_0^2$。

---

## 3. 多普勒分析

### 3.1 瞬时多普勒频率

多普勒频率定义为：

$$f_d(t) = -\frac{2}{\lambda}\frac{dR(t)}{dt}$$

由 $(3)$ 式 $R^2 = R_{\min}^2 + V^2(t-t_c)^2$，两边对 $t$ 求导：

$$2R\frac{dR}{dt} = 2V^2(t-t_c) \quad\Rightarrow\quad \frac{dR}{dt} = \frac{V^2(t-t_c)}{R(t)}$$

因此：

$$\boxed{f_d(t) = -\frac{2V^2}{\lambda R(t)}(t - t_c)} \tag{6}$$

### 3.2 多普勒中心频率

多普勒中心频率定义为波束中心照射目标时的多普勒值。以参考点 $(0, R_0, h_c)$ 在 $t = 0$ 时刻（波束中心时刻）计算：

参考点处：
- $t_c^{\text{ref}} = \dfrac{(H-h_c)\sin\alpha}{V}$
- $R_{\text{ref}} = \sqrt{R_0^2 + (H-h_c)^2}$

代入 $(6)$ 并取 $t = 0$：

$$\begin{aligned}
f_{dc} &= f_d(0)\Big|_{x=0,\,h=h_c} \\[4pt]
&= -\frac{2V^2}{\lambda R_{\text{ref}}}(0 - t_c^{\text{ref}}) \\[4pt]
&= \frac{2V}{\lambda R_{\text{ref}}} \cdot (H-h_c)\sin\alpha
\end{aligned}$$

引入俯角 $\beta$（$\sin\beta = \frac{H-h_c}{R_{\text{ref}}}$）：

$$\boxed{f_{dc} = \frac{2V\sin\alpha \cdot \sin\beta}{\lambda}} \tag{7}$$

**关键特征**：立面成像的多普勒中心频率**非零**，其值正比于俯冲速度的垂直分量 $V\sin\alpha$ 和俯角正弦 $\sin\beta$。这与传统正侧视SAR（零多普勒中心）有本质区别。

### 3.3 多普勒调频率

多普勒调频率为多普勒频率对时间的导数：

$$f_r = \frac{d f_d}{dt} = -\frac{2V^2}{\lambda} \cdot \frac{d}{dt}\left(\frac{t - t_c}{R(t)}\right)$$

$$\begin{aligned}
f_r &= -\frac{2V^2}{\lambda} \left[\frac{1}{R} - \frac{t-t_c}{R^2}\frac{dR}{dt}\right] \\[4pt]
&= -\frac{2V^2}{\lambda R} \left[1 - \frac{V^2(t-t_c)^2}{R^2}\right]
\end{aligned}$$

在零多普勒时刻 $t = t_c$（此时 $R = R_{\min}$）：

$$\boxed{f_r = -\frac{2V^2}{\lambda R_{\min}}} \tag{8}$$

**关键点**：调频率中的速度为**总速度** $V$（含水平和垂直分量），而非仅水平速度 $V\cos\alpha$。这意味着在相同 $R_{\min}$ 下，俯冲使多普勒调频率绝对值增大（因为 $V > V\cos\alpha$）。

---

## 4. 距离徙动分析

### 4.1 精确徙动曲线

距离徙动（RCM）由 $(3)$ 式精确描述：

$$R(t) = \sqrt{R_{\min}^2 + V^2(t - t_c)^2} \tag{9}$$

这是一条**双曲线**，与传统SAR的斜距方程形式相同。但在立面成像中，$R_{\min}$ 的构成不同（含 $\alpha$），且 $t_c$ 一般不为零。

### 4.2 以波束中心时刻为参考的泰勒展开

在实际处理中，通常在波束中心时刻 $t = 0$ 处展开。对参考点 $(0, R_0, h_c)$，将 $R(t)$ 在 $t = 0$ 处作泰勒展开。

一阶导数（线性距离走动）：

$$\frac{dR}{dt}\Big|_{t=0} = \frac{V^2(0 - t_c)}{R_{\text{ref}}} = -\frac{V \cdot (H-h_c)\sin\alpha}{R_{\text{ref}}} = -V\sin\alpha\sin\beta$$

二阶导数（距离弯曲）：

$$\frac{d^2R}{dt^2}\Big|_{t=0} = \frac{V^2}{R_{\text{ref}}} - \frac{V^4 t_c^2}{R_{\text{ref}}^3} = \frac{V^2 R_{\min}^2}{R_{\text{ref}}^3}$$

因此：

$$R(t) \approx R_{\text{ref}} - (V\sin\alpha\sin\beta)\,t + \frac{V^2 R_{\min}^2}{2R_{\text{ref}}^3}\,t^2 \tag{10}$$

其中：
- **线性项（距离走动）**：$\displaystyle R_{\text{walk}} = -V\sin\alpha\sin\beta \cdot t$
- **二次项（距离弯曲）**：$\displaystyle R_{\text{curv}} = \frac{V^2 R_{\min}^2}{2R_{\text{ref}}^3} \cdot t^2$

### 4.3 与正侧视SAR对比

| 特征 | 传统正侧视SAR（地距成像） | 立面成像SAR（本模型） |
|:---|:---|:---|
| **斜距方程** | $R^2(t) = R_0^2 + V^2 t^2$ | $R^2(t) = R_{\min}^2 + V^2(t-t_c)^2$ |
| **零多普勒时刻** | $t_c = 0$（波束中心即零多普勒） | $t_c \neq 0$（一般情况） |
| **多普勒中心** | $f_{dc} = 0$ | $f_{dc} = \frac{2V\sin\alpha\sin\beta}{\lambda} \neq 0$ |
| **距离走动** | 无（零多普勒处展开） | **有**，正比于 $V\sin\alpha \cdot \sin\beta$ |
| **距离弯曲** | $R_{\text{curv}} \approx \frac{V^2}{2R_0}t^2$ | $R_{\text{curv}} = \frac{V^2 R_{\min}^2}{2R_{\text{ref}}^3}t^2$，调频率更高 |
| **有效速度** | $V$（平飞速度） | $V$（含水平和垂直分量的总速率） |
| **徙动曲线形状** | 标准双曲线 | 双曲线，但曲线顶点偏离 $t=0$ |

### 4.4 物理成因分析

立面成像中距离走动的来源是**俯冲导致的垂直速度分量**。雷达以 $V\sin\alpha$ 向下俯冲时，即使目标在 $x=0$ 处（正侧方），雷达高度的持续变化也使得斜距在波束中心时刻附近呈线性变化。这一效应使距离徙动特性**类似于前斜视SAR**，但斜视角是由垂直俯冲而非水平斜视引起的。

---

## 5. 分辨率分析

### 5.1 距离向分辨率（立面垂直方向）

雷达发射带宽为 $B$ 的线性调频信号，经脉冲压缩后的**斜距分辨率**为：

$$\rho_{sr} = \frac{c}{2B}$$

在立面上，距离向沿**垂直方向**（$h$ 方向）。斜距分辨率向立面垂直方向的投影由俯角 $\beta$ 决定。

斜距对高度的偏导数（在 $t=0$、$x=0$ 处）：

$$\frac{\partial R}{\partial h}\Big|_{t=0,\,x=0} = \frac{h - h_p}{R} = -\frac{H-h}{R} = -\sin\beta$$

因此**立面垂直分辨率**为：

$$\boxed{\rho_h = \frac{\rho_{sr}}{\sin\beta} = \frac{c}{2B\sin\beta}} \tag{11}$$

**物理意义**：
- 当 $\beta \to 90^\circ$（雷达几乎在目标正上方）：$\rho_h \to \rho_{sr}$，垂直分辨率最优
- 当 $\beta \to 0^\circ$（雷达几乎与目标等高，擦地角入射）：$\rho_h \to \infty$，垂直分辨率恶化，此时几乎无法通过距离分辨来区分立面不同高度的目标
- 立面成像的分辨率方向是**垂直方向**，而传统地距SAR的分辨率方向是**地距方向**，这是两者在成像几何上的根本区别

### 5.2 方位向分辨率（立面水平方向）

方位向分辨率由合成孔径处理获得。利用 $\omega$-$k$ 方法分析。

**信号模型**：点目标回波经距离压缩后，方位向相位历程为：

$$\phi(t) = -\frac{4\pi}{\lambda}R(t) \approx -\frac{4\pi}{\lambda}R_{\min} - \frac{2\pi V^2}{\lambda R_{\min}}(t - t_c)^2$$

这是一个线性调频信号，调频率为 $K_a = \frac{2V^2}{\lambda R_{\min}}$。

**瞬时多普勒频率**：$f_d(t) = K_a(t - t_c)$

**方位向波数带宽**：平台飞过合成孔径期间，雷达-目标视线方向在 $x$ 方向上的方向余弦变化量为：

$$\Delta(\sin\theta_{az}) = \frac{V\cos\alpha \cdot T_a}{R_{\min}}$$

其中 $T_a$ 为合成孔径时间，由天线方位向波束宽度 $\theta_{az} = \lambda/D_a$ 决定（$D_a$ 为天线方位向尺寸）。

$$T_a \approx \frac{R_{\text{ref}} \cdot \theta_{az}}{V\cos\alpha} = \frac{R_{\text{ref}}\,\lambda}{D_a V\cos\alpha}$$

方位波数带宽：

$$\Delta k_x = \frac{4\pi}{\lambda} \cdot \Delta(\sin\theta_{az}) = \frac{4\pi}{\lambda} \cdot \frac{\lambda R_{\text{ref}}}{D_a R_{\min}} = \frac{4\pi R_{\text{ref}}}{D_a R_{\min}}$$

**方位向分辨率**：

$$\rho_{az} = \frac{2\pi}{\Delta k_x} = \frac{2\pi}{4\pi R_{\text{ref}} / (D_a R_{\min})} = \frac{D_a}{2} \cdot \frac{R_{\min}}{R_{\text{ref}}}$$

代入 $R_{\min}$ 与 $R_{\text{ref}}$ 的关系（参考点处）：

$$R_{\min}^2 = R_0^2 + (H-h_c)^2\cos^2\alpha,\quad R_{\text{ref}}^2 = R_0^2 + (H-h_c)^2$$

$$\frac{R_{\min}}{R_{\text{ref}}} = \sqrt{1 - \sin^2\beta \cdot \sin^2\alpha}$$

最终方位向分辨率：

$$\boxed{\rho_{az} = \frac{D_a}{2} \cdot \sqrt{1 - \sin^2\beta \cdot \sin^2\alpha}} \tag{12}$$

**讨论**：
- 当 $\alpha = 0$（无俯冲）：$\rho_{az} = D_a/2$，恢复经典SAR方位分辨率
- 当 $\alpha > 0$（有俯冲）：$\rho_{az} < D_a/2$，分辨率**优于**经典极限
- 物理原因：俯冲使雷达在合成孔径期间同时获得水平位移和高度变化，高度变化导致 $y$-$h$ 平面内的投影距离 $R_{yz}$ 减小，增强了 $x$ 方向的角分辨率
- 对于典型参数（$\alpha < 10^\circ$，$\beta < 30^\circ$）：$\sin^2\beta\sin^2\alpha < 0.01$，$\rho_{az} \approx 0.995 \cdot D_a/2$，改善幅度约 $0.5\%$，在实际中通常**可忽略**，即 $\rho_{az} \approx D_a/2$

> **注**：若考虑双程天线方向图加权和旁瓣，实际方位分辨率还需乘以展宽因子（通常约 $1.1 \sim 1.3$）。

---

## 6. 总结

### 6.1 核心公式汇总

| 物理量 | 表达式 |
|:---|:---|
| **斜距方程** | $R^2(t) = R_{\min}^2 + V^2(t - t_c)^2$ |
| **零多普勒时刻** | $t_c = \dfrac{x\cos\alpha + (H-h)\sin\alpha}{V}$ |
| **最小斜距** | $R_{\min} = \sqrt{[x\sin\alpha - (H-h)\cos\alpha]^2 + R_0^2}$ |
| **多普勒中心** | $f_{dc} = \dfrac{2V\sin\alpha\sin\beta}{\lambda}$ |
| **多普勒调频率** | $f_r = -\dfrac{2V^2}{\lambda R_{\min}}$ |
| **垂直（距离向）分辨率** | $\rho_h = \dfrac{c}{2B\sin\beta}$ |
| **水平（方位向）分辨率** | $\rho_{az} \approx \dfrac{D_a}{2}$（小俯冲角近似） |

### 6.2 与传统地距SAR的本质区别

1. **成像平面不同**：立面成像的目标平面是垂直的 $(x, h)$ 平面，而非水平地面 $(x, y)$ 平面
2. **距离向定义不同**：立面成像中距离向沿立面垂直方向，分辨率由 $\rho_{sr}/\sin\beta$ 决定，而非 $\rho_{sr}/\sin\theta_{\text{inc}}$（地距投影）
3. **多普勒中心非零**：俯冲引起的垂直速度分量导致非零多普勒中心，这是立面成像SAR回波特性的关键特征，在成像算法设计中需要专门的去斜（de-skew）处理
4. **距离徙动含线性项**：波束中心与零多普勒不重合，导致距离走动；而成像算法中的距离徙动校正（RCMC）需同时处理走动和弯曲
5. **方位分辨率可优于经典极限**：俯冲增加了额外的角分辨率，但实际改善幅度通常很小

### 6.3 成像算法建议

基于上述分析，适合立面成像的SAR算法应考虑：
- **距离-多普勒域（RDA）**：需在方位压缩前进行距离徙动校正，且需考虑非零多普勒中心引起的距离-方位耦合
- **Chirp Scaling（CSA）**：可通过变标操作统一处理不同距离门处的距离徙动，适合大场景成像
- **$\omega$-$k$ 算法**：在二维频域精确处理，可自然适应非零多普勒中心几何，是立面成像的首选算法
