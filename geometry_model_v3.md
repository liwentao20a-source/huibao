# 立面成像几何模型推导 v3

## 1. 坐标系与几何构型

### 1.1 坐标系定义

建立三维直角坐标系 $(x, y, h)$：

| 坐标轴 | 方向 | 说明 |
|--------|------|------|
| $x$ 轴 | 雷达飞行方向（水平） | 沿航迹方向 |
| $y$ 轴 | 垂直于飞行平面 | 侧视方向（雷达波束指向） |
| $h$ 轴 | 垂直向上 | 高度方向 |

- **地平面**：$h = 0$
- **雷达飞行平面**：$y = 0$（即 $x$-$h$ 垂直平面）
- **成像平面**：$y = 0$（$x$-$h$ 垂直平面），SAR 图像形成于此平面上

### 1.2 平台运动模型

雷达平台在 $y = 0$ 平面内以速度 $V$ 飞行，俯冲角为 $\alpha$（速度方向与水平面的夹角）。

$$\mathbf{v} = (V\cos\alpha,\; 0,\; -V\sin\alpha)$$

其中 $V_x = V\cos\alpha$ 为水平前向速度，$V_z = V\sin\alpha$ 为垂直下降速度。

设 $t = 0$（慢时间零时刻）雷达位于 $(0, 0, H)$，$H$ 为初始平台高度。雷达位置：

$$\boxed{\begin{cases}
x_p(t) = V\cos\alpha \cdot t \\[4pt]
y_p(t) = 0 \\[4pt]
h_p(t) = H - V\sin\alpha \cdot t
\end{cases}} \tag{1}$$

### 1.3 目标与波束几何

地面目标为三维物体（例如边长 2m 的立方体，顶点坐标 $x \in \{1,2\},\; y \in \{-1,1\},\; h \in \{0,1\}$）。目标点一般坐标为 $P = (x, y, h)$，其中 $y \neq 0$ 表示目标偏离飞行平面。

雷达波束侧视照射目标区域，波束中心在 $t = 0$ 时指向 $(0, y_c, h_c)$ 方向。波束在 $y$ 方向有展宽，使得不同 $y$ 坐标的目标均被照射。

---

## 2. 瞬时斜距

### 2.1 斜距方程

雷达至点目标 $P(x, y, h)$ 的瞬时斜距：

$$R(t) = \sqrt{\bigl[x - x_p(t)\bigr]^2 + \bigl[0 - y\bigr]^2 + \bigl[h_p(t) - h\bigr]^2}$$

代入 $(1)$ 式：

$$\boxed{R(t) = \sqrt{(x - V\cos\alpha \cdot t)^2 + y^2 + (H - V\sin\alpha \cdot t - h)^2}} \tag{2}$$

### 2.2 化为标准双曲形式

展开 $R^2(t)$：

$$\begin{aligned}
R^2(t) &= (x - V\cos\alpha \cdot t)^2 + y^2 + \bigl[(H-h) - V\sin\alpha \cdot t\bigr]^2 \\[4pt]
&= x^2 - 2xV\cos\alpha \cdot t + V^2\cos^2\alpha \cdot t^2 \\
&\quad + y^2 \\
&\quad + (H-h)^2 - 2(H-h)V\sin\alpha \cdot t + V^2\sin^2\alpha \cdot t^2 \\[4pt]
&= \bigl[x^2 + y^2 + (H-h)^2\bigr] - 2V\bigl[x\cos\alpha + (H-h)\sin\alpha\bigr]t + V^2(\cos^2\alpha + \sin^2\alpha)t^2 \\[4pt]
&= R_c^2 - 2V A t + V^2 t^2
\end{aligned}$$

其中定义：

$$\boxed{R_c^2(x, y, h) = x^2 + y^2 + (H-h)^2} \quad \text{(初始斜距平方)} \tag{3}$$

$$\boxed{A(x, h) = x\cos\alpha + (H-h)\sin\alpha} \quad \text{(投影位置参数)} \tag{4}$$

注意 $A$ **与 $y$ 无关**，这是后续分析的关键。

对 $R^2(t)$ 配方：

