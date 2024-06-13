# Use a base image with Python
FROM nvcr.io/nvidia/pytorch:24.03-py3 

ENV DERBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Stockholm
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
 

# Set working directory
WORKDIR /workspace
COPY . .
RUN python -m pip install --upgrade pip

#RUN pip install opencv-fixer==0.2.5
#RUN python -c "from opencv_fixer import AutoFix; AutoFix()"

# Run pip dependencies
#RUN apt-get update && apt-get install -y unzip wget git libgl1-mesa-glx  graphviz-dev

#RUN pip install accelerate transformers --upgrade
#RUN pip install -U langchain-community
#RUN pip install ffmpeg ffprobe ffmpeg-python
#RUN pip install xformers 
# ==0.0.23 --no-deps --index-url https://download.pytorch.org/whl/cu118

COPY requirements.lock.txt .
# other dependencies
RUN pip install -r requirements.lock.txt
RUN apt-get update && apt-get install git
# a modified gaussian splatting (+ depth, alpha rendering)
RUN git clone --recursive https://github.com/ashawkey/diff-gaussian-rasterization
RUN cd diff-gaussian-rasterization
RUN pip install ./diff-gaussian-rasterization
#RUN cd ../
# simple-knn
RUN pip install ./simple-knn
RUN cd ..
# for mesh extraction
#RUN pip install git+https://github.com/NVlabs/nvdiffrast/
RUN pip install git+https://github.com/NVlabs/nvdiffrast/

RUN pip install git+https://github.com/ashawkey/kiuikit
RUN pip install git+https://github.com/bytedance/MVDream
RUN pip install git+https://github.com/bytedance/ImageDream/#subdirectory=extern/ImageDream

#RUN pip uninstall opencv-python
RUN pip install --upgrade numpy
RUN pip install opencv-fixer==0.2.5
RUN python -c "from opencv_fixer import AutoFix; AutoFix()"
RUN apt update -y
RUN apt install -y libgl1-mesa-glx
RUN pip install opencv-contrib-python-headless

# Expose port 8888 for JupyterLab
EXPOSE 8888 9999 8000 7860 7861

# Start JupyterLab when the container runs
CMD ["sh", "-c", "tail -f /dev/null"]
#CMD ["jupyter", "lab", "--allow-root", "--ip=0.0.0.0","--NotebookApp.token=''", "--port=8888"]

