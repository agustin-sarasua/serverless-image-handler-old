FROM lambci/lambda:build-python2.7

# Create deploy directory
WORKDIR /deploy
ENV WORKDIR /deploy

# Copy source
COPY . .

ENV TEMPLATE_OUTPUT_BUCKET cf-templates-dyvdnyma9kxw-us-east-1
ENV DIST_OUTPUT_BUCKET my-bucket-name
ENV VERSION my-version

RUN yum install yum-utils epel-release -y
RUN yum-config-manager --enable epel
RUN yum update -y
RUN yum install zip wget git libpng-devel libcurl-devel gcc python-devel libjpeg-devel -y
#alias sudo='sudo env PATH=$PATH'
RUN pip install setuptools==39.0.1
RUN pip install virtualenv==15.2.0

RUN git clone https://github.com/agustin-sarasua/serverless-image-handler.git

RUN chmod +x serverless-image-handler/deployment/run-unit-tests.sh

RUN cd serverless-image-handler/deployment && \
    ./build-s3-dist.sh $DIST_OUTPUT_BUCKET $VERSION

# docker run -e AWS_ACCESS_KEY_ID=XXX -e AWS_SECRET_ACCESS_KEY=XXX serverless-image-handler:latest aws s3 cp /deploy/serverless-image-handler/deployment/dist/ s3://my-bucket-name-us-east-1/serverless-image-handler/my-version/ --recursive --exclude "*" --include "*.zip"
# docker run -e AWS_ACCESS_KEY_ID=XXX -e AWS_SECRET_ACCESS_KEY=XXX serverless-image-handler:latest aws s3 cp /deploy/serverless-image-handler/deployment/dist/serverless-image-handler.template s3://cf-templates-dyvdnyma9kxw-us-east-1/serverless-image-handler/my-version/



# Make the dir and to install all packages into packages/
#RUN mkdir -p packages/ && \
#    pip install uuid -t packages/


#aws s3 cp /deploy/serverless-image-handler/deployment/dist/ s3://my-bucket-name-us-east-1/serverless-image-handler/my-version/ --recursive --exclude "*" --include "*.zip"
#aws s3 cp /deploy/serverless-image-handler/deployment/dist/serverless-image-handler.template s3://cf-templates-dyvdnyma9kxw-us-east-1/serverless-image-handler/my-version/


# Copy initial source codes into container.
# COPY lambda_function.py "$WORKDIR/lambda_function.py"



#https://s3.amazonaws.com/cf-templates-dyvdnyma9kxw-us-east-1/serverless-image-handler/my-version/serverless-image-handler.template


# Compress all source codes.
# RUN zip -r9 $WORKDIR/lambda.zip packages/ lambda_function.py

# CMD ["/bin/bash"]