$$R^2(t) = (R_c^2 - A^2) + (Vt - A)^2 = R_{\min}^2 + V^2(t - t_c)^2 \tag{5}$$

### 2.3 零多普勒时刻

由 $(5)$ 式，斜距在 $t = t_c$ 处取最小值：

$$\boxed{t_c = \frac{A}{V} = \frac{x\cos\alpha + (H-h)\sin\alpha}{V}} \tag{6}$$

**重要性质**：$t_c$ 仅依赖于 $x$ 和 $h$，与 $y$ **无关**。这意味着相同 $(x, h)$ 但不同 $y$ 的目标具有相同的零多普勒时刻，即它们在方位向（多普勒域）上对齐。

### 2.4 最小斜距

$$\begin{aligned}
R_{\min}^2 &= R_c^2 - A^2 \\[4pt]
&= x^2 + y^2 + (H-h)^2 - \bigl[x\cos\alpha + (H-h)\sin\alpha\bigr]^2 \\[4pt]
&= x^2(1-\cos^2\alpha) + y^2 + (H-h)^2(1-\sin^2\alpha) - 2x(H-h)\cos\alpha\sin\alpha \\[4pt]
&= x^2\sin^2\alpha + y^2 + (H-h)^2\cos^2\alpha - 2x(H-h)\cos\alpha\sin\alpha \\[4pt]
&= \bigl[x\sin\alpha - (H-h)\cos\alpha\bigr]^2 + y^2
\end{aligned}$$

定义**成像平面投影量**：

$$\boxed{D(x, h) = x\sin\alpha - (H-h)\cos\alpha} \tag{7}$$

则最小斜距为：

$$\boxed{R_{\min}(x, y, h) = \sqrt{D^2(x, h) + y^2}} \tag{8}$$

**核心结论**：$R_{\min}$ 通过 $D(x, h)$ 依赖于 $x, h$，并直接受 $y^2$ 贡献。对于 $y \neq 0$ 的目标，$R_{\min} > |D|$。在成像平面 $y=0$ 上，$R_{\min}^{(0)} = |D(x, h)|$。

### 2.5 斜距方程的最终形式

$$R^2(t) = R_{\min}^2 + V^2(t - t_c)^2 = D^2 + y^2 + V^2(t - t_c)^2 \tag{9}$$

这一**精确双曲形式**对任意 $y$ 均成立，且与传统 SAR 的斜距方程结构一致。区别仅在于 $R_{\min}$ 包含了 $y$ 的贡献。

### 2.6 特例

- **$y = 0$（成像平面上的目标）**：$R_{\min} = |D| = |x\sin\alpha - (H-h)\cos\alpha|$
- **$\alpha = 0$（平飞，无俯冲）**：$D = -(H-h)$，$R_{\min} = \sqrt{(H-h)^2 + y^2}$，退化为经典平飞侧视SAR
- **参考场景中心 $(0, y_c, 0)$ 在 $t=0$**：$R_{\min} = \sqrt{(H\cos\alpha)^2 + y_c^2}$

---

## 3. 多普勒分析

### 3.1 瞬时多普勒频率

由 $(9)$ 式求导：

$$2R\frac{dR}{dt} = 2V^2(t - t_c) \quad\Rightarrow\quad \frac{dR}{dt} = \frac{V^2(t - t_c)}{R(t)}$$

多普勒频率：

$$\boxed{f_d(t) = -\frac{2}{\lambda}\frac{dR}{dt} = -\frac{2V^2}{\lambda R(t)}(t - t_c)} \tag{10}$$

### 3.2 多普勒中心频率

以波束中心时刻 $t = 0$ 计算参考点 $(0, y_c, 0)$ 的多普勒中心：

$$t_c^{\text{ref}} = \frac{H\sin\alpha}{V}, \quad R_0^{\text{ref}} = R(0)=\sqrt{H^2 + y_c^2}$$

注意这里的分母应取波束中心时刻的瞬时斜距 $R(0)$，而不是最小斜距 $R_{\min}^{\text{ref}}=\sqrt{H^2\cos^2\alpha+y_c^2}$。

