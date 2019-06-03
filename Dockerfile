FROM lambci/lambda:build-python2.7

# Create deploy directory
WORKDIR /deploy
ENV WORKDIR /deploy

# Copy source
COPY . .

ENV TEMPLATE_OUTPUT_BUCKET cf-templates-dyvdnyma9kxw-us-east-1
ENV DIST_OUTPUT_BUCKET ligansa-functions
ENV VERSION $LATEST

RUN git clone https://github.com/awslabs/serverless-image-handler.git 

RUN cd serverless-image-handler/deployment && \
    ./build-s3-dist.sh $DIST_OUTPUT_BUCKET $VERSION

# Make the dir and to install all packages into packages/
#RUN mkdir -p packages/ && \
#    pip install uuid -t packages/

# Copy initial source codes into container.
# COPY lambda_function.py "$WORKDIR/lambda_function.py"

# Compress all source codes.
# RUN zip -r9 $WORKDIR/lambda.zip packages/ lambda_function.py

# CMD ["/bin/bash"]