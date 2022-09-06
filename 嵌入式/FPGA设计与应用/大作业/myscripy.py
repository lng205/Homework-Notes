import cv2pynq as cv2
hdmi_in = cv2.video.hdmi_in
hdmi_out = cv2.video.hdmi_out

hdmi_in.configure(cv2.PIXEL_GRAY)
hdmi_out.configure(hdmi_in.mode)

hdmi_in.start()
hdmi_out.start()
threshold1=40
threshold2=255

while 1:
    inframe = hdmi_in.readframe()
    outframe = hdmi_out.newframe()
    cv2.Canny(inframe,threshold1,threshold2,edges=outframe)
    inframe.freebuffer()
    hdmi_out.writeframe(outframe)