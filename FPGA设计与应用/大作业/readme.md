# 总结

[demo](https://youtu.be/L2u7KwEhHmg)

FPGA课程小组大作业，个人独立完成。本项目实现了对60帧视频流的边缘提取。做的工作较少，但过程中进行了丰富的学习和尝试，也有所收获。

主要参考[cv2pynq](https://github.com/xupsh/cv2pynq)项目。

Pynq属于前沿且小众的开发平台，中文资料少，英文资料也不多，对检索和学习能力有一定要求。

最初的想法是做一个类似XBOX360的体感水果忍者的cv项目，没想到这个大作业只给了几天时间，只好改为边缘检测。

在竞赛和数电实验中都接触过FPGA，芯片是Artix-7。本次是Pynq初体验，快速过了一遍[官方文档](https://github.com/Xilinx/PYNQ)及[例程](https://github.com/Xilinx/PYNQ_Workshop)，同时简单看了一点Zynq开发教程。Pynq的想法富有创意，在MCU和FPGA结合的Zynq基础上，加入Linux和Python软件系统，属于是全栈开发设备了。

项目使用的开发板是Pynq-Z2，硬件和Zynq XC7Z020-1CLG400C应该一致。MCU为Cortex-A9，FPGA为Artix-7，同时配备SD卡、音视频、以太网、ADC模块及若干GPIO管脚。设备涉及的技术面较广，适合教学研究，但初学者短时间内较难灵活运用。Pynq系统中应运行着Web应用，通过以太网和上位机交互，提供Jupyter和命令行界面。由于开发板内有独立的FPGA芯片，使用Vivado等应用进行PL(Programmable Logic)端开发也是可行的。

此前没有Linux开发经验，自学的Python也是半吊子水平，不过有一定的单片机和FPGA开发经验。自然地，本项目大部分开发调试时间都用于软件部分。

## cv2pynq

项目提供了一套Layout，即设计好的PL电路。同时项目也提供了含Layout设计内容的tcl文件。然而，Vivado并不支持版本向下兼容，tcl文件必须使用同一版本的Vivado才能打开，记得大概是要2018.2版，较为麻烦。此外，Layout中核心IP核的设计基本通过HLS(High Level Synthesis)软件实现，即利用高级语言描述硬件，并综合生成网表。Xilinx提供的Vitis HLS支持C/C++语言，但所用到的语法细节应仍需专门学习。以上两项原因使得在短时间内修改Layout进行开发较为困难，故选择在硬件基础上进行软件开发。

cv2pynq项目近两年没有维护更新，所用的Pynq镜像版本为2.3及更早。开发的第一个困难即是系统镜像。首先尝试了较新的2.6和2.7版本，均不理想。之后尝试寻找2.3版本未果，最后使用2.2版本镜像并成功运行。

参照cv2pynq例程和文档，尝试了Sobel、拉普拉斯、高斯、腐蚀、膨胀等基本图像处理功能。Canny算子由于与Python的cv2库效果存在差异，所以没有提供例程。但Layout中实现了相应的模块，因此自行设计Canny算子调用程序。调参设置上下限阈值，实现边缘检测。

之后想实现程序的上电自启动。学习Linux命令行开发和Pynq文件系统，尝试向系统启动环境文件中加入指令，调用Python3解释器并传入程序路径，没有成功，略遗憾。