$$f_{dc} = f_d(0)\big|_{\text{ref}} = \frac{2V H\sin\alpha}{\lambda R_0^{\text{ref}}}$$

定义参考俯角 $\beta$：

$$\sin\beta = \frac{H}{R_0^{\text{ref}}}=\frac{H}{\sqrt{H^2+y_c^2}}$$

则：

$$\boxed{f_{dc} \approx \frac{2V\sin\alpha \cdot \sin\beta}{\lambda}} \tag{11}$$

**$y$ 依赖性**：$f_{dc}$ 通过 $R_0^{\text{ref}}$ 弱依赖于 $y_c$（在分母中）。对于典型几何（$y_c \ll H$），该依赖可忽略。但对大 $y$ 目标，多普勒中心会略有偏移。

### 3.3 多普勒调频率

对 $(10)$ 式求导：

$$\begin{aligned}
f_r = \frac{df_d}{dt} &= -\frac{2V^2}{\lambda}\frac{d}{dt}\left(\frac{t - t_c}{R}\right) \\[4pt]
&= -\frac{2V^2}{\lambda}\left[\frac{1}{R} - \frac{t-t_c}{R^2}\frac{dR}{dt}\right] \\[4pt]
&= -\frac{2V^2}{\lambda R}\left[1 - \frac{V^2(t-t_c)^2}{R^2}\right]
\end{aligned}$$

在零多普勒时刻 $t = t_c$（$R = R_{\min}$）：

$$\boxed{f_r(x, y, h) = -\frac{2V^2}{\lambda R_{\min}(x, y, h)} = -\frac{2V^2}{\lambda\sqrt{D^2(x, h) + y^2}}} \tag{12}$$

**核心结论**：多普勒调频率**依赖于 $y$**。$|y|$ 越大，$R_{\min}$ 越大，$|f_r|$ 越小。这是 $y \neq 0$ 时方位向散焦的物理根源。

---

## 4. 距离徙动分析

### 4.1 精确徙动曲线

由 $(9)$ 式，距离徙动（RCM）精确为：

$$R(t) = \sqrt{R_{\min}^2 + V^2(t - t_c)^2} \tag{13}$$

这是标准的**双曲线**，对任意 $y$ 均成立。徙动曲线的形状由 $R_{\min}$（含 $y$）和 $V$ 共同决定。

### 4.2 泰勒展开（以 $t = t_c$ 为中心）

在零多普勒时刻 $t_c$ 附近展开：

$$R(t) = R_{\min} + \frac{V^2}{2R_{\min}}(t - t_c)^2 - \frac{V^4}{8R_{\min}^3}(t - t_c)^4 + \cdots \tag{14}$$

距离弯曲（二次项，主导项）：

$$R_{\text{curv}}(t) \approx \frac{V^2}{2R_{\min}}(t - t_c)^2 = \frac{V^2}{2\sqrt{D^2 + y^2}}(t - t_c)^2 \tag{15}$$

**$y$ 依赖性**：$|y|$ 增大 → $R_{\min}$ 增大 → 距离弯曲**减小**（因为 $\partial R/\partial t$ 与 $1/R_{\min}$ 成正比）。

### 4.3 以 $t = 0$ 为参考的距离走动

在实际 SAR 处理中，常在波束中心时刻 $t = 0$ 处展开。对参考点 $(0, y_c, 0)$，令 $R_0^{\text{ref}}=\sqrt{H^2+y_c^2}$：

$$R(t) \approx R_0^{\text{ref}} - \frac{V H\sin\alpha}{R_0^{\text{ref}}} \cdot t + \frac{V^2\left[(R_0^{\text{ref}})^2 - H^2\sin^2\alpha\right]}{2(R_0^{\text{ref}})^3} \cdot t^2$$

线性距离走动：$\displaystyle R_{\text{walk}} = -\frac{V H\sin\alpha}{R_0^{\text{ref}}} \cdot t$

该线性项源于俯冲引起的波束中心与零多普勒不重合，仅当 $\alpha = 0$（无俯冲）时才消失。

---

## 5. 成像平面上的几何映射

### 5.1 SAR 测量量

SAR 处理从回波中提取两个观测量：

1. **距离测量**（来自时间延迟）：$R_{\text{meas}} = R_{\min}(x, y, h) = \sqrt{D^2 + y^2}$
2. **多普勒测量**（来自方位相位）：$t_{\text{meas}} = t_c(x, h) = \dfrac{x\cos\alpha + (H-h)\sin\alpha}{V}$

### 5.2 成像平面映射（$y = 0$ 假设）

SAR 处理器**假设所有目标位于成像平面 $y = 0$**。对于观测量 $(R_{\text{meas}}, t_{\text{meas}})$，处理器反演目标在 $(x, h)$ 平面的视位置 $(x', h')$：

由 $y=0$ 模型：
$$\begin{cases}
R_{\text{meas}} = |D(x', h')| = |x'\sin\alpha - (H-h')\cos\alpha| \\[4pt]
t_{\text{meas}} = \dfrac{x'\cos\alpha + (H-h')\sin\alpha}{V}
\end{cases}$$

由第二式：$x'\cos\alpha + (H-h')\sin\alpha = V t_{\text{meas}} = A(x, h)$

由第一式（假设 $D'$ 与 $D$ 同号）：$x'\sin\alpha - (H-h')\cos\alpha = \pm R_{\text{meas}}$

解此 $2 \times 2$ 线性系统（系数矩阵行列式为 $-1$，自逆）：

$$\boxed{\begin{aligned}
x' &= A\cos\alpha + (\pm R_{\text{meas}})\sin\alpha = x + \sin\alpha \cdot (\pm\sqrt{D^2 + y^2} - D) \\[4pt]
H - h' &= A\sin\alpha - (\pm R_{\text{meas}})\cos\alpha = (H-h) - \cos\alpha \cdot (\pm\sqrt{D^2 + y^2} - D)
\end{aligned}} \tag{16}$$

其中符号取与 $D$ 相同以使 $y=0$ 时 $(x', h') = (x, h)$。

### 5.3 几何畸变

对于 $y \neq 0$ 的目标：

$$\begin{cases}
\Delta x = x' - x = \sin\alpha \cdot \bigl(\sqrt{D^2 + y^2} - |D|\bigr) \cdot \operatorname{sign}(D) \\[8pt]
\Delta h = h' - h = \cos\alpha \cdot \bigl(\sqrt{D^2 + y^2} - |D|\bigr) \cdot \operatorname{sign}(D)
\end{cases} \tag{17}$$

**物理含义**：
- 目标在图像中的视位置 $(x', h')$ 偏离真实位置 $(x, h)$
- 偏离方向沿 $\operatorname{sign}(D)(\sin\alpha, \cos\alpha)$，即**垂直于等 $D$ 线的方向**（也即 $R_{\min}$ 的梯度方向——距离向）
- 偏离量 $\delta R = \sqrt{D^2 + y^2} - |D| \approx \dfrac{y^2}{2|D|}$（$|y| \ll |D|$ 时）
- 这类似于传统 SAR 中的**叠掩（layover）效应**，但发生在成像平面内而非地距投影中

---

## 6. $y \neq 0$ 时的散焦效应

### 6.1 匹配滤波器失配机制

SAR 方位压缩使用匹配滤波器 $h(t) = \exp\!\bigl(j\frac{4\pi}{\lambda}\hat{R}(t)\bigr)$，其中 $\hat{R}(t)$ 是处理器假定的斜距模型。

对于成像平面 $(y=0)$ 上的像素点 $(x_i, h_i)$，处理器假定的斜距为：

$$\hat{R}(t) = \sqrt{D_i^2 + V^2(t - t_{ci})^2}, \quad D_i = x_i\sin\alpha - (H-h_i)\cos\alpha, \quad t_{ci} = \frac{x_i\cos\alpha + (H-h_i)\sin\alpha}{V}$$

而实际位于 $(x_i, y, h_i)$（$y \neq 0$）的目标的真实斜距为：

$$R(t) = \sqrt{D_i^2 + y^2 + V^2(t - t_{ci})^2}$$

压缩输出在 $t = 0$ 处的峰值响应为：

$$g(0) = \int_{-T_a/2}^{T_a/2} \exp\!\left(-j\frac{4\pi}{\lambda}\bigl[R(\tau) - \hat{R}(\tau)\bigr]\right) d\tau \tag{18}$$

### 6.2 相位误差

相位误差为：

$$\Delta\phi(\tau) = -\frac{4\pi}{\lambda}\Bigl[\sqrt{D^2 + y^2 + V^2\tau^2} - \sqrt{D^2 + V^2\tau^2}\Bigr] \tag{19}$$

其中 $\tau = t - t_c$ 为相对于零多普勒时刻的时间。

### 6.3 二次相位误差（QPE）

将 $(19)$ 在 $\tau = 0$ 附近展开：

$$\begin{aligned}
\sqrt{D^2 + y^2 + V^2\tau^2} &= R_{\min}(y)\sqrt{1 + \frac{V^2\tau^2}{R_{\min}^2(y)}} \approx R_{\min}(y) + \frac{V^2\tau^2}{2R_{\min}(y)} \\[4pt]
\sqrt{D^2 + V^2\tau^2} &= |D|\sqrt{1 + \frac{V^2\tau^2}{D^2}} \approx |D| + \frac{V^2\tau^2}{2|D|}
\end{aligned}$$

**常数相位误差**（不影响聚焦）：
$$\Delta\phi_0 = -\frac{4\pi}{\lambda}\bigl(R_{\min}(y) - |D|\bigr) = -\frac{4\pi}{\lambda}\bigl(\sqrt{D^2 + y^2} - |D|\bigr)$$

**二次相位误差**（导致散焦）：
$$\boxed{\Delta\phi_Q(\tau) = -\frac{2\pi V^2\tau^2}{\lambda}\left(\frac{1}{\sqrt{D^2 + y^2}} - \frac{1}{|D|}\right)} \tag{20}$$

### 6.4 多普勒调频率失配量

由 $(20)$ 式，实际目标与处理器假设之间的多普勒调频率差为：

$$\boxed{\Delta f_r(y) = f_r^{\text{actual}} - f_r^{\text{model}} = -\frac{2V^2}{\lambda}\left(\frac{1}{\sqrt{D^2 + y^2}} - \frac{1}{|D|}\right) = \frac{2V^2}{\lambda} \cdot \frac{\sqrt{D^2 + y^2} - |D|}{|D|\sqrt{D^2 + y^2}}} \tag{21}$$

由于 $\sqrt{D^2 + y^2} > |D|$（$y \neq 0$），有 $\Delta f_r > 0$，即 **$|f_r^{\text{actual}}| < |f_r^{\text{model}}|$**。处理器使用了过大的调频率，导致方位向欠聚焦。

**小 $y$ 近似**（$|y| \ll |D|$）：

$$\boxed{\Delta f_r \approx \frac{V^2 y^2}{\lambda |D|^3}} \tag{22}$$

失配量正比于 $y^2$，反比于 $|D|^3$（即距离越远，失配越小）。

### 6.5 合成孔径内的累积相位误差

在合成孔径时间 $[-T_a/2, T_a/2]$ 内，累积的二次相位误差（QPE）为：

$$\boxed{\Delta\Phi_{\text{QPE}} = \pi \cdot \Delta f_r \cdot \left(\frac{T_a}{2}\right)^2 = \frac{\pi V^2 T_a^2}{4\lambda}\left(\frac{1}{|D|} - \frac{1}{\sqrt{D^2 + y^2}}\right)} \tag{23}$$

小 $y$ 近似：

$$\Delta\Phi_{\text{QPE}} \approx \frac{\pi V^2 T_a^2 y^2}{8\lambda |D|^3} \tag{24}$$

### 6.6 聚焦深度（Depth of Focus）

SAR 成像中，通常要求 $|\Delta\Phi_{\text{QPE}}| < \pi/4$（Rayleigh 准则），以确保可接受的聚焦质量。

令 $(23) = \pi/4$，并代入合成孔径时间 $T_a \approx \dfrac{\lambda |D|}{D_a V}$（$D_a$ 为天线方位向尺寸，与第 7.3 节的方位分辨率推导保持一致）：

$$\frac{\pi V^2}{4\lambda} \cdot \frac{\lambda^2 D^2}{D_a^2 V^2} \cdot \frac{y^2}{2|D|^3} = \frac{\pi}{4}$$

化简得：

$$y_{\max}^2 = \frac{2 |D| \cdot D_a^2}{\lambda}$$

$$\boxed{y_{\max} \approx D_a \sqrt{\frac{2|D|}{\lambda}}} \tag{25}$$

**数值示例**：取 $D_a = 1\text{m}$，$\alpha = 10^\circ$，$|D| = 1000\text{m}$，$\lambda = 0.03\text{m}$（X波段）：

$$y_{\max} \approx 1 \times \sqrt{\frac{2 \times 1000}{0.03}} \approx 258\text{m}$$

对于典型的近场目标（$y \sim 1\text{m} \ll 258\text{m}$），散焦效应**可忽略**。但对于大 $y$、近距小 $|D|$ 或小天线孔径 $D_a$ 导致合成孔径时间较长的场景，散焦需考虑。

### 6.7 散焦的方位向展宽

二次相位误差会导致方位向冲击响应展宽，但展宽量与孔径加权、匹配滤波形式以及相位误差在孔径内的具体分布有关。后续仿真中建议直接通过点目标响应的主瓣宽度、PSLR、ISLR 等指标评估散焦程度，而不在此处引入未经验证的经验展宽公式。

---

## 7. 分辨率分析

### 7.1 斜距分辨率

发射带宽 $B$ 的 LFM 信号，脉冲压缩后斜距分辨率：

$$\rho_{sr} = \frac{c}{2B} \tag{26}$$

### 7.2 成像平面上的距离向分辨率

在 $y = 0$ 成像平面上，$R_{\min} = |D(x, h)|$。$R_{\min}$ 的梯度：

$$\nabla R_{\min} = \left(\frac{\partial R_{\min}}{\partial x}, \frac{\partial R_{\min}}{\partial h}\right) = \bigl(\operatorname{sign}(D)\sin\alpha,\; \operatorname{sign}(D)\cos\alpha\bigr) \tag{27}$$

$|\nabla R_{\min}| = \sqrt{\sin^2\alpha + \cos^2\alpha} = 1$。因此，沿梯度方向（距离向）的空间分辨率**等于**斜距分辨率：

$$\rho_{\text{range}} = \frac{c}{2B} \tag{28}$$

将距离向分辨率单元向坐标轴投影，乘以对应方向余弦，可得到距离向分辨单元边长在坐标轴上的投影长度：

$$\boxed{\rho_h^{\text{(range)}} = \rho_{sr} \cdot \cos\alpha = \frac{c}{2B}\cos\alpha}, \quad \boxed{\rho_x^{\text{(range)}} = \rho_{sr} \cdot \sin\alpha = \frac{c}{2B}\sin\alpha} \tag{29}$$

**物理意义**：距离向分辨单元沿 $\nabla R_{\min}$ 方向延伸 $\rho_{sr}$，该单元在 $h$ 轴上的投影为 $\rho_{sr}\cos\alpha$，在 $x$ 轴上的投影为 $\rho_{sr}\sin\alpha$。需要注意，这两个量是分辨单元几何投影长度，并不等同于“两个点仅沿 $h$ 轴或 $x$ 轴分离时的可分辨间隔”。若两个点只沿 $h$ 方向分离，距离测量给出的分辨间隔约为 $\rho_{sr}/|\cos\alpha|$；若只沿 $x$ 方向分离，则约为 $\rho_{sr}/|\sin\alpha|$。

- $\alpha \to 0$（平飞）：$\nabla R_{\min} = (0, 1)$，距离向为纯垂直方向。$\rho_h^{\text{(range)}} \to c/(2B)$，$\rho_x^{\text{(range)}} \to 0$——距离向不提供水平分辨。
- $\alpha \to 90^\circ$（垂直俯冲）：$\nabla R_{\min} = (1, 0)$，距离向为纯水平方向。$\rho_h^{\text{(range)}} \to 0$，$\rho_x^{\text{(range)}} \to c/(2B)$——距离向不提供垂直分辨。

### 7.3 方位向分辨率

方位向通过合成孔径实现。成像平面上方位向垂直于距离梯度方向。

平台速度在成像平面内的投影：$\mathbf{v}_{\text{img}} = (V\cos\alpha, -V\sin\alpha)$

方位向单位矢量：$\hat{\mathbf{u}}_{az} = (\cos\alpha, -\sin\alpha)$（垂直于 $\nabla R_{\min}$，当 $D>0$ 时）

波束足迹在方位向的移动速度：
$$V_g = \mathbf{v}_{\text{img}} \cdot \hat{\mathbf{u}}_{az} = V\cos^2\alpha + V\sin^2\alpha = V$$

多普勒调频率（$y=0$）：$f_r = -\dfrac{2V^2}{\lambda |D|}$

合成孔径时间：$T_a \approx \dfrac{|D| \cdot \theta_{az}}{V_g} = \dfrac{|D|\lambda}{D_a V}$

多普勒带宽：$B_d = |f_r| \cdot T_a = \dfrac{2V^2}{\lambda |D|} \cdot \dfrac{|D|\lambda}{D_a V} = \dfrac{2V}{D_a}$

方位向空间分辨率：

$$\boxed{\rho_{az} = \frac{V_g}{B_d} = \frac{V}{2V/D_a} = \frac{D_a}{2}} \tag{30}$$

**经典结果 $D_a/2$ 依然成立**，与俯冲角 $\alpha$ 无关。这是因为俯冲角同时影响 $f_r$（通过 $V^2$）和 $T_a$（通过 $V_g = V$），两者效应抵消。

### 7.4 二维分辨单元

在成像平面 $(x, h)$ 上，分辨单元为一个近似矩形（在 $(R_{\min}, t_c)$ 坐标下为矩形，在 $(x, h)$ 坐标下可能有旋转）：

| 方向 | 分辨率（投影值） | 说明 |
|:---|:---|:---|
| 距离向（沿 $\nabla R_{\min}$） | $c/(2B)$ | 斜距分辨率的直接映射 |
| 方位向（垂直于 $\nabla R_{\min}$） | $D_a/2$ | 合成孔径处理 |
| 垂直投影长度（$h$） | 距离向：$\frac{c}{2B}\cos\alpha$；方位向：$\frac{D_a}{2}\sin\alpha$ | 表示旋转分辨单元在 $h$ 轴上的投影，不直接等同于单轴可分辨间隔 |
| 水平投影长度（$x$） | 距离向：$\frac{c}{2B}\sin\alpha$；方位向：$\frac{D_a}{2}\cos\alpha$ | 表示旋转分辨单元在 $x$ 轴上的投影，不直接等同于单轴可分辨间隔 |

---

## 8. 与传统正侧视SAR的对比

| 特征 | 传统正侧视SAR | 本模型（立面成像） |
|:---|:---|:---|
| **飞行平面** | $h = H$（等高平面） | $y = 0$（$x$-$h$ 垂直平面） |
| **成像平面** | $h = 0$（地平面） | $y = 0$（$x$-$h$ 垂直平面） |
| **平台运动** | 仅水平：$\mathbf{v} = (V, 0, 0)$ | 含俯冲：$\mathbf{v} = (V\cos\alpha, 0, -V\sin\alpha)$ |
| **斜距方程** | $R^2 = R_0^2 + V^2(t-t_c)^2$ | $R^2 = D^2 + y^2 + V^2(t-t_c)^2$ |
| **$R_{\min}$** | $\sqrt{(x-x_0)^2 + R_0^2 + H^2}$ | $\sqrt{[x\sin\alpha - (H-h)\cos\alpha]^2 + y^2}$ |
| **$t_c$** | $x/V$ | $(x\cos\alpha + (H-h)\sin\alpha)/V$ |
| **多普勒中心** | $0$（零多普勒） | 非零：$\propto V\sin\alpha\sin\beta$ |
| **多普勒调频率** | $-2V^2/(\lambda R_{\min})$ | $-2V^2/(\lambda R_{\min})$（形式相同，但 $R_{\min}$ 含 $y$） |
| **距离走动** | 无（零多普勒中心） | **有**（源自俯冲垂直速度） |
| **$y \neq 0$ 目标** | 几何畸变（叠掩/透视收缩） | 几何畸变 + **方位散焦**（调频率失配） |
| **散焦来源** | 高程引起的叠掩 | $y$ 方向偏离成像平面引起的 $\Delta f_r$ |
| **距离向** | 地距方向（$\perp$ 飞行方向在地面投影） | 成像平面内 $\nabla R_{\min}$ 方向（$(\sin\alpha, \cos\alpha)$） |
| **方位向** | 沿航迹方向 | 成像平面内垂直于 $\nabla R_{\min}$ 方向 |
| **方位分辨率** | $D_a/2$ | $D_a/2$（与 $\alpha$ 无关） |
| **距离分辨单元垂直投影** | $\rho_{gr} = c/(2B\sin\theta_{\text{inc}})$ | $\rho_h^{\text{(range)}} = (c/(2B))\cos\alpha$ |

---

## 9. 总结

### 9.1 关键公式

| 物理量 | 表达式 |
|:---|:---|
| 斜距方程 | $R^2(t) = D^2 + y^2 + V^2(t - t_c)^2$ |
| 投影量 $D$ | $D = x\sin\alpha - (H-h)\cos\alpha$ |
| 零多普勒时刻 | $t_c = (x\cos\alpha + (H-h)\sin\alpha)/V$（与 $y$ 无关） |
| 最小斜距 | $R_{\min} = \sqrt{D^2 + y^2}$ |
| 多普勒中心 | $f_{dc} \approx 2V\sin\alpha\sin\beta/\lambda$ |
| 多普勒调频率 | $f_r = -2V^2/(\lambda\sqrt{D^2 + y^2})$ |
| 调频率失配 | $\Delta f_r \approx V^2 y^2/(\lambda |D|^3)$ |
| QPE（合成孔径内） | $\Delta\Phi_{\text{QPE}} \approx \pi V^2 T_a^2 y^2/(8\lambda |D|^3)$ |
| 聚焦深度 | $y_{\max} \approx D_a\sqrt{2|D|/\lambda}$ |
| 垂直投影长度（距离向） | $\rho_h^{\text{(range)}} = (c/(2B))\cos\alpha$ |
| 方位分辨率 | $\rho_{az} = D_a/2$ |

### 9.2 核心发现

1. **$t_c$ 与 $y$ 无关**：相同 $(x, h)$ 但不同 $y$ 的目标在方位向上对齐——它们在 SAR 图像中具有相同的方位坐标。这是由俯冲几何的对称性决定的。

2. **$R_{\min}$ 含 $y$ 贡献**：$R_{\min}^2 = D^2 + y^2$，导致目标在图像中的视位置沿距离向偏移（几何畸变/叠掩）。

3. **$f_r$ 依赖于 $y$**：多普勒调频率 $f_r \propto 1/\sqrt{D^2 + y^2}$。当处理器按 $y=0$ 的假设计算匹配滤波器时，$y \neq 0$ 的目标面临调频率失配，导致**方位向散焦**。

4. **散焦在典型场景中通常可忽略**：对于 $y \sim 1\text{m}$、$|D| \sim 1000\text{m}$ 量级，QPE 远小于 $\pi/4$。但在近距、高分辨率或大 $y$ 场景中需考虑。

5. **方位分辨率保持 $D_a/2$**：俯冲角不改变方位分辨率，因为 $V_g = V$ 且 $f_r$ 中的 $V^2$ 与 $T_a$ 中的 $1/V$ 抵消。

6. **距离向沿 $\nabla R_{\min}$ 方向**：在成像平面上，距离向并非纯垂直或纯水平，而是沿与水平面成 $\alpha$ 角的 $(\sin\alpha, \cos\alpha)$ 方向。分辨单元向坐标轴投影时，垂直分量为 $(c/(2B))\cos\alpha$，水平分量为 $(c/(2B))\sin\alpha$。
